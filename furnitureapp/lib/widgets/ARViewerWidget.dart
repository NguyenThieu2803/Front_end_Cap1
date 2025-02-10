import 'dart:async';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:furnitureapp/services/ar_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/datatypes/anchor_types.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'dart:math' as math;

class ARViewerWidget extends StatefulWidget {
  final String modelUrl;
  final String? modelFormat;
  final Map<String, dynamic>? modelConfig;

  const ARViewerWidget({
    super.key,
    required this.modelUrl,
    this.modelFormat = "glb",
    this.modelConfig,
  });

  @override
  _ARViewerWidgetState createState() => _ARViewerWidgetState();
}

class _ARViewerWidgetState extends State<ARViewerWidget> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  ARNode? selectedNode;
  
  double scaleFactor = 0.5; // Increased initial scale
  List<ARNode> nodes = [];
  bool isPlacingObject = false;
  String? selectedNodeName;
  bool showPlaneOverlay = false;
  Timer? _hideTimer;
  
  bool _hasPermission = false;
  bool _isLoading = false;
  bool _isARSupported = false;
  String? _errorMessage;
  bool isPositionLocked = false;
  Vector3 lockedPosition = Vector3.zero();
  double rotationX = 0.0;
  double rotationY = 0.0;
  double rotationZ = 0.0;

  // Add new state variables for enhanced rotation
  bool isRotating = false;
  double lastRotationX = 0.0;
  double lastRotationY = 0.0;
  double lastRotationZ = 0.0;
  double baseScale = 1.0;

  // Add new variables for rotation constraints
  static const double maxRotationY = math.pi / 2; // 90 degrees
  static const double minRotationY = -math.pi / 2; // -90 degrees
  bool isWallDetected = false;
  double wallDistance = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeAR();
  }

  // Kiểm tra hỗ trợ AR
  Future<bool> _checkARSupport() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS || 
          defaultTargetPlatform == TargetPlatform.android) {
        return true;
      }
      return false;
    } catch (e) {
      print("Lỗi kiểm tra hỗ trợ AR: $e");
      return false;
    }
  }

  Future<void> _initializeAR() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Kiểm tra quyền camera trước
      var status = await Permission.camera.status;
      if (!status.isGranted) {
        status = await Permission.camera.request();
      }

      if (!status.isGranted) {
        _showPermissionDialog();
        setState(() {
          _isLoading = false;
          _hasPermission = false;
        });
        return;
      }

      // Sau khi có quyền camera, kiểm tra hỗ trợ AR
      _isARSupported = await _checkARSupport();
      if (!_isARSupported) {
        _showARUnsupportedDialog();
        setState(() {
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _hasPermission = true;
        _isLoading = false;
      });
    } catch (e) {
      print("Lỗi khởi tạo AR: $e");
      _showErrorSnackBar('Không thể khởi tạo AR: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yêu Cầu Quyền'),
        content: const Text('Ứng dụng cần quyền truy cập camera để sử dụng AR'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings(); // Mở cài đặt ứng dụng để cấp quyền
            },
            child: const Text('Mở Cài Đặt'),
          ),
        ],
      ),
    );
  }

  void _showARUnsupportedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Không Hỗ Trợ AR'),
        content: const Text('Thiết bị của bạn không hỗ trợ tính năng Augmented Reality'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
      showAnimatedGuide: true, // Disable “move iPhone to start”
      showFeaturePoints: false,
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
    
    // Đảm bảo callback này được gọi
    arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    print("Đã đăng ký callback onPlaneOrPointTap");

    // Initialize other callbacks
    initializeARCallbacks();
  }

  // Automatically adjust model position based on camera distance
  void _updateModelDistance() {
    if (arSessionManager == null || selectedNode == null) return;
    final cameraPose = arSessionManager!.getCameraPose();
    // Example logic updating model's position or scale using cameraPose
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isARSupported) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('AR View'),
        ),
        body: Center(
          child: Text('Thiết bị không hỗ trợ AR'),
        ),
      );
    }

    if (!_hasPermission) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('AR View'),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Cần quyền truy cập camera để sử dụng AR'),
              ElevatedButton(
                onPressed: _initializeAR,
                child: const Text('Cấp quyền'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AR View'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onScaleStart: (ScaleStartDetails details) {
              if (selectedNode != null) {
                baseScale = scaleFactor;
              }
            },
            onScaleUpdate: (ScaleUpdateDetails details) {
              if (selectedNode != null) {
                setState(() {
                  if (details.scale != 1.0) {
                    // Handle scaling
                    double newScale = (baseScale * details.scale).clamp(0.1, 2.0);
                    scaleFactor = newScale;
                    selectedNode!.scale = vector.Vector3(newScale, newScale, newScale);
                  } else if (isPositionLocked) {
                    // Constrain rotation to horizontal only
                    double newRotationY = rotationY + details.focalPointDelta.dx * 0.01;
                    // Clamp rotation to prevent 360-degree turns
                    rotationY = newRotationY.clamp(minRotationY, maxRotationY);
                    
                    // Keep original position when rotating
                    final rotationMatrix = Matrix4.identity()
                      ..rotateY(rotationY);
                    
                    // Maintain distance from wall if detected
                    if (isWallDetected) {
                      selectedNode!.transform = Matrix4.identity()
                        ..setTranslation(vector.Vector3(
                          lockedPosition.x,
                          lockedPosition.y,
                          lockedPosition.z
                        ))
                        ..multiply(rotationMatrix)
                        ..scale(scaleFactor);
                    } else {
                      selectedNode!.transform = Matrix4.identity()
                        ..setTranslation(lockedPosition)
                        ..multiply(rotationMatrix)
                        ..scale(scaleFactor);
                    }
                  } else {
                    // Handle position change when unlocked
                    final delta = details.focalPointDelta;
                    selectedNode!.position = vector.Vector3(
                      selectedNode!.position.x + delta.dx * 0.01,
                      selectedNode!.position.y,
                      selectedNode!.position.z + delta.dy * 0.01,
                    );
                  }
                });
              }
            },
            child: ARView(
              onARViewCreated: onARViewCreated,
              planeDetectionConfig: PlaneDetectionConfig.horizontal,
            ),
          ),
          // Controls UI
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                // Position Lock Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: selectedNode != null && !isPositionLocked 
                          ? _lockPosition 
                          : null,
                      icon: const Icon(Icons.lock),
                      label: const Text("Lock Position"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        disabledBackgroundColor: Colors.grey,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: isPositionLocked ? _unlockPosition : null,
                      icon: const Icon(Icons.lock_open),
                      label: const Text("Unlock Position"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        disabledBackgroundColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.white),
                      onPressed: () => _updateScale(-0.1),
                    ),
                    Expanded(
                      child: Slider(
                        value: scaleFactor,
                        min: 0.1,
                        max: 2.0,
                        onChanged: (value) => _updateScale(value - scaleFactor),
                        activeColor: Colors.blue,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () => _updateScale(0.1),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: onRemoveAllObjects,
                  icon: const Icon(Icons.delete),
                  label: const Text("Xóa Model"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
                // Controls for rotation axes
                if (isPositionLocked && selectedNode != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.rotate_left, color: Colors.white),
                        onPressed: () => _rotateAroundAxis('x'),
                        tooltip: 'Rotate X-axis',
                      ),
                      IconButton(
                        icon: const Icon(Icons.rotate_right, color: Colors.white),
                        onPressed: () => _rotateAroundAxis('y'),
                        tooltip: 'Rotate Y-axis',
                      ),
                      IconButton(
                        icon: const Icon(Icons.sync, color: Colors.white),
                        onPressed: () => _rotateAroundAxis('z'),
                        tooltip: 'Rotate Z-axis',
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    arSessionManager?.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  Future<void> onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
    print("Đã nhận tap event");
    print("Số lượng hit results: ${hitTestResults.length}");
    
    if (!_isARSupported || hitTestResults.isEmpty || arObjectManager == null) {
      print("Điều kiện không thỏa: AR supported: $_isARSupported, Hit results empty: ${hitTestResults.isEmpty}, Object manager null: ${arObjectManager == null}");
      return;
    }
    
    final hit = hitTestResults.first;
    await detectWall(hit);
    
    try {
      print("ModelUrl: ${widget.modelUrl}");
      
      if (widget.modelUrl.isEmpty) {
        _showErrorSnackBar('URL model không hợp lệ');
        return;
      }

      if (!widget.modelUrl.toLowerCase().endsWith('.glb')) {
        print("URL model không phải định dạng GLB");
        _showErrorSnackBar('URL model phải có định dạng .glb');
        return;
      }

      String nodeName = 'node_${DateTime.now().millisecondsSinceEpoch}';
      
      print("Tạo node với URL: ${widget.modelUrl}");
      
      var newNode = ARNode(
        name: nodeName,
        type: NodeType.webGLB,
        uri: widget.modelUrl,
        scale: vector.Vector3(scaleFactor, scaleFactor, scaleFactor),
        position: vector.Vector3(
          hit.worldTransform[12],
          hit.worldTransform[13]-1.5,
          hit.worldTransform[14]-2,
        ),
        rotation: vector.Vector4(1.0, 0.0, 0.0, 0.0),
      );

      // Adjust position if wall detected
      if (isWallDetected) {
        // Keep slight distance from wall
        const wallOffset = 0.05; // 5cm offset
        newNode.position = vector.Vector3(
          newNode.position.x,
          newNode.position.y,
          newNode.position.z + wallOffset
        );
      }
      
      print("Đang thêm node với URI: ${newNode.uri}");
      
      var anchor = ARPlaneAnchor(
        transformation: hit.worldTransform,
        name: "anchor_${DateTime.now().millisecondsSinceEpoch}",
      );
      
      bool? didAddAnchor = await arAnchorManager?.addAnchor(anchor);
      
      if (didAddAnchor == true) {
        // Add node directly without using the anchor as parameter
        await arObjectManager?.addNode(newNode);
        setState(() {
          nodes.add(newNode);
          selectedNode = newNode;
          selectedNodeName = nodeName;
        });
        
        print("Đã thêm node thành công");
        
        // Hide plane detection after placing model
        await arSessionManager?.onInitialize(
          showFeaturePoints: false,
          showPlanes: false,
          customPlaneTexturePath: "",
          showWorldOrigin: false,
          handlePans: true,
          handleRotation: true,
          handleTaps: true,
        );
      }
      
    } catch (e) {
      print("Lỗi khi đặt model AR: $e");
      _showErrorSnackBar('Không thể đặt model: $e');
    }
  }

  Future<void> onRemoveAllObjects() async {
    try {
      if (arObjectManager != null && nodes.isNotEmpty) {
        // Xóa trực tiếp node hiện tại
        for (var node in nodes) {
          await arObjectManager!.removeNode(node);
        }
        
        setState(() {
          nodes.clear();
          selectedNode = null;
          selectedNodeName = null;
        });

        // Bật lại plane detection
        await arSessionManager?.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          customPlaneTexturePath: defaultTargetPlatform == TargetPlatform.android 
              ? "assets/triangle.png" 
              : "triangle",
          showWorldOrigin: false,
          handlePans: true,
          handleRotation: true,
          handleTaps: true,
        );

        // Đặt lại các thông số tracking
        arSessionManager?.onPlaneOrPointTap;
      }
    } catch (e) {
      print('Lỗi khi xóa object: $e');
      _showErrorSnackBar('Không thể xóa object: $e');
    }
  }

  void _updateScale(double delta) {
    setState(() {
      scaleFactor = (scaleFactor + delta).clamp(0.1, 2.0);
      if (nodes.isNotEmpty) {
        for (var node in nodes) {
          node.scale = vector.Vector3(scaleFactor, scaleFactor, scaleFactor);
          node.position = selectedNode?.position ?? node.position;
        }
      }
    });
  }

  void initializeARCallbacks() {
    arObjectManager!.onPanStart = (String nodeName) {
      if (!isPositionLocked) {
        print("Bắt đầu di chuyển node $nodeName");
        setState(() {
          selectedNodeName = nodeName;
          selectedNode = nodes.firstWhere(
            (node) => node.name == nodeName,
            orElse: () => nodes.first,
          );
          isPlacingObject = false;
        });
      }
    };

    arObjectManager!.onPanChange = (String nodeName) {
      if (!isPositionLocked && selectedNodeName == nodeName && selectedNode != null) {
        // Lấy transform từ node hiện tại
        final transform = selectedNode!.transform;
        final vector.Vector3 position = vector.Vector3(
          transform.getColumn(3).x,
          transform.getColumn(3).y,
          transform.getColumn(3).z,
        );
        
        setState(() {
          selectedNode!.position = position;
        });
        print("Di chuyển node $nodeName đến vị trí: $position");
      }
    };

    arObjectManager!.onPanEnd = (String nodeName, Matrix4? transform) {
      if (!isPositionLocked && selectedNodeName == nodeName && selectedNode != null) {
        print("Kết thúc di chuyển node $nodeName");
        // Sử dụng tham số transform được cung cấp
        final vector.Vector3 finalPosition = vector.Vector3(
          transform?.getColumn(3).x ?? selectedNode!.transform.getColumn(3).x,
          transform?.getColumn(3).y ?? selectedNode!.transform.getColumn(3).y,
          transform?.getColumn(3).z ?? selectedNode!.transform.getColumn(3).z,
        );
        
        setState(() {
          selectedNode!.position = finalPosition;
          // Cập nhật vị trí trong danh sách nodes
          final nodeIndex = nodes.indexWhere((node) => node.name == nodeName);
          if (nodeIndex != -1) {
            nodes[nodeIndex].position = finalPosition;
          }
        });
      }
    };

    // Thêm xử lý tap vào model
    arObjectManager!.onNodeTap = (nodes) {
      if (nodes.isNotEmpty) {
        final nodeName = nodes.first;
        setState(() {
          selectedNodeName = nodeName;
          selectedNode = this.nodes.firstWhere(
            (node) => node.name == nodeName,
            orElse: () => this.nodes.first,
          );
          isPlacingObject = false;
        });
        print("Đã chọn node $nodeName");
      }
    };

    // Long press to delete
    // Note: onLongPress is not defined for ARObjectManager, so this code is removed.
  }

  // Thêm xử lý ánh sáng và shadow
  void _setupLighting() {
    arSessionManager!.onInitialize(
      showFeaturePoints: true,
      showPlanes: true,
      customPlaneTexturePath: "assets/shadow_texture.png",
      showWorldOrigin: false,
      handlePans: true,
      handleRotation: true,
      handleTaps: true,
    );
  }
  
  // Cải thiện scale và rotation
  void _updateModelTransform(ARNode node) {
    final m = node.rotation;
    final sy = math.sqrt(m.entry(0,0) * m.entry(0,0) + m.entry(1,0) * m.entry(1,0));
    
    final x = math.atan2(m.entry(2,1), m.entry(2,2));
    final y = math.atan2(-m.entry(2,0), sy);
    final z = math.atan2(m.entry(1,0), m.entry(0,0));
    
    final transform = Matrix4.identity()
      ..setTranslation(node.position)
      ..rotateX(x)
      ..rotateY(y)
      ..rotateZ(z)
      ..scale(node.scale.x, node.scale.y, node.scale.z);
      
    node.transform = transform;
  }

  Future<void> _loadModel(String modelUrl) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Validate model
      if (!await ArService.validateModelUrl(modelUrl)) {
        throw Exception('Invalid model URL');
      }

      // Preload model
      final cachedPath = await ArService.preloadModel(modelUrl);
      if (cachedPath == null) {
        throw Exception('Failed to load model');
      }

      // Add node with cached model
      await _addNodeToScene(cachedPath);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addNodeToScene(String modelPath) async {
    if (arObjectManager == null) return;

    try {
      final node = ARNode(
        type: NodeType.webGLB,
        uri: modelPath,
        scale: vector.Vector3(scaleFactor, scaleFactor, scaleFactor),
        position: vector.Vector3(0, 0, -1),
        rotation: vector.Vector4(1.0, 0.0, 0.0, 0.0),
      );
      
      await arObjectManager!.addNode(node);
      setState(() {
        nodes.add(node);
        selectedNode = node;
      });
    } catch (e) {
      print('Error adding node: $e');
      rethrow;
    }
  }

  void _setPosition() {
    if (selectedNode != null) {
      setState(() {
        isPositionLocked = true;
        // Store current transform state if needed
        _updateModelTransform(selectedNode!);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Position locked')),
      );
    }
  }

  void _releasePosition() {
    setState(() {
      isPositionLocked = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Position released')),
    );
  }

  void _lockPosition() {
    if (selectedNode != null) {
      setState(() {
        isPositionLocked = true;
        lockedPosition = selectedNode!.position;
        // Store current rotation values
        lastRotationY = rotationY.clamp(minRotationY, maxRotationY);
        
        // If near wall, ensure proper positioning
        if (isWallDetected) {
          const wallOffset = 0.05; // 5cm offset
          lockedPosition = vector.Vector3(
            lockedPosition.x,
            lockedPosition.y,
            lockedPosition.z + wallOffset
          );
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Position locked - Drag to rotate in any direction')),
      );
    }
  }

  void _unlockPosition() {
    setState(() {
      isPositionLocked = false;
      // Preserve current transform when unlocking
      if (selectedNode != null) {
        selectedNode!.transform = Matrix4.identity()
          ..setTranslation(selectedNode!.position)
          ..rotateX(lastRotationX)
          ..rotateY(lastRotationY)
          ..rotateZ(lastRotationZ)
          ..scale(scaleFactor);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Position unlocked - Free to move and zoom')),
    );
  }

  void _rotateAroundAxis(String axis) {
    if (selectedNode != null && isPositionLocked) {
      setState(() {
        final double rotationAmount = 0.2; // Adjust rotation speed
        switch (axis) {
          case 'x':
            rotationX += rotationAmount;
            break;
          case 'y':
            rotationY += rotationAmount;
            break;
          case 'z':
            rotationZ += rotationAmount;
            break;
        }
        
        final rotationMatrix = Matrix4.identity()
          ..rotateX(rotationX)
          ..rotateY(rotationY)
          ..rotateZ(rotationZ);
        
        selectedNode!.transform = Matrix4.identity()
          ..setTranslation(lockedPosition)
          ..multiply(rotationMatrix)
          ..scale(scaleFactor
          );
      });
    }
  }

  // Add wall detection method
  Future<void> detectWall(ARHitTestResult hit) async {
    try {
      // Check if hit result indicates a vertical surface
      if (hit.type == ARHitTestResultType.plane) {
        setState(() {
          isWallDetected = true;
          // Calculate distance from wall
          wallDistance = math.sqrt(
            math.pow(hit.worldTransform[12], 2) +
            math.pow(hit.worldTransform[14], 2)
          );
        });
      } else {
        setState(() {
          isWallDetected = false;
          wallDistance = 0.0;
        });
      }
    } catch (e) {
      print('Error detecting wall: $e');
    }
  }
}
