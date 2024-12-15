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

class CartARViewer extends StatefulWidget {
  const CartARViewer({super.key});

  @override
  _CartARViewerState createState() => _CartARViewerState();
}

class _CartARViewerState extends State<CartARViewer> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  List<ARNode> nodes = [];
  Cart? cart;
  String? selectedModelId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AR Cart View'),
        backgroundColor: Color(0xFF2B2321),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: ARView(
              onARViewCreated: onARViewCreated,
              planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
            ),
          ),
          Expanded(
            flex: 1,
            child: _buildModelSelector(),
          ),
        ],
      ),
    );
  }

  Widget _buildModelSelector() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (cart?.items == null || cart!.items!.isEmpty) {
      return Center(child: Text('No 3D models available in cart'));
    }

    final modelsInCart = cart!.items!
        .where((item) => item.product?.model3d != null)
        .toList();

    if (modelsInCart.isEmpty) {
      return Center(child: Text('No 3D models available in cart'));
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: modelsInCart.length,
      itemBuilder: (context, index) {
        final item = modelsInCart[index];
        return GestureDetector(
          onTap: () => _onModelSelected(item),
          child: Container(
            width: 120,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedModelId == item.product?.id 
                    ? Colors.blue 
                    : Colors.grey,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  item.product?.images?.first ?? '',
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
                Text(
                  item.product?.name ?? '',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
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

    arSessionManager!.onPlaneOrPointTap = _handlePlaneOrPointTapped;
  }

  Future<void> _onModelSelected(CartItem item) async {
    if (item.product?.model3d == null) return;

    setState(() => selectedModelId = item.product?.id);
  }

  Future<void> _handlePlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
    if (selectedModelId == null || hitTestResults.isEmpty) return;

    final selectedItem = cart!.items!.firstWhere(
      (item) => item.product?.id == selectedModelId,
    );

    final modelUrl = selectedItem.product?.model3d;
    if (modelUrl == null) return;

    final hit = hitTestResults.first;

    try {
      final node = ARNode(
        type: NodeType.webGLB,
        uri: modelUrl,
        scale: Vector3(0.2, 0.2, 0.2),
        position: Vector3(
          hit.worldTransform.getColumn(3).x,
          hit.worldTransform.getColumn(3).y,
          hit.worldTransform.getColumn(3).z,
        ),
        rotation: Vector4(1.0, 0.0, 0.0, 0.0),
      );

      await arObjectManager?.addNode(node);
      setState(() {
        nodes.add(node);
      });
    } catch (e) {
      print('Error adding AR node: $e');
    }
  }

  @override
  void dispose() {
    arSessionManager?.dispose();
    super.dispose();
  }
} 