import 'package:flutter/material.dart';
import 'package:furnitureapp/model/Order_model.dart';
import 'package:furnitureapp/services/data_service.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class WaitingForDelivery extends StatefulWidget {
  const WaitingForDelivery({Key? key}) : super(key: key);

  @override
  _WaitingForDeliveryState createState() => _WaitingForDeliveryState();
}

class _WaitingForDeliveryState extends State<WaitingForDelivery> {
  final Map<String, bool> _expandedStates = {};

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
              'Waiting For Delivery',
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
    return orders.where((order) => order.deliveryStatus == 'Shipping').toList();
  }

  Widget _buildOrderSection(OrderData orderData) {
    bool isExpanded = _expandedStates[orderData.id] ?? false;
    final DateTime estimatedDeliveryDate =
        orderData.orderDate.add(Duration(days: 3));
    final String formattedOrderDate =
        DateFormat('yyyy-MM-dd').format(orderData.orderDate);
    final String formattedEstimatedDate =
        DateFormat('yyyy-MM-dd').format(estimatedDeliveryDate);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ID: ${orderData.id}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Payment Status: ${orderData.paymentStatus}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Order Date: $formattedOrderDate',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Estimated Delivery Date: $formattedEstimatedDate',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildProductImages(orderData),
                ],
              ),
            ),
            if (isExpanded)
              Column(
                children: orderData.products.map((productOrder) {
                  return _buildProductContent(
                    imageUrl: productOrder.product.images?.first ?? '',
                    productName: productOrder.product.name ?? '',
                    productDetail: productOrder.product.shortDescription ?? '',
                    totalAmountLabel: 'Total Amount:',
                    totalAmount: '\$${productOrder.amount.toString()}',
                    // estimatedDeliveryDate:
                        // 'Estimated Delivery: $formattedEstimatedDate',
                    tags: ['Confirmation'],
                  );
                }).toList(),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _expandedStates[orderData.id] = !isExpanded;
                  });
                },
                child: Text(isExpanded ? 'See Less' : 'See More'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImages(OrderData orderData) {
    // Get the first three products or fewer if not available
    final products = orderData.products.take(3).toList();

    return Row(
      children: products.map((productOrder) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              productOrder.product.images?.first ?? '',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProductContent({
    required String imageUrl,
    required String productName,
    required String productDetail,
    required String totalAmountLabel,
    required String totalAmount,
    // required String estimatedDeliveryDate,
    required List<String> tags,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  ],
                ),
              ),
            ],
          ),
          _buildTags(tags),
          const SizedBox(height: 10),
          _buildTotalAmountSection(totalAmountLabel, totalAmount),
          const SizedBox(height: 10),
          // Text(
          //   estimatedDeliveryDate,
          //   style: const TextStyle(fontSize: 16, color: Colors.grey),
          // ),
        ],
      ),
    );
  }

  Widget _buildTags(List<String> tags) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: tags.map((tag) {
        return Padding(
          padding: const EdgeInsets.only(right: 1.0),
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
          ),
        ),
      ],
    );
  }
}
