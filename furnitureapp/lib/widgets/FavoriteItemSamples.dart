import 'package:flutter/material.dart';
import 'package:furnitureapp/model/Review.dart';
import 'package:furnitureapp/model/product.dart';
import 'package:furnitureapp/api/api.service.dart';
import 'package:furnitureapp/pages/ProductPage.dart';
import 'package:furnitureapp/model/wishlist_model.dart';
import 'package:furnitureapp/services/data_service.dart';

class FavoriteItemSamples extends StatefulWidget {
  const FavoriteItemSamples({super.key});

  @override
  _FavoriteItemSamplesState createState() => _FavoriteItemSamplesState();
}

class _FavoriteItemSamplesState extends State<FavoriteItemSamples> {
  Wishlist? wishlist; // Use the correct Wishlist model
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    try {
      Wishlist? loadedWishlist = await DataService().getWishlistByUserId();
      setState(() {
        wishlist = loadedWishlist;
        isLoading = false; // Data has been loaded
      });
    } catch (e) {
      print("Error loading wishlist: $e");
      setState(() {
        isLoading = false; // Stop loading even if there was an error
      });
      // Handle error (e.g., show a message to the user)
    }
  }

  Future<void> _removeFromWishlist(String productId) async {
    try {
      final result = await APIService.deleteWishlist(productId);
      if (result) {
        // Successfully removed, refresh the wishlist
        _loadWishlist(); // Or you could manually remove the item from the list
        ScaffoldMessenger.of(context).showSnackBar(
          
          const SnackBar(content: Text('Removed from wishlist')),
        );
      } else {
        // Handle errors like product not found, etc.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Failed to remove from wishlist")), // Assuming result has a message field
        );
      }
    } catch (e) {
      print("Error removing from wishlist: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error removing from wishlist')),
      );
    }
  }

  List<Review> _getReviewsForProducts(List<Product?> products) {
    return products.map((product) {
      return Review(
        id: product?.id, // Use the actual review ID if available.
        rating: (product?.rating ?? 0).toInt(),
        images: product?.images ?? [],
        comment: "This is a review for ${product?.name}",  // Or fetch real comment
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator()); // Show loading indicator
    } else if (wishlist == null || wishlist!.product.isEmpty) {
      return const Center(
          child: Text("Your wishlist is empty")); // Handle empty wishlist
    } else {
      List<Review> reviews = _getReviewsForProducts(wishlist!.product.map((item) => item.product).toList());
      return Column(
        children: wishlist!.product.asMap().entries.map((entry) {
          int index = entry.key;
          WishlistItem item = entry.value;
            Review review = reviews[index]; // Get the review for this product
          return Container(
            height: 110,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 70,
                  width: 70,
                  child: item.product!.images != null &&
                          item.product!.images!.isNotEmpty
                      ? Image.network(item.product!.images![0])
                      : const Placeholder(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.product?.name ?? 'Unknown product',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2B2321),
                          ),
                        ),
                        Text(
                          "\$${item.product?.price?.toStringAsFixed(0) ?? 'N/A'}",
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
                      onTap: () {
                        _removeFromWishlist(item.product?.id ?? "");
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 25),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  ProductPage(
                              product: item.product!,
                              review: review, // Pass the correct Review object
                            ),
                          ),
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
          );
        }).toList(),
      );
    }
  }
}
