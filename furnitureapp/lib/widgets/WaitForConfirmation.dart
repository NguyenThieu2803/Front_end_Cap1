import 'package:flutter/material.dart';
import 'package:furnitureapp/services/data_service.dart';
import 'package:furnitureapp/model/Order_model.dart'; // Import the Order model

class WaitForConfirmation extends StatelessWidget {
  const WaitForConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(82.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(top: 18.0),
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
            margin: const EdgeInsets.only(top: 25.0),
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

  // Filter out orders where waitingConfirmation is true
  return orders.where((order) => !order.waitingConfirmation).toList();
}

  Widget _buildOrderSection(OrderData orderData) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        color: Colors.white,
        child: Column(
          children: orderData.products.map((productOrder) {
            return _buildProductContent(
              headerText: 'Order ID: ${orderData.id}',
              imageUrl: productOrder.product.images?.first ?? '',
              productName: productOrder.product.name ?? '',
              productDetail: productOrder.product.shortDescription ?? '',
              totalAmountLabel: 'Total Amount:',
              totalAmount: '\$${productOrder.amount.toString()}',
              quantity: productOrder.quantity.toString(),
              cancelButtonText: 'Cancel Order',
              tags: ['Pending', 'Confirmation'],
            );
          }).toList(),
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
    required String cancelButtonText,
    required List<String> tags,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductHeader(headerText),
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
                  ],
                ),
              ),
            ],
          ),
          _buildTags(tags),
          const SizedBox(height: 10),
          _buildTotalAmountSection(totalAmountLabel, totalAmount),
          const SizedBox(height: 10),
          _buildActionButtons(cancelButtonText),
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
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(String cancelButtonText) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            child: Text(
              cancelButtonText,
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}