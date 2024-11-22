import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:furnitureapp/model/ReviewModel.dart';
import 'package:flutter/services.dart' show rootBundle;


class EvaluateFeedBack extends StatefulWidget {
  const EvaluateFeedBack({super.key});

  @override
  State<EvaluateFeedBack> createState() => _EvaluateFeedBackState();
}

class _EvaluateFeedBackState extends State<EvaluateFeedBack> {
  final List<TextEditingController> _reviewControllers = [];
  bool isFormComplete = false;
  final List<int> _ratings = [0, 0];
  List<ReviewData> reviews = [];

  @override
  void initState() {
    super.initState();
    _reviewControllers.add(TextEditingController());
    _reviewControllers.add(TextEditingController());
    
    for (var controller in _reviewControllers) {
      controller.addListener(_checkFormCompletion);
    }
    _loadReviewData();
  }

  Future<void> _loadReviewData() async {
    try {
      // Đọc file JSON từ assets
      final String response = await rootBundle.loadString('assets/detail/WriteAReview.json');
      final data = await json.decode(response);
      
      setState(() {
        reviews = (data['reviews'] as List)
            .map((reviewJson) => ReviewData.fromJson(reviewJson))
            .toList();
      });
    } catch (e) {
      print('Error loading review data: $e');
    }
  }

  @override
  void dispose() {
    for (var controller in _reviewControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _checkFormCompletion() {
    setState(() {
      bool hasReview = _reviewControllers.any(
        (controller) => controller.text.trim().isNotEmpty
      );
      isFormComplete = hasReview && _ratings.any((rating) => rating > 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDECF2),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(82.0),
        child: AppBar(
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Container(
            margin: const EdgeInsets.only(top: 25.0),
            child: const Text(
              'Write A Review',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 25.0, right: 30.0),
              child: TextButton(
                onPressed: isFormComplete ? () {} : null,
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Up',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: isFormComplete ? Colors.red : Colors.red[200],
                  ),
                ),
              ),
            ),
          ],
          centerTitle: true,
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: reviews.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      const SizedBox(height: 10),
                      ...List.generate(
                        reviews.length,
                        (index) => _buildFeedbackCard(index),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard(int index) {
    final review = reviews[index];
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFE0E0E0),
                  child: review.user.avatar != null
                      ? Image.network(review.user.avatar!)
                      : const Icon(Icons.person, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.user.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      review.user.reviewDate,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: List.generate(
                    5,
                    (starIndex) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _ratings[index] = starIndex + 1;
                          _checkFormCompletion();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Icon(
                          Icons.star,
                          color: starIndex < _ratings[index] ? Colors.amber : Colors.grey[300],
                          size: 23,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Product: ${review.product.name}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Material: ${review.product.specs.material}\n'
              'Color: ${review.product.specs.colors.join(", ")}\n'
              'Origin: ${review.product.specs.origin}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reviewControllers[index],
              decoration: InputDecoration(
                hintText: 'Write your review and feedback here...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 10.0,
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildImagePlaceholder(),
                const SizedBox(width: 8),
                _buildImagePlaceholder(),
                const SizedBox(width: 8),
                Stack(
                  children: [
                    _buildImagePlaceholder(),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Upload photo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.image,
        color: Colors.grey,
        size: 30,
      ),
    );
  }
}