import 'package:flutter/material.dart';

class UserManagementAppBar extends StatefulWidget {
  const UserManagementAppBar({super.key});

  @override
  _UserManagementAppBarState createState() => _UserManagementAppBarState();
}

class _UserManagementAppBarState extends State<UserManagementAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              // Quay về trang trước đó
              Navigator.pop(
                  context); // Đóng trang hiện tại và quay về trang trước đó
            },
            child: Icon(
              Icons.arrow_back,
              size: 30,
              color: Color(0xFF2B2321),
            ),
          ),
          // Sử dụng Expanded để căn giữa tiêu đề
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 27), // Thêm khoảng cách bên trái
              child: Center(
                child: Text(
                  "User Management",
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
