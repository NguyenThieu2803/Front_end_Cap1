import 'package:flutter/material.dart';
import 'package:furnitureapp/model/Review.dart';
import 'package:furnitureapp/services/data_service.dart';
import 'package:furnitureapp/widgets/ProductReviewsItemSamples.dart';

class ProductReviews extends StatelessWidget {
  final String productId;
  final DataService _dataService = DataService();

  ProductReviews({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Review>>(
      future: _dataService.loadReviews(productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final reviews = snapshot.data ?? [];
        final displayedReviews = reviews.take(2).toList();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Đánh giá của khách hàng (${reviews.length})',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (reviews.length > 2)
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductReviewsItemSamples(
                              productId: productId,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Xem thêm',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (reviews.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Chưa có đánh giá nào'),
              )
            else
              ...displayedReviews.map((review) => _buildReviewItem(review)).toList(),
          ],
        );
      },
    );
  }

  Widget _buildReviewItem(Review review) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                child: Text(review.userName?[0] ?? 'U'),
                backgroundColor: Colors.grey[300],
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName ?? 'Unknown User',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < (review.rating ?? 0) 
                              ? Icons.star 
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(review.comment ?? ''),
          if (review.images != null && review.images!.isNotEmpty) ...[
            SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: review.images!
                    .map((image) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Image.network(
                            image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
          Divider(height: 32),
        ],
      ),
    );
  }
}
