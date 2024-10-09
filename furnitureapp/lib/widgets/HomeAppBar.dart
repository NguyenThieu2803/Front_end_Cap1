import 'package:flutter/material.dart';
import 'package:furnitureapp/pages/NotificationPage.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  _HomeAppBarState createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0, // Bỏ viền bóng
      leading: IconButton(
        icon: Icon(
          Icons.sort,
          size: 30,
          color: Color(0xFF2B2321),
        ),
        onPressed: () {
          // Thêm chức năng khi bấm vào menu nếu cần
        },
      ),
      title: Text(
        "FurniFit AR",
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2B2321),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications,
            size: 30,
            color: Color(0xFF2B2321),
          ),
          onPressed: () {
            // Thêm hành động khi bấm vào nút thông báo nếu cần
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}
