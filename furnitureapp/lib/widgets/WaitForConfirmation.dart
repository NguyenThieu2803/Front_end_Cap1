import 'package:flutter/material.dart';
import 'package:furnitureapp/services/data_service.dart';
import 'package:furnitureapp/model/Order_model.dart';
import 'package:furnitureapp/widgets/OrderInformation.dart';

class WaitForConfirmation extends StatefulWidget {
  const WaitForConfirmation({Key? key}) : super(key: key);

  @override
  State<WaitForConfirmation> createState() => _WaitForConfirmationState();
}

class _WaitForConfirmationState extends State<WaitForConfirmation> {
  final Map<String, bool> _expandedOrders = {};

  String _formatPrice(double price) {
    return '\$${price.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(58.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Container(
            margin: const EdgeInsets.only(top: 5.0),
            child: const Text(
              'Wait For Confirmation',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: FutureBuilder<List<OrderData>>(
        future: _loadOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders available.'));
          } else {
            return Container(
              color: const Color(0xFFEDECF2),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return _buildOrderSection(snapshot.data![index]);
                },
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<OrderData>> _loadOrders() async {
    List<OrderData> orders = await DataService().getOrdersByUserId();
    return orders.where((order) => !order.waitingConfirmation).toList();
  }

  double _calculateTotalAmount(OrderData orderData) {
    return orderData.totalAmount;
  }

  Widget _buildOrderSection(OrderData orderData) {
    bool isExpanded = _expandedOrders[orderData.id] ?? false;
    bool hasMultipleProducts = orderData.products.length > 1;

    return Padding(
      padding: const EdgeInsets.only(top: 15, right: 10, left: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderInformation(orderData: orderData),
            ),
          );
        },
        child: Card(
          color: Colors.white,
          child: Column(
            children: [
              _buildProductContent(
                headerText: 'Order ID: ${orderData.id}',
                imageUrl: orderData.products.first.product.images?.first ?? '',
                productName: orderData.products.first.product.name ?? '',
                productDetail: orderData.products.first.product.shortDescription ?? '',
                totalAmountLabel: hasMultipleProducts && !isExpanded 
                    ? 'Total Amount (${orderData.products.length} items):' 
                    : 'Amount:',
                totalAmount: hasMultipleProducts && !isExpanded 
                    ? _formatPrice(_calculateTotalAmount(orderData))
                    : _formatPrice(orderData.products.first.amount),
                quantity: orderData.products.first.quantity.toString(),
                tags: ['Pending', 'Confirmation'],
                showExpandButton: false,
                isExpanded: isExpanded,
                onExpandPressed: null,
              ),
              
              if (hasMultipleProducts && isExpanded)
                ...orderData.products.skip(1).map((productOrder) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                    child: _buildProductContent(
                      headerText: '',
                      imageUrl: productOrder.product.images?.first ?? '',
                      productName: productOrder.product.name ?? '',
                      productDetail: productOrder.product.shortDescription ?? '',
                      totalAmountLabel: 'Amount:',
                      totalAmount: _formatPrice(productOrder.amount),
                      quantity: productOrder.quantity.toString(),
                      tags: ['Pending', 'Confirmation'],
                      showExpandButton: false,
                      isExpanded: false,
                      onExpandPressed: null,
                    ),
                  );
                }).toList(),

              if (hasMultipleProducts)
                Column(
                  children: [
                    Center(
                      child: IconButton(
                        icon: Icon(
                          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: Colors.deepOrange,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            _expandedOrders[orderData.id] = !isExpanded;
                          });
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductContent({
    required String headerText,
    required String imageUrl,
    required String productName,
    required String productDetail,
    required String totalAmountLabel,
    required String totalAmount,
    required String quantity,
    required List<String> tags,
    required bool showExpandButton,
    required bool isExpanded,
    required Function()? onExpandPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (headerText.isNotEmpty) _buildProductHeader(headerText),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      productDetail,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Quantity: $quantity',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildTags(tags),
          const SizedBox(height: 10),
          _buildTotalAmountSection(totalAmountLabel, totalAmount),
        ],
      ),
    );
  }

  Widget _buildProductHeader(String headerText) {
    return Row(
      children: [
        const Spacer(),
        Text(
          headerText,
          style: const TextStyle(
            color: Colors.deepOrange,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildTags(List<String> tags) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: tags.map((tag) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: _buildTag(tag),
        );
      }).toList(),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepOrange),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.deepOrange,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildTotalAmountSection(String label, String totalAmount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          totalAmount,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}