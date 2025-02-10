import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:furnitureapp/model/Cart_User_Model.dart';
import 'package:furnitureapp/services/data_service.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:permission_handler/permission_handler.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:http/http.dart' as http;

class CartARViewer extends StatefulWidget {
  const CartARViewer({super.key});

  @override
  _CartARViewerState createState() => _CartARViewerState();
}

class _CartARViewerState extends State<CartARViewer> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  ARNode? selectedNode;
  
  double scaleFactor = 0.5;
  List<ARNode> nodes = [];
  bool isPositionLocked = false;
  bool _planesFound = false;
  Vector3 lockedPosition = Vector3.zero();
  double rotationY = 0.0;
  static const double maxRotationY = math.pi / 2;
  static const double minRotationY = -math.pi / 2;
  static const double rotationSpeed = 0.01;
  Offset? _lastPanPosition;

  Cart? cart;
  String? selectedModelId;
  bool isLoading = true;
  Map<String, ARNode> modelNodes = {};

  // Track anchors for easy removal
  final Map<String, ARAnchor> _anchorMap = {};
  // A reticle node that moves around with the latest plane hit
  ARNode? _reticleNode;

  // Remove duplicate guide variables and consolidate into one
  bool _isPlaneDetected = false;
  bool _showPlaceButton = false;

  // Add these variables
  Map<String, bool> modelLockStatus = {};
  Map<String, Vector3> modelLockedPositions = {};
  Map<String, double> modelRotations = {};

  // Add new variables to track placed models count
  Map<String, int> placedModelCounts = {};

  // Add new variables for scaling
  double minScale = 0.1;
  double maxScale = 2.0;
  bool isScaling = false;

  // Add these variables for gesture handling
  double _baseScaleFactor = 1.0;
  bool _isScaling = false;
  bool _hasPlacedFirstModel = false; // Add this variable

  // Add new variables for model loading management
  final int maxModelSize = 20 * 1024 * 1024; // 20MB in bytes
  bool _isLoadingModel = false;
  Map<String, bool> _modelLoadingStates = {};

  Timer? _guideTimer; // Add this property

  @override
  void initState() {
    super.initState();
    _loadCartItems();
    _initializeAR(); // <-- Ensure we call it here
    
    // Change timer duration to 10 seconds
    _guideTimer = Timer(const Duration(seconds: 10), () {
      if (mounted && arSessionManager != null) {
        arSessionManager!.onInitialize(
          showAnimatedGuide: false, // Disable guide after 10 seconds
          showFeaturePoints: true,
          showPlanes: true,
          customPlaneTexturePath: defaultTargetPlatform == TargetPlatform.android 
              ? "assets/triangle.png"
              : "triangle",
          showWorldOrigin: false,
          handlePans: true,
          handleRotation: true,
          handleTaps: true,
        );
      }
    });
  }

  Future<void> _loadCartItems() async {
    try {
      final dataService = DataService();
      final loadedCart = await dataService.loadCart();
      setState(() {
        cart = loadedCart;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading cart items: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _initializeAR() async {
    // Basic camera permission check
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
      if (!status.isGranted) {
        print('Camera permission not granted');
        return;
      }
    }
    // Add other AR checks if needed
  }

  Widget _buildModelSelector() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final modelsInCart = cart?.items
        ?.where((item) => item.product?.model3d != null)
        .toList() ?? [];

    if (modelsInCart.isEmpty) {
      return const Center(child: Text('No 3D models available in cart'));
    }

    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: modelsInCart.length,
        itemBuilder: (context, index) {
          final item = modelsInCart[index];
          final isSelected = selectedModelId == item.product?.id;
          
          return GestureDetector(
            onTap: () => _onModelSelected(item),
            child: Container(
              width: 100,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
                color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    item.product?.images?.first ?? '',
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    item.product?.name ?? '',
                    style: TextStyle(
                      color: isSelected ? Colors.blue : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onModelSelected(CartItem item) async {
    if (item.product?.model3d == null) return;
    
    setState(() {
      selectedModelId = item.product?.id;
      if (modelNodes.containsKey(selectedModelId)) {
        selectedNode = modelNodes[selectedModelId];
      }
    });
  }

  Future<bool> _checkModelSize(String modelUrl) async {
    try {
      final Uri uri = Uri.parse(modelUrl);
      final response = await http.head(uri);
      final contentLength = int.parse(response.headers['content-length'] ?? '0');
      if (contentLength > maxModelSize) {
        print('Model size: ${(contentLength / (1024 * 1024)).toStringAsFixed(2)}MB');
      }
      return contentLength <= maxModelSize;
    } catch (e) {
      print('Error checking model size: $e');
      return true; // Allow loading if size check fails
    }
  }

  Future<void> _handlePlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
    if (selectedModelId == null || hitTestResults.isEmpty || _isLoadingModel) return;

    final selectedItem = cart!.items!.firstWhere(
      (item) => item.product?.id == selectedModelId,
    );

    // Check if we've reached the placement limit for this model
    if ((placedModelCounts[selectedModelId] ?? 0) >= (selectedItem.quantity ?? 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã đạt giới hạn số lượng cho sản phẩm này')),
      );
      return;
    }

    final modelUrl = selectedItem.product?.model3d;
    if (modelUrl == null) return;

    // Check if we've already verified this model
    if (!_modelLoadingStates.containsKey(modelUrl)) {
      setState(() => _isLoadingModel = true);
      
      try {
        // Check model size before loading
        final isModelSizeOk = await _checkModelSize(modelUrl);
        if (!isModelSizeOk) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Model quá lớn, không thể tải. Vui lòng chọn model khác.')),
          );
          _modelLoadingStates[modelUrl] = false;
          setState(() => _isLoadingModel = false);
          return;
        }
        _modelLoadingStates[modelUrl] = true;
      } catch (e) {
        print('Error checking model: $e');
        setState(() => _isLoadingModel = false);
        return;
      }
    } else if (!_modelLoadingStates[modelUrl]!) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Model này không được hỗ trợ.')),
      );
      return;
    }

    final hit = hitTestResults.first;

    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang tải model...')),
      );

      // Create anchor first
      final anchor = ARPlaneAnchor(
        transformation: hit.worldTransform,
        name: "anchor_${DateTime.now().millisecondsSinceEpoch}",
      );
      
      final didAddAnchor = await arAnchorManager?.addAnchor(anchor);
      if (didAddAnchor != true) return;

      // Then create and add node
      final node = ARNode(
        type: NodeType.webGLB,
        uri: modelUrl,
        scale: Vector3(scaleFactor, scaleFactor, scaleFactor),
        position: Vector3(
          hit.worldTransform[12],
          hit.worldTransform[13]-0.01, // Adjusted height
          hit.worldTransform[14], // Adjusted distance
        ),
        rotation: Vector4(1.0, 0.0, 0.0, 0.0),
      );

      // Remove loading state listener
      setState(() => _isLoadingModel = false);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      await arObjectManager?.addNode(node);
      setState(() {
        nodes.add(node);
        modelNodes[selectedModelId!] = node;
        selectedNode = node;
        _showPlaceButton = false; // Hide place button after placement
        modelLockStatus[node.name] = false; // Initialize lock status
        modelLockedPositions[node.name] = node.position; // Store initial position
        modelRotations[node.name] = 0.0; // Initialize rotation
        // Increment the placed count for this model
        placedModelCounts[selectedModelId!] = (placedModelCounts[selectedModelId!] ?? 0) + 1;
        // Hide plane detection after first model placement
        if (!_hasPlacedFirstModel) {
          _hasPlacedFirstModel = true;
          // Update AR session to hide planes
          arSessionManager?.onInitialize(
            showAnimatedGuide: false,
            showFeaturePoints: false,
            showPlanes: false,
            customPlaneTexturePath: "",
            showWorldOrigin: false,
            handlePans: true,
            handleRotation: true,
            handleTaps: true,
          );
        }
      });

      _anchorMap[node.name] = anchor;

    } catch (e) {
      print('Error adding AR node: $e');
      setState(() => _isLoadingModel = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error placing model: $e')),
      );
    }
  }

  void _toggleLock(String nodeName) {
    if (!modelLockStatus.containsKey(nodeName)) {
      modelLockStatus[nodeName] = false;
    }
    
    setState(() {
      modelLockStatus[nodeName] = !modelLockStatus[nodeName]!;
      if (modelLockStatus[nodeName]!) {
        // Store current position when locking
        modelLockedPositions[nodeName] = modelNodes[nodeName]!.position;
        modelRotations[nodeName] = 0.0;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          modelLockStatus[nodeName]! 
            ? 'Đã khóa vị trí. Vuốt ngang để xoay mô hình.' 
            : 'Đã mở khóa vị trí. Có thể di chuyển mô hình.',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Remove or modify _removeNode function to disable deletion
  Future<void> _removeNode(String nodeName) async {
    // Disable node removal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Không thể xóa mô hình đã đặt')),
    );
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Cart View'),
        backgroundColor: const Color(0xFF2B2321),
        actions: [
          if (selectedNode != null)
            Row(
              children: [
                IconButton(
                  icon: Icon(modelLockStatus[selectedNode!.name] ?? false 
                    ? Icons.lock 
                    : Icons.lock_open),
                  onPressed: () => _toggleLock(selectedNode!.name),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeSelectedNode(),
                ),
              ],
            ),
        ],
      ),
      body: Stack(
        children: [
          GestureDetector(
            onScaleStart: (ScaleStartDetails details) {
              _baseScaleFactor = scaleFactor;
              _isScaling = details.pointerCount > 1; // Only scale with 2 fingers
              _lastPanPosition = null;
            },
            onScaleUpdate: (ScaleUpdateDetails details) {
              if (selectedNode == null) return;
              final nodeName = selectedNode!.name;

              setState(() {
                if (details.pointerCount > 1 && details.scale != 1.0) {
                  // Handle scaling with 2 fingers
                  scaleFactor = (_baseScaleFactor * details.scale).clamp(minScale, maxScale);
                  selectedNode!.scale = Vector3.all(scaleFactor);
                } else if (modelLockStatus[nodeName] ?? false) {
                  // Handle rotation when locked
                  final delta = details.focalPointDelta.dx;
                  modelRotations[nodeName] = (modelRotations[nodeName] ?? 0.0) + delta * 0.01;
                  final rotationMatrix = Matrix4.rotationY(modelRotations[nodeName]!);
                  selectedNode!.transform = Matrix4.identity()
                    ..setTranslation(modelLockedPositions[nodeName] ?? Vector3.zero())
                    ..multiply(rotationMatrix)
                    ..scale(scaleFactor);
                } else {
                  // Handle movement when unlocked - Invert the delta values
                  final delta = details.focalPointDelta;
                  final newPosition = selectedNode!.position + 
                      Vector3(-delta.dx * 0.003, 0, -delta.dy * 0.003); // Invert both X and Z
                  selectedNode!.position = newPosition;
                  modelLockedPositions[nodeName] = newPosition;
                }
              });
            },
            onScaleEnd: (ScaleEndDetails details) {
              _isScaling = false;
            },
            child: ARView(
              onARViewCreated: onARViewCreated,
              planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
            ),
          ),
          
          // Product selection UI at top
          if (selectedModelId == null)
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.white.withOpacity(0.9),
                child: const Text(
                  'Chọn sản phẩm để đặt',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Selected product indicator with place button
          if (selectedModelId != null && !isPositionLocked)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image.network(
                      cart?.items?.firstWhere(
                        (item) => item.product?.id == selectedModelId
                      ).product?.images?.first ?? '',
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('Chạm vào mặt phẳng để đặt'),
                    ),
                    ElevatedButton(
                      onPressed: () => placeSelectedModel(),
                      child: const Text('Đặt'),
                    ),
                  ],
                ),
              ),
            ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildModelSelector(),
                // ...existing control buttons...
              ],
            ),
          ),

          // Fix the button's onPressed callback
          if (selectedModelId != null && _showPlaceButton)
            Positioned(
              bottom: 140, // Above model selector
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  onPressed: () => _handlePlaneOrPointTapped([
                    ARHitTestResult(
                      ARHitTestResultType.plane,
                      2.0, // distance from camera in meters
                      Matrix4.identity(), // world transform matrix
                    ),
                  ]),
                  child: const Text(
                    'Đặt Nội Thất',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),

          // Add placement counter for selected model
          if (selectedModelId != null)
            Positioned(
              top: 70,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  'Đã đặt: ${placedModelCounts[selectedModelId] ?? 0}/${cart?.items?.firstWhere(
                    (item) => item.product?.id == selectedModelId
                  ).quantity ?? 0}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

          // Remove the delete buttons for each model
          // Remove the following section:
          // for (var node in nodes)
          //   Positioned(...)

          // Add controls for selected model
          if (selectedNode != null)
            Positioned(
              bottom: 140,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        modelLockStatus[selectedNode!.name] ?? false 
                          ? Icons.lock 
                          : Icons.lock_open,
                        color: Colors.blue,
                      ),
                      onPressed: () => _toggleLock(selectedNode!.name),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeSelectedNode(),
                    ),
                  ],
                ),
              ),
            ),

          // Add scale indicator
          if (selectedNode != null)
            Positioned(
              top: 120,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => _updateScale(scaleFactor - 0.1),
                    ),
                    Text('${(scaleFactor * 100).toInt()}%'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _updateScale(scaleFactor + 0.1),
                    ),
                  ],
                ),
              ),
            ),

          // Add loading indicator
          if (_isLoadingModel)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  void _updateScale(double value) {
    if (selectedNode == null) return;
    setState(() {
      scaleFactor = value.clamp(minScale, maxScale);
      selectedNode!.scale = Vector3.all(scaleFactor);
    });
  }

  Future<void> _removeSelectedNode() async {
    if (selectedNode == null) return;

    try {
      final nodeName = selectedNode!.name;
      await arObjectManager?.removeNode(selectedNode!);
      nodes.remove(selectedNode);
      
      // Decrease the placed count for this model
      if (selectedModelId != null) {
        placedModelCounts[selectedModelId!] = (placedModelCounts[selectedModelId!] ?? 1) - 1;
      }

      // Remove the anchor
      final anchor = _anchorMap[nodeName];
      if (anchor != null) {
        await arAnchorManager?.removeAnchor(anchor);
        _anchorMap.remove(nodeName);
      }

      modelNodes.remove(selectedModelId);
      modelLockStatus.remove(nodeName);
      modelLockedPositions.remove(nodeName);
      modelRotations.remove(nodeName);

      setState(() {
        selectedNode = null;
        selectedModelId = null;
      });
    } catch (e) {
      print('Error removing node: $e');
    }
  }

  void onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;
    arAnchorManager = anchorManager;

    arSessionManager!.onInitialize(
      showAnimatedGuide: true,
      showFeaturePoints: true,
      showPlanes: true,
      customPlaneTexturePath: defaultTargetPlatform == TargetPlatform.android 
          ? "assets/triangle.png"
          : "triangle",
      showWorldOrigin: false,
      handlePans: true,
      handleRotation: true,
      handleTaps: true,
    );

    arObjectManager!.onInitialize();

    // Chỉ đăng ký một callback duy nhất cho plane detection và tap
    arSessionManager!.onPlaneOrPointTap = (hits) {
      if (!_hasPlacedFirstModel && hits.isNotEmpty) {
        // Tắt guide khi phát hiện mặt phẳng đầu tiên
        arSessionManager!.onInitialize(
          showAnimatedGuide: false,
          showFeaturePoints: true,
          showPlanes: true,
          customPlaneTexturePath: defaultTargetPlatform == TargetPlatform.android 
              ? "assets/triangle.png"
              : "triangle",
          showWorldOrigin: false,
          handlePans: true,
          handleRotation: true,
          handleTaps: true,
        );
      }
      
      // Xử lý tap để đặt model
      if (hits.isNotEmpty && selectedModelId != null) {
        _handlePlaneOrPointTapped(hits);
      }
    };
  }

  // Preview placement using a small “reticle” node that moves to the latest hit
  Future<void> _previewPlacement(List<ARHitTestResult> hits) async {
    if (hits.isEmpty) return;

    final hit = hits.first;
    // If reticle doesn't exist, create it
    if (_reticleNode == null) {
      _reticleNode = ARNode(
        type: NodeType.webGLB,
        uri: "assets/reticle.glb", // Create or pick a small .glb for your indicator
        scale: Vector3(0.1, 0.1, 0.1),
      );
      await arObjectManager?.addNode(_reticleNode!);
    }

    // Move reticle to the new plane position
    _reticleNode!.position = Vector3(
      hit.worldTransform[12],
      hit.worldTransform[13],
      hit.worldTransform[14],
    );
  }

  // Finalize the placement of the selected model at the reticle’s position
  Future<void> placeSelectedModel() async {
    if (selectedModelId == null || _reticleNode == null) return;

    // Retrieve your model URL
    final selectedItem = cart!.items!
        .firstWhere((item) => item.product?.id == selectedModelId);
    final modelUrl = selectedItem.product?.model3d;
    if (modelUrl == null) return;

    // Create a plane anchor at the reticle node’s position
    final anchor = ARPlaneAnchor(
      transformation: _reticleNode!.transform,
      name: "anchor_${DateTime.now().millisecondsSinceEpoch}",
    );
    final didAddAnchor = await arAnchorManager?.addAnchor(anchor);
    if (didAddAnchor != true) return;

    final node = ARNode(
      type: NodeType.webGLB,
      uri: modelUrl,
      scale: Vector3(scaleFactor, scaleFactor, scaleFactor),
      position: _reticleNode!.position,
      rotation: Vector4(1.0, 0.0, 0.0, 0.0),
    );

    // Add to scene
    await arObjectManager?.addNode(node);
    nodes.add(node);
    selectedNode = node;
    // Store the anchor for removal later
    _anchorMap[node.name] = anchor;
  }

  // Add new method to handle furniture placement
  Future<void> _placeFurniture() async {
    if (!_isPlaneDetected || selectedModelId == null) return;

    final selectedItem = cart!.items!.firstWhere(
      (item) => item.product?.id == selectedModelId,
    );

    try {
      final node = ARNode(
        type: NodeType.webGLB,
        uri: selectedItem.product!.model3d!,
        scale: Vector3(scaleFactor, scaleFactor, scaleFactor),
        position: Vector3(0, -1.0, -2.0), // Adjusted initial position
        rotation: Vector4(1.0, 0.0, 0.0, 0.0),
      );

      await arObjectManager?.addNode(node);
      setState(() {
        nodes.add(node);
        selectedNode = node;
      });

      // Update AR session after placing model
      await arSessionManager?.onInitialize(
        showAnimatedGuide: false,
        showFeaturePoints: false,
        showPlanes: true,
        customPlaneTexturePath: "",
        showWorldOrigin: false,
        handlePans: true,
        handleRotation: true,
        handleTaps: true,
      );
    } catch (e) {
      print('Error placing furniture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể đặt nội thất: $e')),
      );
    }
  }

  @override
  void dispose() {
    _guideTimer?.cancel(); // Cancel timer
    arSessionManager?.dispose();
    super.dispose();
  }
}