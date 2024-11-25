import 'package:flutter/material.dart';
import 'package:furnitureapp/model/product.dart';
import 'package:furnitureapp/api/api.service.dart';
import 'package:furnitureapp/widgets/ProductReviews.dart';
import 'package:furnitureapp/model/Review.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ProductPage extends StatefulWidget {
  final Product product;
  final Review review;
  
  const ProductPage({super.key, required this.product, required this.review});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  int currentModelIndex = 0;
  int quantity = 1;
  bool isFavorite = false;
  Color? selectedColor;

  List<Map<String, dynamic>> favoriteProducts = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
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
  leading: IconButton(
    icon: Icon(
      Icons.arrow_back,
      size: 30, // Kích thước biểu tượng
    ),
    onPressed: () {
      Navigator.of(context).pop(); // Điều hướng quay lại trang trước đó
    },
  ),
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
  // Kiểm tra nếu widget.product là null
  return Container(
    width: screenWidth,
    height: screenHeight * 0.4,
    decoration: const BoxDecoration(
      color: Color(0xFFD9D9D9),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.elliptical(250, 70),
        bottomRight: Radius.elliptical(250, 70),
      ),
    ),
    child: widget.product.model3d != null && widget.product.model3d!.isNotEmpty
       ? ModelViewer(
  backgroundColor: const Color(0xFFD9D9D9),
  src: 'assets/images_3d/AR-Code-1683008719374.glb', // Đảm bảo đường dẫn là chính xác
  alt: 'A 3D model of ${widget.product.name}',
  ar: true,
  autoRotate: true,
  cameraControls: true,
  loading: Loading.eager,
)
        : const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  'No 3D model available',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
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
              widget.product.name ?? 'No Name',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.product.brand ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B2321),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    ..._buildStarRating(widget.review.rating ?? 0),
                    const SizedBox(width: 4),
                    Text(
                      '(${widget.review.rating?.toStringAsFixed(1) ?? '0.0'})',
                      style: const TextStyle(fontSize: 16, color: Color(0xFF2B2321)),
                    ),
                  ],
                ),
              ],
            ),

            // Sold information and Quantity controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Sold:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${widget.product.sold ?? 0} items',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                _buildQuantityControls(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityControls() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: decreaseQuantity,
          padding: EdgeInsets.zero,
        ),
        SizedBox(
          width: 40,
          child: Center(
            child: Text(
              '$quantity',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: increaseQuantity,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  // Function to build star rating based on the rating value from Review model
  List<Widget> _buildStarRating(int rating) {
    List<Widget> stars = [];
    int starCount = rating.clamp(0, 5); // Ensure rating is between 0 and 5

    for (int i = 0; i < 5; i++) {
      stars.add(Icon(
        i < starCount ? Icons.star : Icons.star_border,
        color: Colors.black, // Color of the stars
        size: 20, // Size of the stars
      ));
    }

    return stars;
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
          _buildSpecItem(
            '- Dimensions:',
            widget.product.dimensions != null
                ? '${widget.product.dimensions!.width ?? 0} x ${widget.product.dimensions!.depth ?? 0} x ${widget.product.dimensions!.height ?? 0} (L x W x H)'
                : 'N/A',
          ),
          _buildSpecItem('- Material:', widget.product.material ?? 'N/A'),
          _buildSpecItem('- Weight:', '${widget.product.weight ?? 0} kg'),
          _buildSpecItem('- Quantity:', '${widget.product.stockQuantity ?? 0} items'),
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
    double originalPrice = widget.product.price! * quantity;
    int discountPercentage = widget.product.discount ?? 0;
    double finalPrice = originalPrice * (1 - discountPercentage / 100);

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '\$${finalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (discountPercentage > 0)
                Row(
                  children: [
                    Text(
                      '\$${originalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '-$discountPercentage%',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: _addToCart,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5, // Added elevation for a raised button effect
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
    List<Color> productColors = [];

    // Get colors from product data
    if (widget.product.color?.primary != null) {
      Color? primaryColor = _colorFromString(widget.product.color!.primary!);
      if (primaryColor != Colors.transparent) {
        productColors.add(primaryColor);
      }
    }

    if (widget.product.color?.secondary != null &&
        widget.product.color!.secondary!.toLowerCase() != "none") {
      Color? secondaryColor =
          _colorFromString(widget.product.color!.secondary!);
      if (secondaryColor != Colors.transparent) {
        productColors.add(secondaryColor);
      }
    }

    // If no colors found, return a message
    if (productColors.isEmpty) {
      return const Text(
        'Other colors have not been updated yet',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Choose colors:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              selectedColor != null
                  ? _getColorNameFromColor(selectedColor!)
                  : "Please choose product color",
              style: const TextStyle(fontSize: 16, color: Color(0xFF2B2321)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: productColors.map((color) {
            bool isSelected =
                selectedColor == color; // Check if this color is selected
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedColor = color; // Update selected color
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? Colors.blue
                        : Colors.transparent, // Change border color if selected
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.all(8.0), // Add padding for the color
                  child: _buildColorOption(
                      color), // Method to build the colored circle
                ),
              ),
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
      labelColor: Colors.black, // Color for selected tab
      unselectedLabelColor: Colors.grey, // Color for unselected tabs
      indicatorColor: Colors.blue, // Color for the tab indicator
      tabs: const [
        Tab(
          text: 'Description',
        ),
        Tab(
          text: 'Reviews',
        ),
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
                // Enhanced description styling
                Text(
                  widget.product.description ?? 'No description available',
                  style: const TextStyle(
                    fontSize: 18, // Increased font size for better readability
                    fontWeight: FontWeight.bold, // Make description bold
                    color: Color(0xFF2B2321), // Dark color for contrast
                  ),
                ),
                const SizedBox(height: 20),
                _buildProductSpecs(), // Product specifications
                const SizedBox(height: 20),
                _buildColorOptions(), // Color options
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
