import 'package:flutter/material.dart';
import 'package:furnitureapp/admin/HomePageAdmin.dart';
import 'package:furnitureapp/pages/HomePage.dart';

class AdminAppBar extends StatelessWidget {
  const AdminAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              // Kiểm tra xem widget có còn tồn tại không trước khi điều hướng
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePageAdmin()),
                );
              }
            },
            child: const Icon(
              Icons.arrow_back,
              size: 30,
              color: Color(0xFF2B2321),
            ),
          ),
          const Spacer(),
          const Text(
            "User Management",
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B2321),
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              // Gọi hàm mở cài đặt từ setting.dart
              // openSettings(context);
            },
            child: const Icon(
              Icons.settings,
              size: 30,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
