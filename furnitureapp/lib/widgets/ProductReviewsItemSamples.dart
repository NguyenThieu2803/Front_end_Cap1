import 'dart:convert'; // Thêm import này
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:furnitureapp/model/Review.dart';

class ProductReviewsItemSamples extends StatelessWidget {
  const ProductReviewsItemSamples({Key? key}) : super(key: key);

  // Hàm tải dữ liệu từ file JSON
  static Future<List<Review>> loadReviews() async {
    final String response =
        await rootBundle.loadString('assets/detail/Review.json');
    final data = json.decode(response) as List;
    return data.map((reviewJson) => Review.fromJson(reviewJson)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          iconSize: 30,
          color: const Color(0xFF2B2321),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'All Reviews',
          style: TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.bold // Màu chữ, có thể thay đổi nếu cần
          ),
        ),
        backgroundColor: Colors.white, // Đặt màu nền là trắng
      ),
      body: Container(
        color: const Color(0xFFEDECF2), // Đặt màu nền cho body
        child: FutureBuilder<List<Review>>(
          future: loadReviews(), // Gọi hàm tải dữ liệu
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Không có đánh giá nào.'));
            }

            final reviews = snapshot.data!;
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return _buildReviewItem(reviews[index]);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildReviewItem(Review review) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(review.avatarUrl),
                radius: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < review.rating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                    ),
                    Text(
                      'Màu sắc: ${review.color}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(review.comment),
          if (review.images.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review.images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        review.images[index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          const Divider(thickness: 1),
        ],
      ),
    );
  }
}
