import 'package:flutter/material.dart';
import 'package:furnitureapp/widgets/FavoriteItemSamples.dart';
import 'package:furnitureapp/widgets/UserManagementAppBar.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            UserManagementAppBar(), // Đảm bảo FavoriteAppBar không null
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
