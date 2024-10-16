import 'package:flutter/material.dart';
import 'package:furnitureapp/pages/HomePage.dart';

class UserProfileAppBar extends StatelessWidget {
  const UserProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          InkWell(
            onTap: () {
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
          Spacer(),
          Text(
            "Favorite Products",
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B2321),
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () {
              // Gọi hàm mở cài đặt từ setting.dart
              // openSettings(context);
            },
            child: Icon(
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