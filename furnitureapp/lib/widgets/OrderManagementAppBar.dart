import 'package:flutter/material.dart';

class OrderManagementAppBar extends StatefulWidget {
  const OrderManagementAppBar({super.key});

  @override
  _OrderManagementAppBarState createState() => _OrderManagementAppBarState();
}

class _OrderManagementAppBarState extends State<OrderManagementAppBar> {
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
              padding: const EdgeInsets.only(right: 27), // Thêm khoảng cách bên trái
              child: Center(
                child: Text(
                  "OrderManagement",
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
