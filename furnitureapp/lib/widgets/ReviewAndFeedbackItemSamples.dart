import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Để sử dụng rootBundle

class ReviewAndFeedbackItemSamples extends StatelessWidget {
  const ReviewAndFeedbackItemSamples({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Review>>(
      future: loadReviews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No evaluation data available.'));
        }

        final reviews = snapshot.data!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: reviews.map((review) {
              return _buildReviewItem(
                customerName: review.customerName,
                date: review.date,
                productName: review.productName,
                productDetails: review.productDetails,
                reviewContent: review.reviewContent,
                rating: review.rating,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<List<Review>> loadReviews() async {
    final jsonString = await rootBundle.loadString('assets/ReviewAndFeedback.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((e) => Review.fromJson(e)).toList();
  }

  Widget _buildReviewItem({
    required String customerName,
    required String date,
    required String productName,
    required String productDetails,
    required String reviewContent,
    required int rating,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/avatar_placeholder.png'),
              ),
              const SizedBox(width: 8.0),
              Text(
                customerName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Row(
                children: List.generate(
                  rating,
                  (index) => const Icon(Icons.star, color: Color.fromARGB(204, 255, 235, 59), size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            date,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Product: $productName',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4.0),
          Text(
            productDetails,
            style: TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 8.0),
          Text(
            reviewContent,
            style: const TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 8.0),
          // Thêm các IconButton như trước đó
        ],
      ),
    );
  }
}

class Review {
  final String customerName;
  final String date;
  final String productName;
  final String productDetails;
  final String reviewContent;
  final int rating;

  Review({
    required this.customerName,
    required this.date,
    required this.productName,
    required this.productDetails,
    required this.reviewContent,
    required this.rating,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      customerName: json['customerName'],
      date: json['date'],
      productName: json['productName'],
      productDetails: json['productDetails'],
      reviewContent: json['reviewContent'],
      rating: json['rating'],
    );
  }
}
