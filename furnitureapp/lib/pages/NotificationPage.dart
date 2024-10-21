import 'package:flutter/material.dart';
import 'package:furnitureapp/widgets/NotificationAppBar.dart';
import 'package:furnitureapp/widgets/NotificationItemSamples.dart'; // Đảm bảo import đúng

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    // Xác định xem đây có phải là trang Admin hay không
    bool isAdminPage = true; // Thay đổi giá trị này nếu trang này là của Admin

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // AppBar sẽ luôn ở trên cùng và cố định.
          NotificationAppBar(isAdminPage: isAdminPage), // Truyền tham số isAdminPage

          // Expanded để nội dung thông báo chiếm hết phần còn lại của màn hình.
          Expanded(
            child: Container(
              color: const Color(0xFFEDECF2), // Màu nền phía sau
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                // Sử dụng ListView để hiển thị danh sách các thông báo.
                child: ListView(
                  padding: const EdgeInsets.only(top: 10),
                  children: const [
                    // Import và hiển thị các mẫu thông báo.
                    NotificationItemSamples(),
                    // Khoảng trống ở cuối danh sách để tạo khoảng cách.
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
