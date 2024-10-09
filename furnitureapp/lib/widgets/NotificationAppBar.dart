import 'package:flutter/material.dart';
import 'package:furnitureapp/pages/HomePage.dart'; // Đảm bảo bạn import đúng file HomePage

class NotificationAppBar extends StatefulWidget {
  const NotificationAppBar({super.key});

  @override
  _NotificationAppBarState createState() => _NotificationAppBarState();
}

class _NotificationAppBarState extends State<NotificationAppBar> {
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
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 30),
              child: Center(
                child: Text(
                  "Notification",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B2321),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}