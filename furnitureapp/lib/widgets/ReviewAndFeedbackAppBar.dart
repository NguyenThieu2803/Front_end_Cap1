import 'package:flutter/material.dart';

class ReviewAndFeedbackAppBar extends StatelessWidget {
  const ReviewAndFeedbackAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 80,
        bottom: 20,
      ),
      color: Colors.white,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: GestureDetector(
              onTap: () {
                // Điều hướng về trang trước đó
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Color(0xFF2B2321),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: const Text(
                "Review And Feedback",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B2321),
                ),
              ),
            ),
          ),
          const SizedBox(width: 25),
        ],
      ),
    );
  }
}
