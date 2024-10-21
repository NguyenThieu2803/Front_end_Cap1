import 'package:flutter/material.dart';
import 'package:furnitureapp/widgets/FavoriteItemSamples.dart';
import 'package:furnitureapp/widgets/ReviewAndFeedbackAppBar.dart';


class ReviewAndFeedback extends StatefulWidget {
  const ReviewAndFeedback({super.key});

  @override
  _ReviewAndFeedbackState createState() => _ReviewAndFeedbackState();
}

class _ReviewAndFeedbackState extends State<ReviewAndFeedback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            ReviewAndFeedbackAppBar(), // Đảm bảo FavoriteAppBar không null
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFEDECF2),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: ListView(
                    padding: EdgeInsets.only(top: 10),
                    children: [
                      FavoriteItemSamples(),
                      // Thêm SizedBox để tạo khoảng trống ở cuối danh sách
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
