import 'package:flutter/material.dart';
import 'package:furnitureapp/model/Review.dart';
import 'package:furnitureapp/model/product.dart';
import 'package:furnitureapp/api/api.service.dart';
import 'package:furnitureapp/services/ar_service.dart';
import 'package:furnitureapp/services/ar_service.dart';
import 'package:furnitureapp/services/data_service.dart';
import 'package:furnitureapp/widgets/ProductReviews.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:furnitureapp/widgets/ARViewerWidget.dart';

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
  double? averageRating;
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this); // Two tabs for Details and Reviews
    _loadAverageRating();
  }

  Future<void> _loadAverageRating() async {
    if (widget.product.id != null) {
      final rating = await _dataService.getProductAverageRating(widget.product.id!);
      if (mounted) {
        setState(() {
          averageRating = rating;
        });
      }
    }
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
    child: Stack(
      children: [
        widget.product.model3d != null && widget.product.model3d!.isNotEmpty
            ? ModelViewer(
                backgroundColor: const Color(0xFFD9D9D9),
                src: widget.product.model3d!,
                alt: 'A 3D model of ${widget.product.name}',
                ar: true,
                autoRotate: true,
                cameraControls: true,
                loading: Loading.eager,
              )
            : const Center(
                child: Text('No 3D model available'),
              ),
        
        if (widget.product.model3d != null && widget.product.model3d!.isNotEmpty)
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              heroTag: 'arButton',
              backgroundColor: Colors.white,
              onPressed: () async {
                if (await ArService.checkARCapabilities()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ARViewerWidget(
                        modelUrl: widget.product.model3d!,
                        modelFormat: widget.product.modelFormat,
                        modelConfig: widget.product.modelConfig,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('AR is not supported on this device'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Icon(
                Icons.view_in_ar,
                color: Colors.black,
              ),
            ),
          ),
      ],
    ),
  );
}




  Widget _buildProductDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tên sản phẩm trên một hàng
          Text(
            widget.product.name ?? 'No Name',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B2321),
            ),
          ),
          const SizedBox(height: 8), // Giảm khoảng cách

          // Đánh giá và số lượng đã bán trên cùng một hàng
          Row(
            children: [
              Row(
                children: [
                  ..._buildStarRating(averageRating ?? 0.0),
                  const SizedBox(width: 4),
                  Text(
                    '(${averageRating?.toStringAsFixed(1) ?? '0.0'})',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2B2321),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              Text(
                '${widget.product.sold ?? 0} Sold',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Giảm khoảng cách

          // Color Options
          _buildColorOptions(),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black, size: 12),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: 20,
          minHeight: 20,
        ),
      ),
    );
  }

  // Function to build star rating based on the rating value from Review model
  List<Widget> _buildStarRating(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    // Add full stars
    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(
        Icons.star,
        color: Colors.amber,
        size: 20,
      ));
    }

    // Add half star if needed
    if (hasHalfStar) {
      stars.add(const Icon(
        Icons.star_half,
        color: Colors.amber,
        size: 20,
      ));
    }

    // Add empty stars
    int emptyStars = 5 - stars.length;
    for (int i = 0; i < emptyStars; i++) {
      stars.add(const Icon(
        Icons.star_border,
        color: Colors.amber,
        size: 20,
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
          _buildSpecItem('- Brand:', widget.product.brand ?? 'N/A'),
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

    if (widget.product.color?.primary != null) {
      Color? primaryColor = _colorFromString(widget.product.color!.primary!);
      if (primaryColor != Colors.transparent) {
        productColors.add(primaryColor);
      }
    }

    if (widget.product.color?.secondary != null &&
        widget.product.color!.secondary!.toLowerCase() != "none") {
      Color? secondaryColor = _colorFromString(widget.product.color!.secondary!);
      if (secondaryColor != Colors.transparent) {
        productColors.add(secondaryColor);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Choose colors: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                selectedColor != null
                    ? _getColorNameFromColor(selectedColor!)
                    : "Please choose product color",
                style: const TextStyle(fontSize: 16, color: Color(0xFF2B2321)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Color options
            Row(
              children: productColors.map((color) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _buildColorOption(color),
                );
              }).toList(),
            ),
            
            // Quantity control
            Row(
              children: [
                // Minus button
                GestureDetector(
                  onTap: decreaseQuantity,
                  child: Text(
                    '−',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  width: 30,
                  alignment: Alignment.center,
                  child: Text(
                    '$quantity',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // Plus button
                GestureDetector(
                  onTap: increaseQuantity,
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ],
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
                // Description
                Text(
                  widget.product.description ?? 'No description available',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2B2321),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Product specifications
                _buildProductSpecs(),
              ],
            ),
          ),
          widget.product.id != null 
              ? ProductReviews(productId: widget.product.id!)
              : const Center(child: Text('Product ID not available')),
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
