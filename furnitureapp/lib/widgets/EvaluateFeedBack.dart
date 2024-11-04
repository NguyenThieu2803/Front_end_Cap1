import 'package:flutter/material.dart';

class EvaluateFeedBack extends StatelessWidget {
  const EvaluateFeedBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Feedback',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Up',
              style: TextStyle(color: Colors.pink[300]),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildFeedbackCard(),
          _buildFeedbackCard(),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info row
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nguyễn Văn Thiều',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '20/09/2024',
                      style: TextStyle(
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
                    (index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Product info
            const Text(
              'Product: Ghế Công Thái Học',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Vật liệu: Lưng da pu + nệm, chân thép mạ crom, ngã lưngduỗi chân\nMàu sắc: Đen, xám, trắng\nXuất xứ: Nhập khẩu',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Review and feedback content...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            // Image grid
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