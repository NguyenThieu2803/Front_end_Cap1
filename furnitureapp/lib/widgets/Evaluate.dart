import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:furnitureapp/widgets/EvaluateFeedBack.dart';

class Evaluate extends StatelessWidget {
  const Evaluate({Key? key}) : super(key: key);

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
              'Evaluate',
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
      body: FutureBuilder<List<Product>>(
        future: loadProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final products = snapshot.data!;
            return Container(
              color: const Color(0xFFEDECF2),
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildProductSection(
                    context, // Thêm context vào đây
                    headerText: product.headerText,
                    imageUrl: product.imageUrl,
                    productName: product.productName,
                    productDetail: product.productDetail,
                    totalAmountLabel: product.totalAmountLabel,
                    totalAmount: product.totalAmount,
                    estimatedDeliveryDate: product.estimatedDeliveryDate,
                    returnButtonText: product.returnButtonText,
                    cancelButtonText: product.cancelButtonText,
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<Product>> loadProducts() async {
    String jsonString = await rootBundle.loadString('assets/detail/Evaluate.json');
    final jsonResponse = json.decode(jsonString);
    return (jsonResponse['products'] as List)
        .map((product) => Product.fromJson(product))
        .toList();
  }

  Widget _buildProductSection(
    BuildContext context, { // Thêm BuildContext vào đây
    required String headerText,
    required String imageUrl,
    required String productName,
    required String productDetail,
    required String totalAmountLabel,
    required String totalAmount,
    required String estimatedDeliveryDate,
    required String returnButtonText,
    required String cancelButtonText,
  }) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        color: Colors.white,
        child: Padding(
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
              const SizedBox(height: 10),
              _buildTotalAmountSection(totalAmountLabel, totalAmount),
              const SizedBox(height: 10),
              Text(
                estimatedDeliveryDate,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              _buildActionButtons(context, returnButtonText, cancelButtonText), // Cập nhật ở đây
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductHeader(String headerText) {
    Color textColor;
    if (headerText == 'Delivered') {
      textColor = Colors.red;
    } else if (headerText == 'The order has been delivered') {
      textColor = Colors.green;
    } else {
      textColor = Colors.deepOrange;
    }

    return Row(
      children: [
        const Spacer(),
        Text(
          headerText,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        ),
      ],
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

  Widget _buildActionButtons(BuildContext context, String returnButtonText, String cancelButtonText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // Hành động cho nút hủy
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.grey),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            child: Text(
              cancelButtonText,
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // Điều hướng đến trang EvaluateFeedBack
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EvaluateFeedBack()),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            child: Text(
              returnButtonText,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class Product {
  String headerText;
  String imageUrl;
  String productName;
  String productDetail;
  String totalAmountLabel;
  String totalAmount;
  String estimatedDeliveryDate;
  String returnButtonText;
  String cancelButtonText;

  Product({
    required this.headerText,
    required this.imageUrl,
    required this.productName,
    required this.productDetail,
    required this.totalAmountLabel,
    required this.totalAmount,
    required this.estimatedDeliveryDate,
    required this.returnButtonText,
    required this.cancelButtonText,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      headerText: json['headerText'],
      imageUrl: json['imageUrl'],
      productName: json['productName'],
      productDetail: json['productDetail'],
      totalAmountLabel: json['totalAmountLabel'],
      totalAmount: json['totalAmount'],
      estimatedDeliveryDate: json['estimatedDeliveryDate'],
      returnButtonText: json['returnButtonText'],
      cancelButtonText: json['cancelButtonText'],
    );
  }
}

class ReturnPage extends StatelessWidget {
  const ReturnPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Return Page'),
      ),
      body: Center(
        child: const Text('This is the return page!'),
      ),
    );
  }
}
