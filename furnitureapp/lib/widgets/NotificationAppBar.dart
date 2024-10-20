import 'package:flutter/material.dart';
import 'package:furnitureapp/admin/HomePageAdmin.dart';
import 'package:furnitureapp/pages/Homepage.dart';

class NotificationAppBar extends StatelessWidget {
  final bool isAdminPage; // Tham số cần thiết

  const NotificationAppBar({super.key, required this.isAdminPage}); // Nhận biến này từ widget cha

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
                // Điều hướng về trang tương ứng
                if (isAdminPage) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePageAdmin()),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                }
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
              child: Text(
                "Notification",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B2321),
                ),
              ),
            ),
          ),
          const SizedBox(width: 46),
        ],
      ),
    );
  }
}
