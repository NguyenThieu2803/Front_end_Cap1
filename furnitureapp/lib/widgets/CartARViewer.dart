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

  @override
  void initState() {
    super.initState();
    _loadCartItems();
    _initializeAR(); // <-- Ensure we call it here
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

  Future<void> _handlePlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
    if (selectedModelId == null || hitTestResults.isEmpty) return;

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

    final hit = hitTestResults.first;

    try {
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
          hit.worldTransform[13],
          hit.worldTransform[14],
        ),
        rotation: Vector4(1.0, 0.0, 0.0, 0.0),
      );

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
      });

      _anchorMap[node.name] = anchor;

    } catch (e) {
      print('Error adding AR node: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error placing model: $e')),
      );
    }
  }

  void _toggleLock(String nodeName) {
    setState(() {
      modelLockStatus[nodeName] = !modelLockStatus[nodeName]!;
      if (modelLockStatus[nodeName]!) {
        modelLockedPositions[nodeName] = modelNodes[nodeName]!.position;
        modelRotations[nodeName] = 0.0;
      }
    });
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
                  icon: Icon(modelLockStatus[selectedNode!.name]! ? Icons.lock : Icons.lock_open),
                  onPressed: () => _toggleLock(selectedNode!.name),
                ),
                // Remove delete button from AppBar
              ],
            ),
        ],
      ),
      body: Stack(
        children: [
          GestureDetector(
            onPanUpdate: _handlePanUpdate,
            onPanEnd: _handlePanEnd,
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

        ],
      ),
    );
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (selectedNode == null || !isPositionLocked) return;

    setState(() {
      if (details.scale != 1.0) {
        scaleFactor = (scaleFactor * details.scale).clamp(0.1, 2.0);
        selectedNode!.scale = Vector3.all(scaleFactor);
      } else {
        double newRotationY = rotationY + details.focalPointDelta.dx * 0.01;
        rotationY = newRotationY.clamp(minRotationY, maxRotationY);
        
        final rotationMatrix = Matrix4.identity()..rotateY(rotationY);
        selectedNode!.transform = Matrix4.identity()
          ..setTranslation(lockedPosition)
          ..multiply(rotationMatrix)
          ..scale(scaleFactor);
      }
    });
  }

  void _updateScale(double value) {
    setState(() {
      scaleFactor = value;
      if (selectedNode != null) {
        selectedNode!.scale = Vector3.all(scaleFactor);
      }
    });
  }

  Future<void> _removeSelectedNode() async {
    if (selectedNode == null) return;

    try {
      final nodeName = selectedNode!.name;
      await arObjectManager?.removeNode(selectedNode!);
      nodes.remove(selectedNode);

      // Also remove the anchor from anchor manager
      final anchor = _anchorMap[nodeName];
      if (anchor != null) {
        await arAnchorManager?.removeAnchor(anchor);
        _anchorMap.remove(nodeName);
      }

      selectedNode = null;
      selectedModelId = null;
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
      showAnimatedGuide: false, // Disable default guide
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

    // Add plane detection callback
    arSessionManager!.onPlaneOrPointTap = (hits) {
      setState(() {
        if (!_planesFound) {
          _planesFound = true;
        }
      });
      _handlePlaneOrPointTapped(hits);
    };

    // Update plane detection callback
    arSessionManager!.onPlaneOrPointTap = (hits) {
      if (hits.isNotEmpty) {
        setState(() {
          _isPlaneDetected = true;
          _showPlaceButton = true;
        });
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

  void _handlePanUpdate(DragUpdateDetails details) {
    if (selectedNode == null) return;

    final nodeName = selectedNode!.name;
    if (modelLockStatus[nodeName]!) {
      // When locked, only allow rotation
      setState(() {
        modelRotations[nodeName] = modelRotations[nodeName]! + details.delta.dx * rotationSpeed;
        final rotationMatrix = Matrix4.rotationY(modelRotations[nodeName]!);
        selectedNode!.transform = Matrix4.identity()
          ..setTranslation(modelLockedPositions[nodeName]!)
          ..multiply(rotationMatrix)
          ..scale(scaleFactor);
      });
    } else {
      // When unlocked, allow position movement
      if (_lastPanPosition == null) {
        _lastPanPosition = details.globalPosition;
        return;
      }

      final delta = details.globalPosition - _lastPanPosition!;
      _lastPanPosition = details.globalPosition;

      setState(() {
        final newPosition = selectedNode!.position + Vector3(delta.dx * 0.02, 0, delta.dy * 0.02);
        selectedNode!.position = newPosition;
      });
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    _lastPanPosition = null;
  }

  @override
  void dispose() {
    arSessionManager?.dispose();
    super.dispose();
  }
}