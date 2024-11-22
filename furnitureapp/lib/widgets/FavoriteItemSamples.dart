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
  Wishlist? wishlist; // Sử dụng đúng mô hình Wishlist
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
        isLoading = false; // Dữ liệu đã được tải
      });
    } catch (e) {
      print("Error loading wishlist: $e");
      setState(() {
        isLoading = false; // Dừng tải dù có lỗi
      });
    }
  }

  Future<void> _removeFromWishlist(String productId) async {
    try {
      final result = await APIService.deleteWishlist(productId);
      if (result) {
        _loadWishlist(); // Tải lại danh sách yêu thích
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from wishlist')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove from wishlist')),
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
        id: product?.id,
        rating: (product?.rating ?? 0).toInt(),
        images: product?.images ?? [],
        comment: "This is a review for ${product?.name}",
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator()); // Hiển thị chỉ báo tải
    } else if (wishlist == null || wishlist!.product.isEmpty) {
      return const Center(child: Text("Your wishlist is empty")); // Xử lý danh sách yêu thích trống
    } else {
      List<Review> reviews = _getReviewsForProducts(wishlist!.product.map((item) => item.product).toList());
      return Column(
        children: wishlist!.product.asMap().entries.map((entry) {
          int index = entry.key;
          WishlistItem item = entry.value;
          Review review = reviews[index]; // Lấy đánh giá cho sản phẩm này
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
                  child: item.product!.images != null && item.product!.images!.isNotEmpty
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
                        Padding(
                          padding: const EdgeInsets.only(left: 10), // Đẩy tên sản phẩm sang phải
                          child: Text(
                            item.product?.name ?? 'Unknown product',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2B2321),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10), // Đẩy giá sang phải
                          child: Text(
                            "\$${item.product?.price?.toStringAsFixed(0) ?? 'N/A'}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2B2321),
                            ),
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
                            builder: (context) => ProductPage(
                              product: item.product!,
                              review: review, // Chuyển đánh giá đúng
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
