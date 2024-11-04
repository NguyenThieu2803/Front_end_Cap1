import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:furnitureapp/admin/EditProduct.dart';

class Product {
  String name;
  String image;
  double price;

  Product({
    required this.name,
    required this.image,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      image: json['image'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'price': price,
    };
  }
}

class ProductManagementItemSamples extends StatefulWidget {
  const ProductManagementItemSamples({super.key});

  @override
  _ProductManagementItemSamplesState createState() =>
      _ProductManagementItemSamplesState();
}

class _ProductManagementItemSamplesState
    extends State<ProductManagementItemSamples> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final String response =
          await rootBundle.loadString('assets/detail/AdminProduct.json');
      final data = await json.decode(response);
      setState(() {
        products = (data['products'] as List)
            .map((item) => Product.fromJson(item))
            .toList();
      });
    } catch (e) {
      print('Error loading products: $e');
      // Khởi tạo một số sản phẩm mẫu nếu không load được JSON
      setState(() {
        products = [
          Product(name: "Table A2343B", price: 100, image: "assets/images/1.png"),
          Product(name: "Chair B45", price: 50, image: "assets/images/2.png"),
          Product(name: "Lamp C23", price: 30, image: "assets/images/3.png"),
        ];
      });
    }
  }

  Future<void> saveProducts() async {
    try {
      final data = {
        'products': products.map((product) => product.toJson()).toList()
      };
      final String jsonString = json.encode(data);
      // Lưu jsonString vào file - Trong thực tế bạn sẽ cần implement phần này
      print('Saved products: $jsonString');
    } catch (e) {
      print('Error saving products: $e');
    }
  }

  void deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
      saveProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < products.length; i++)
          Container(
            height: 110,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  margin: const EdgeInsets.only(right: 15),
                  child: Image.asset(products[i].image),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          products[i].name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2B2321),
                          ),
                        ),
                        Text(
                          "\$${products[i].price.toStringAsFixed(0)}", // Chỉnh sửa ở đây
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2B2321),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => deleteProduct(i),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 25),
                    InkWell(
                      onTap: () {
                        // Thêm logic để chỉnh sửa sản phẩm ở đây
                        Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProduct()),
                );
                      },
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF2B2321),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
