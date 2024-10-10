import 'package:flutter/material.dart';
import 'package:furnitureapp/pages/HomePage.dart'; // Đảm bảo bạn import đúng file HomePage

class UserProfileAppBar extends StatefulWidget {
  const UserProfileAppBar({super.key});

  @override
  _UserProfileAppBarState createState() => _UserProfileAppBarState();
}

class _UserProfileAppBarState extends State<UserProfileAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              // Chuyển về trang chủ
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child: Icon(
              Icons.arrow_back,
              size: 30,
              color: Color(0xFF2B2321),
            ),
          ),
          Spacer(), // Để đẩy chữ "Favorite Products" vào giữa
          Text(
            "Favorite Products",
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B2321),
            ),
          ),
          Spacer(), // Tạo khoảng cách giữa tiêu đề và icon trái tim
          Icon(
            Icons.settings,
            size: 30,
            color: Colors.black, // Đặt màu cho biểu tượng trái tim
          ),
        ],
      ),
    );
  }
}
