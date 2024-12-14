import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';

class ARViewerWidget extends StatefulWidget {
  final String modelUrl;
  final String? modelFormat;
  final Map<String, dynamic>? modelConfig;

  const ARViewerWidget({
    super.key,
    required this.modelUrl,
    this.modelFormat,
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
  double rotationAngle = 0.0;
  bool isPlacingObject = false;
  String? selectedNodeName;
  bool showPlaneOverlay = false;
  Timer? _hideTimer;

  bool get canPlaceObject => isPlacingObject || nodes.isEmpty;

  @override
  void dispose() {
    _hideTimer?.cancel();
    arSessionManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR View'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                // Thanh điều chỉnh kích thước
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
                        onChanged: (value) {
                          _updateScale(value - scaleFactor);
                        },
                        activeColor: Colors.blue,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () => _updateScale(0.1),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Nút xóa model
                ElevatedButton.icon(
                  onPressed: onRemoveAllObjects,
                  icon: const Icon(Icons.delete),
                  label: const Text("Remove Model"),
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
      customPlaneTexturePath: "assets/triangle.png",
      showWorldOrigin: false,
      handlePans: true,
      handleRotation: true,
      handleTaps: true,
    );

    arObjectManager!.onInitialize();
    
    // Khởi tạo các callback
    initializeARCallbacks();

    // Xử lý sự kiện chạm vào mặt phẳng
    arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
  }

  Future<void> onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
    if (!canPlaceObject || hitTestResults.isEmpty) return;
    
    final hit = hitTestResults.first;
    
    try {
      String nodeName = 'node_${DateTime.now().millisecondsSinceEpoch}';
      
      var newNode = ARNode(
        name: nodeName,
        type: NodeType.webGLB,
        uri: widget.modelUrl,
        scale: Vector3(scaleFactor, scaleFactor, scaleFactor),
        position: Vector3(
          hit.worldTransform.getColumn(3).x,
          hit.worldTransform.getColumn(3).y,
          hit.worldTransform.getColumn(3).z,
        ),
        rotation: Vector4(1.0, 0.0, 0.0, 0.0),
      );
      
      await arObjectManager!.addNode(newNode);
      setState(() {
        nodes.add(newNode);
        selectedNode = newNode;
        selectedNodeName = nodeName;
      });

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
      print("Error adding AR node: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error placing model: $e')),
      );
    }
  }

  Future<void> onRemoveAllObjects() async {
    try {
      if (arObjectManager != null) {
        // Xóa tất cả các node hiện có
        final nodesToRemove = List<ARNode>.from(nodes);
        for (final node in nodesToRemove) {
          await arObjectManager!.removeNode(node);
          nodes.remove(node);
        }
        
        setState(() {
          selectedNode = null;
          selectedNodeName = null;
          isPlacingObject = true;
          showPlaneOverlay = true; // Hiển thị lại plane detection
        });
        
        // Khởi tạo lại session với plane detection được bật
        await arSessionManager?.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          customPlaneTexturePath: "assets/triangle.png",
          showWorldOrigin: false,
          handlePans: true,
          handleRotation: true,
          handleTaps: true,
        );

        // Đặt lại các thông số tracking
        arSessionManager?.onPlaneOrPointTap;
      }
    } catch (e) {
      print('Error removing objects: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing objects: $e')),
      );
    }
  }

  Future<void> onRemoveSelectedObject() async {
    if (selectedNode != null && arObjectManager != null) {
      try {
        await arObjectManager!.removeNode(selectedNode!);
        setState(() {
          nodes.remove(selectedNode);
          if (nodes.isNotEmpty) {
            selectedNode = nodes.last;
            selectedNodeName = selectedNode?.name;
          } else {
            selectedNode = null;
            selectedNodeName = null;
          }
        });
      } catch (e) {
        print('Error removing selected object: $e');
      }
    }
  }

  void _updateScale(double delta) {
    setState(() {
      scaleFactor = (scaleFactor + delta).clamp(0.1, 2.0);
      if (nodes.isNotEmpty) {
        for (var node in nodes) {
          node.scale = Vector3(scaleFactor, scaleFactor, scaleFactor);
          node.position = selectedNode?.position ?? node.position;
        }
      }
    });
  }

  void _updatePlaneVisibility(bool show) {
    if (!mounted) return;
    
    setState(() {
      showPlaneOverlay = show;
    });
    
    // Đảm bảo hủy timer cũ nếu có
    _hideTimer?.cancel();
    
    if (show) {
      // Tạo timer mới để ẩn plane sau 2 giây
      _hideTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          arSessionManager?.onInitialize(
            showFeaturePoints: false,
            showPlanes: false,  // ặt thành false để ẩn plane
            customPlaneTexturePath: "",
            showWorldOrigin: false,
            handlePans: true,
            handleRotation: true,
          );
          setState(() {
            showPlaneOverlay = false;
          });
        }
      });
    }
    
    // Chỉ cập nhật hiển thị plane khi cần hiển thị
    if (show) {
      arSessionManager?.onInitialize(
        showFeaturePoints: false,
        showPlanes: true,
        customPlaneTexturePath: "assets/triangle.png",
        showWorldOrigin: false,
        handlePans: true,
        handleRotation: true,
      );
    }
  }

  void initializeARCallbacks() {
    arObjectManager!.onPanStart = (String nodeName) {
      print("Started moving node $nodeName");
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
        final Vector3 position = Vector3(
          transform.getColumn(3).x,
          transform.getColumn(3).y,
          transform.getColumn(3).z,
        );
        
        setState(() {
          selectedNode!.position = position;
        });
        print("Moving node $nodeName to position: $position");
      }
    };

    arObjectManager!.onPanEnd = (String nodeName, Matrix4? transform) {
      print("Finished moving node $nodeName");
      if (selectedNodeName == nodeName && selectedNode != null) {
        // Sử dụng tham số transform được cung cấp thay vì lấy từ selectedNode
        final Vector3 finalPosition = Vector3(
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
        print("Tapped node $nodeName");
      }
    };
  }
}
