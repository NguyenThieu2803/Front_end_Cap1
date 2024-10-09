import 'package:flutter/material.dart';

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  _CategoriesWidgetState createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  // Danh sách tên sản phẩm cố định
  List<String> categoryNames = ["Table", "Chair", "Sofa", "Bed", "Desk", "Cabinet"];
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < categoryNames.length; i++) // Sử dụng tên từ danh sách categoryNames
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/${i + 1}.png", // Hình ảnh tương ứng với sản phẩm
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(width: 10), // Khoảng cách giữa hình ảnh và tên
                  // Hiển thị tên sản phẩm cố định
                  Text(
                    categoryNames[i], // Hiển thị tên sản phẩm từ danh sách
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF2B2321),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
