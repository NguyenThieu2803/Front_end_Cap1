import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:furnitureapp/model/product.dart';
import 'package:furnitureapp/api/api.service.dart';
import 'package:furnitureapp/services/data_service.dart';
import 'package:furnitureapp/widgets/ProductReviews.dart';

class ProductPage extends StatefulWidget {
  final Product product; // Ensure this is typed as Product

  const ProductPage({super.key, required this.product});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantity = 1;
  double rating = 4; // Bạn có thể thay đổi giá trị này nếu cần
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
        favoriteProducts.add({
          'name': widget.product.name,
          'images': widget.product.images,
          'price': widget.product.price,
          'quantity': quantity,
        });
      } else {
        favoriteProducts.removeWhere((p) => p['name'] == widget.product.name);
      }
    });
  }

  void _addToCart() async {
    final productId = widget.product.id;
    if (productId == null) {
      print("Product ID is null. Cannot add to cart.");
      return;
    }

    try {
      bool success = await APIService.addToCart(productId, quantity);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product added to cart successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add product to cart.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFEDECF2), // Đặt màu nền thành 0xFFEDECF2
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          iconSize: 30,
          color: const Color(0xFF2B2321),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Product',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            color: Color(0xFF2B2321),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.black,
              ),
              iconSize: 30,
              onPressed: toggleFavorite,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildProductImage(screenWidth, screenHeight),
                  const SizedBox(height: 10),
                  _buildProductDetails(),
                  const SizedBox(height: 20),
                  const ProductReviews(), // Hiển thị đánh giá sản phẩm
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildProductImage(double screenWidth, double screenHeight) {
    final imageUrl = widget.product.images?.first ?? 'default_image.png'; // Provide a default image
    return Stack(
      children: [
        Center(
          child: Container(
            width: screenWidth,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.elliptical(250, 70),
                bottomRight: Radius.elliptical(250, 70),
              ),
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 10),
            child: Image.network(
            (widget.product.images != null && widget.product.images!.isNotEmpty)
                ? widget.product.images!.first
                : 'https://example.com/default_image.png',
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
            onPressed: () {}, // Xử lý khi nhấn vào nút AR
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        color: const Color(0xFFEDECF2), // Đặt màu nền cho thông tin sản phẩm
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.name!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            _buildRatingRow(),
            const SizedBox(height: 10),
            _buildProductSpecs(),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < (widget.product.rating ?? 0).round() ? Icons.star : Icons.star_border,
              color: Colors.black,
              size: 20,
            );
          }),
        ),
        const Spacer(),
        _buildQuantityControls(),
      ],
    );
  }

  Widget _buildQuantityControls() {
    return Row(
      children: [
        _buildQuantityButton(CupertinoIcons.minus, decreaseQuantity),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "$quantity",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B2321),
            ),
          ),
        ),
        _buildQuantityButton(CupertinoIcons.plus, increaseQuantity),
      ],
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: Icon(icon, size: 15),
      ),
    );
  }

  Widget _buildProductSpecs() {
    return Container(
      color: const Color(
          0xFFEDECF2), // Màu nền có thể giữ nguyên hoặc đổi theo ý bạn
      padding: const EdgeInsets.all(
          10), // Tùy chọn: thêm khoảng cách giữa viền và nội dung
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '- Kích thước:\n${widget.product.dimensions!.width} x ${widget.product.dimensions!.height} x ${widget.product.dimensions!.depth}',
            style: const TextStyle(
                fontSize: 15, color: Color(0xFF2B2321)), // Màu cho Kích thước
          ),
          const SizedBox(height: 10),
          Text(
            '- Chất liệu:\n${widget.product.material}',
            style: const TextStyle(
                fontSize: 15, color: Color(0xFF2B2321)), // Màu cho Chất liệu
          ),
          const SizedBox(height: 10),
          Text(
            '- Các tính năng:\n${widget.product.description}',
            style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF2B2321)), // Màu cho Các tính năng
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 90, // Đặt chiều cao cụ thể tại đây
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      color: Colors.white, // Đặt màu nền tại đây
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${(widget.product.price! * quantity).toStringAsFixed(0)}\$',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton.icon(
            onPressed: _addToCart, // Use the new method
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            label: const Text(
              'Add To Cart',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
