import 'package:flutter/material.dart';
import 'package:furnitureapp/widgets/FavoriteItemSamples.dart';
import 'package:furnitureapp/widgets/HomeItemsWidget.dart';

class ProductPage extends StatefulWidget {
  final product; // Nhận một đối tượng Product

  const ProductPage({super.key, required this.product}); // Constructor

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantity = 1;
  double rating = 4; // Bạn có thể thay đổi theo yêu cầu của mình
  bool isFavorite = false;

  List<Map<String, dynamic>> favoriteProducts = [];

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) {
        // Thêm sản phẩm vào danh sách yêu thích
        favoriteProducts.add({
          'name': widget.product.name,
          'image': widget.product.image,
          'price': widget.product.price,
          'quantity': quantity,
        });
      } else {
        // Xóa sản phẩm khỏi danh sách yêu thích
        favoriteProducts.removeWhere((p) => p['name'] == widget.product.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          iconSize: 40,
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context); // Quay lại trang trước
          },
        ),
        title: const Text(
          'Product',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.black,
            ),
            iconSize: 35,
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.elliptical(200, 80),
                        bottomRight: Radius.elliptical(200, 80),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1.5,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Image.asset(
                      widget.product.image,
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.4,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  right: screenWidth * 0.01,
                  top: screenHeight * 0.28,
                  child: IconButton(
                    icon: const Icon(Icons.view_in_ar, size: 40),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                color: Colors.grey[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < rating.round()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.black,
                              size: 15,
                            );
                          }),
                        ),
                        const Spacer(), // Đẩy các thành phần về bên trái
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: decreaseQuantity,
                            ),
                            Text(
                              '$quantity',
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: increaseQuantity,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '+ Kích thước:\n${widget.product.size}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '+ Chất liệu:\n${widget.product.material}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '+ Các tính năng:\n${widget.product.features}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${(widget.product.price * quantity).toStringAsFixed(0)}\$',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text(
                        'Add To Cart',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
