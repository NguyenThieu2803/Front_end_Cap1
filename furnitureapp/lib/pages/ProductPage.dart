import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:furnitureapp/model/product.dart';
import 'package:furnitureapp/api/api.service.dart';
import 'package:furnitureapp/widgets/ProductReviews.dart';
import 'package:furnitureapp/config/config.dart';


class ProductPage extends StatefulWidget {
  final Product product;

  const ProductPage({super.key, required this.product});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  int quantity = 1;
  bool isFavorite = false;
  Color? selectedColor;

  List<Map<String, dynamic>> favoriteProducts = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    if (widget.product.id == null) {
      throw ArgumentError('Product ID không được để trống');
    }
    _tabController = TabController(
        length: 2, vsync: this); // Two tabs for Details and Reviews
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void increaseQuantity() {
    if (widget.product.stockQuantity != null &&
        quantity < widget.product.stockQuantity!) {
      setState(() {
        quantity++;
      });
    } else {
      // Hiển thị thông báo khi đạt giới hạn stock
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Cannot exceed available stock (${widget.product.stockQuantity} items)'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
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
      appBar: AppBar(
        title: Text(
          widget.product.name!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFEDECF2),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProductImage(screenWidth, screenHeight),
                  const SizedBox(height: 20),
                  _buildProductDetails(),
                  const SizedBox(height: 20),
                  _buildTabBar(),
                  _buildTabBarView(),
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
    final imageUrl = widget.product.images?.first ?? 'default_image.png';
    return Stack(
      children: [
        Center(
          child: Container(
            width: screenWidth,
            height: screenHeight * 0.4,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.elliptical(250, 70),
                bottomRight: Radius.elliptical(250, 70),
              ),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        color: const Color(0xFFEDECF2),
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
            Row(
              children: [
                Text(
                  'Color: ${selectedColor != null ? _getColorNameFromColor(selectedColor!) : "Please choose product color"}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2B2321),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getColorNameFromColor(Color color) {
    if (color == Colors.brown) return 'brown';
    if (color == Colors.black) return 'black';
    if (color == Colors.white) return 'white';
    if (color == Colors.grey) return 'grey';
    if (color == Colors.red) return 'red';
    if (color == Colors.blue) return 'blue';
    if (color == Colors.green) return 'green';
    if (color == Colors.yellow) return 'yellow';
    return 'chưa có';
  }

  Color _colorFromString(String colorString) {
    switch (colorString.toLowerCase()) {
      case 'brown':
        return Colors.brown;
      case 'black':
        return Colors.black;
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'white':
        return Colors.white;
      case 'grey':
        return Colors.grey;
      default:
        return Colors.transparent; // Mặc định cho các màu không xác định
    }
  }

  Widget _buildRatingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Brand: ${widget.product.brand ?? 'N/A'}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2B2321),
          ),
        ),
        const SizedBox(width: 8),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: decreaseQuantity,
            ),
            Text(
              '$quantity',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: increaseQuantity,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductSpecs() {
    return Container(
      color: const Color(0xFFEDECF2),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Specifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B2321),
            ),
          ),
          const SizedBox(height: 10),
          _buildSpecItem('- Style:', widget.product.style ?? 'N/A'),
          _buildSpecItem('- Dimensions:',
              '${widget.product.dimensions!.width} x ${widget.product.dimensions!.depth} x ${widget.product.dimensions!.height} (L x W x H)'),
          _buildSpecItem('- Material:', widget.product.material ?? 'N/A'),
          _buildSpecItem('- Weight:', '${widget.product.weight ?? 0} kg'),
          _buildSpecItem('- Stock Quantity:',
              '${widget.product.stockQuantity ?? 0} items'),
          _buildSpecItem('- Sold:', '${widget.product.sold ?? 0} items'),
        ],
      ),
    );
  }

  Widget _buildSpecItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF2B2321),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 20), // Thêm khoảng cách giữa tiêu đề và giá trị
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF2B2321),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    // Tính toán giá sau khi giảm giá
    double originalPrice = widget.product.price! * quantity;
    int discountPercentage = widget.product.discount ?? 0;
    double discountAmount = originalPrice * (discountPercentage / 100);
    double finalPrice = originalPrice - discountAmount;

    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Hiển thị giá đã giảm
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${finalPrice.toStringAsFixed(0)}\$',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Hiển thị giá gốc và tỷ lệ giảm bên phải
          if (discountPercentage > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${originalPrice.toStringAsFixed(0)}\$',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '-$discountPercentage%',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          // Nút thêm vào giỏ hàng
          ElevatedButton.icon(
            onPressed: _addToCart,
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

  Widget _buildColorOptions() {
    // Lấy màu từ dữ liệu sản phẩm
    List<Color> productColors = [];

    // Thêm màu chính nếu có
    if (widget.product.color?.primary != null) {
      Color? primaryColor = _colorFromString(widget.product.color!.primary!);
      if (primaryColor != Colors.transparent) {
        productColors.add(primaryColor);
      }
    }

    // Thêm màu phụ nếu có và khác null và "None"
    if (widget.product.color?.secondary != null &&
        widget.product.color!.secondary!.toLowerCase() != "none") {
      Color? secondaryColor =
          _colorFromString(widget.product.color!.secondary!);
      if (secondaryColor != Colors.transparent) {
        productColors.add(secondaryColor);
      }
    }

    // Nếu không có màu nào được tìm thấy, trả về thông báo
    if (productColors.isEmpty) {
      return const Text(
        'Other colors have not been updated yet',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose colors:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.start, // Đổi từ spaceAround sang start
          children: productColors.map((color) {
            return Padding(
              padding: const EdgeInsets.only(
                  right: 16.0), // Thêm padding giữa các màu
              child: _buildColorOption(color),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: selectedColor == color
              ? Border.all(color: Colors.black, width: 2)
              : null,
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: 'Description'),
        Tab(text: 'Reviews'),
      ],
    );
  }

  Widget _buildTabBarView() {
    return SizedBox(
      height: 300,
      child: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.description ?? 'No description available',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                _buildColorOptions(), // Added color options here
                const SizedBox(height: 20),
                _buildProductSpecs(),
              ],
            ),
          ),
          widget.product.id != null 
              ? ProductReviews(productId: widget.product.id!)
              : Center(child: Text('Product ID not available')),
        ],
      ),
    );
  }
}

class InvertedParabolaClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height + 50, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
