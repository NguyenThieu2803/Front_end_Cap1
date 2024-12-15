import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/datatypes/anchor_types.dart' as ar;

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
  
  double scaleFactor = 0.2;
  List<ARNode> nodes = [];
  bool isPlacingObject = false;
  String? selectedNodeName;
  bool showPlaneOverlay = false;
  Timer? _hideTimer;
  
  bool _hasPermission = false;
  bool _isLoading = false;
  bool _isARSupported = false;

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
            onPanUpdate: (details) {
              if (selectedNode != null) {
                final delta = details.delta;
                setState(() {
                  selectedNode!.position = vector.Vector3(
                    selectedNode!.position.x + delta.dx * 0.01,
                    selectedNode!.position.y,
                    selectedNode!.position.z + delta.dy * 0.01,
                  );
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
          hit.worldTransform[13] - 1.5,
          hit.worldTransform[14] - 2.0,
        ),
        rotation: vector.Vector4(1.0, 0.0, 0.0, 0.0),
      );
      
      print("Đang thêm node với URI: ${newNode.uri}");
      
      await arObjectManager!.addNode(newNode);
      setState(() {
        nodes.add(newNode);
        selectedNode = newNode;
        selectedNodeName = nodeName;
      });
      print("Đã thêm node thành công");
      
      // Ẩn plane detection sau khi đặt model
      await arSessionManager?.onInitialize(
        showFeaturePoints: false,
        showPlanes: false,
        customPlaneTexturePath: "",
        showWorldOrigin: false,
        handlePans: true,
        handleRotation: true,
        handleTaps: true,
      );
      
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
      print("Bắt đầu di chuyển node $nodeName");
      setState(() {
        selectedNodeName = nodeName;
        selectedNode = nodes.firstWhere(
          (node) => node.name == nodeName,
          orElse: () => nodes.first,
        );
        isPlacingObject = false;
      });
    };

    arObjectManager!.onPanChange = (String nodeName) {
      if (selectedNodeName == nodeName && selectedNode != null) {
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
      print("Kết thúc di chuyển node $nodeName");
      if (selectedNodeName == nodeName && selectedNode != null) {
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
  }
}