import 'package:flutter/material.dart';
import 'package:furnitureapp/widgets/ReviewAndFeedbackAppBar.dart';
import 'package:furnitureapp/widgets/ReviewAndFeedbackItemSamples.dart';


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
      body: Column(
        children: [
          // AppBar sẽ luôn ở trên cùng và cố định.
          ReviewAndFeedbackAppBar(),

          // Expanded để nội dung thông báo chiếm hết phần còn lại của màn hình.
          Expanded(
            child: Container(
              color: const Color(0xFFEDECF2), // Màu nền phía sau
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                // Sử dụng ListView để hiển thị danh sách các thông báo.
                child: ListView(
                  padding: const EdgeInsets.only(top: 10),
                  children: const [
                    // Import và hiển thị các mẫu thông báo.
                    ReviewAndFeedbackItemSamples(),
                    // Khoảng trống ở cuối danh sách để tạo khoảng cách.
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
