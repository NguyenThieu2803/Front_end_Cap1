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
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                    padding: const EdgeInsets.only(top: 10),
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

  Future<void> _toggleFavorite(Product product) async {
    setState(() {
      isFavorite = !isFavorite;
    });

    try {
      if (isFavorite) {
        bool success = await APIService.addWishlist(product.id!);
        if (!success) {
          setState(() {
            isFavorite = !isFavorite;
          });
          _showErrorSnackBar('Failed to add to wishlist');
        }
      } else {
        bool success = await APIService.deleteWishlist(product.id!);
        if (!success) {
          setState(() {
            isFavorite = !isFavorite;
          });
          _showErrorSnackBar('Failed to remove from wishlist');
        }
      }
    } catch (e) {
      setState(() {
        isFavorite = !isFavorite;
      });
      _showErrorSnackBar('An error occurred');
      print("Error toggling favorite: $e");
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFF2B2321),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${widget.product.discount ?? 0}%",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 168, 149, 149),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _toggleFavorite(widget.product),
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPage(product: widget.product, review: widget.review),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(5),
              child: Image.network(
                widget.product.images?.isNotEmpty == true
                    ? widget.product.images!.first
                    : 'https://example.com/default_image.png',
                height: 110,
                width: 110,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 5),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.product.name ?? 'Unknown Product',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF2B2321),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${widget.product.price?.toStringAsFixed(0) ?? 'N/A'}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B2321),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          widget.product.rating?.toStringAsFixed(1) ?? '0.0',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  "${widget.product.sold ?? 0} sold",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
