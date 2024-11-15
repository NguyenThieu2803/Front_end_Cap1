import '../model/product.dart';
import 'package:flutter/material.dart';
import 'package:furnitureapp/model/Review.dart';
import 'package:furnitureapp/api/api.service.dart';
import 'package:furnitureapp/pages/ProductPage.dart';
import 'package:furnitureapp/model/wishlist_model.dart';
import 'package:furnitureapp/services/data_service.dart';

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
  Future<Set<String>>? _wishlistProductIdsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _wishlistProductIdsFuture = _loadWishlistProductIds();
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

  Future<Set<String>> _loadWishlistProductIds() async {
    try {
      Wishlist? wishlist = await DataService().getWishlistByUserId();
      if (wishlist != null && wishlist.product != null) {
        return wishlist.product.map((item) => item.product?.id ?? '').toSet();
      }
    } catch (e) {
      print("Error loading wishlist IDs: $e");
    }
    return {}; // Return an empty set if there's an error or no wishlist.
  }

  List<Review> getReviewsForProducts(List<Product> products) {
    return products.map((product) {
      return Review(
        id: product.id,
        rating: (product.rating ?? 0).toInt(),
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
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Text(
            widget.selectedCategory == "All Product"
                ? "All Products"
                : "Products in ${widget.selectedCategory}",
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B2321),
            ),
          ),
        ),
        FutureBuilder<Set<String>>(
          future: _wishlistProductIdsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading wishlist: ${snapshot.error}'));
            }

            final wishlistProductIds = snapshot.data ?? {};

            return FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, productSnapshot) {
                if (productSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (productSnapshot.hasError) {
                  return Center(child: Text('Error: ${productSnapshot.error}'));
                } else if (!productSnapshot.hasData || productSnapshot.data!.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('No products found in this category', style: TextStyle(fontSize: 16)),
                    ),
                  );
                } else {
                  final products = productSnapshot.data!;
                  List<Review> reviews = getReviewsForProducts(products);

                  return GridView.count(
                    childAspectRatio: 0.85,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 8),
                    children: List.generate(products.length, (index) {
                      return ProductTile(
                        product: products[index],
                        review: reviews[index],
                        isFavorite: wishlistProductIds.contains(products[index].id),
                      );
                    }),
                  );
                }
              },
            );
          },
        ),
      ],
    );
  }
}

class ProductTile extends StatefulWidget {
  final Product product;
  final Review review;
  final bool isFavorite;

  const ProductTile({super.key, required this.product, required this.review, required this.isFavorite});

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });

    try {
      bool success;
      if (isFavorite) {
        success = await APIService.addWishlist(widget.product.id!);
      } else {
        success = await APIService.deleteWishlist(widget.product.id!);
      }

      if (!success) {
        setState(() {
          isFavorite = !isFavorite; // Revert the state if API call fails
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isFavorite ? 'Failed to add to wishlist' : 'Failed to remove from wishlist')),
        );
      }
    } catch (e) {
      setState(() {
        isFavorite = !isFavorite; // Revert the state if there's an error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
      print("Error toggling favorite: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
              if ((widget.product.discount ?? 0) > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "-${widget.product.discount}%",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
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
                        builder: (context) => ProductPage(
                          product: widget.product,
                          review: widget.review
                        ),
                      ),
                    );
                  },
                  child: Center(
                    child: Image.network(
                      widget.product.images?.isNotEmpty == true
                          ? widget.product.images!.first
                          : 'https://example.com/default_image.png',
                      fit: BoxFit.contain,
                      height: 100,
                    ),
                  ),
                ),
              ),
              Text(
                widget.product.name ?? 'Unknown Product',
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
                        "\$${calculateDiscountedPrice(widget.product.price ?? 0, widget.product.discount ?? 0).toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B2321),
                        ),
                      ),
                      if (widget.product.discount != null && widget.product.discount! > 0)
                        Text(
                          "\$${widget.product.price?.toStringAsFixed(0)}",
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
                        "${widget.product.rating?.toStringAsFixed(1) ?? '0.0'}",
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
                "${widget.product.sold ?? 0} sold",
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
            child: InkWell(
              onTap: _toggleFavorite,
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
                size: 20,
              ),
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
