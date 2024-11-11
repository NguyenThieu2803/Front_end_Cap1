import 'package:furnitureapp/model/Review.dart';

import '../model/product.dart';
import 'package:flutter/material.dart';
import '../services/data_service.dart';
import 'package:furnitureapp/pages/ProductPage.dart';

class HomeItemsWidget extends StatefulWidget {
  final String selectedCategory;
  final double? minPrice;
  final double? maxPrice;

  const HomeItemsWidget({
    super.key,
    required this.selectedCategory,
    this.minPrice,
    this.maxPrice,
  });

  @override
  _HomeItemsWidgetState createState() => _HomeItemsWidgetState();
}

class _HomeItemsWidgetState extends State<HomeItemsWidget> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void didUpdateWidget(HomeItemsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory ||
        oldWidget.minPrice != widget.minPrice ||
        oldWidget.maxPrice != widget.maxPrice) {
      _loadProducts();
    }
  }

  void _loadProducts() {
    final dataService = DataService();
    _productsFuture = dataService.loadProducts(
      category: widget.selectedCategory,
      minPrice: widget.minPrice,
      maxPrice: widget.maxPrice,
    );
  }
// hàm này để gọi review vào detail 
  List<Review> getReviewsForProducts(List<Product> products) {
    // This is just an example. You would replace this with actual logic to fetch reviews.
    return products.map((product) {
      // Create a dummy review for each product
      return Review(
        id: product.id,
        rating:
            (product.rating ?? 0).toInt(), // Assuming rating is part of Product
        comment: "This is a review for ${product.name}",
        reviewDate: DateTime.now().toString(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hiển thị tiêu đề dựa trên category được chọn
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 10,
              right: 10), // Điều chỉnh margin trên xuống 10
          child: Text(
            widget.selectedCategory == "All Product"
                ? "All Products"
                : "Products in ${widget.selectedCategory}",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B2321),
            ),
          ),
        ),
        FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'No products found in this category',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            } else {
              final products = snapshot.data!;
              // Assuming you have a way to get reviews for each product
              List<Review> reviews = getReviewsForProducts(
                  products); // Define this method accordingly
              return GridView.count(
                childAspectRatio: 0.85,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10),
                children: List.generate(products.length, (index) {
                  return ProductTile(
                    product: products[index],
                    review: reviews[index], // Pass corresponding review
                  );
                }),
              );
            }
          },
        ),
      ],
    );
  }
}

class ProductTile extends StatelessWidget {
  final Product product;
  final Review review;

  const ProductTile({super.key, required this.product, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((product.discount ?? 0) > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF2B2321),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "-${product.discount}%",
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color.fromARGB(255, 168, 149, 149),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductPage(product: product, review: review),
                      ),
                    );
                  },
                  child: Center(
                    child: Image.network(
                      product.images?.isNotEmpty == true
                          ? product.images!.first
                          : 'https://example.com/default_image.png',
                      fit: BoxFit.contain,
                      height: 100,
                    ),
                  ),
                ),
              ),
              Text(
                product.name ?? 'Unknown Product',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2B2321),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\$${calculateDiscountedPrice(product.price ?? 0, product.discount ?? 0).toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B2321),
                        ),
                      ),
                      if (product.discount != null && product.discount! > 0)
                        Text(
                          "\$${product.price?.toStringAsFixed(0)}",
                          style: TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      SizedBox(width: 2),
                      Text(
                        "${product.rating?.toStringAsFixed(1) ?? '0.0'}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                "${product.sold ?? 0} sold",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              Icons.favorite_border,
              color: Colors.red,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // Thêm hàm tính giá sau khi giảm
  double calculateDiscountedPrice(double originalPrice, int discount) {
    return originalPrice * (1 - discount / 100);
  }
}
