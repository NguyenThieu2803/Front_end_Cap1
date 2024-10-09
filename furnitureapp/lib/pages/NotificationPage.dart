import 'package:flutter/material.dart';
import 'package:furnitureapp/widgets/NotificationAppBar.dart';
import 'package:furnitureapp/widgets/NotificationItemSamples.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});
  
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            NotificationAppBar(), // AppBar sẽ luôn ở trên cùng
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFEDECF2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: ListView(
                    padding: EdgeInsets.only(top: 15),
                    children: [
                      NotificationItemSamples(),
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