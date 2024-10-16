import 'package:flutter/material.dart';
import 'package:furnitureapp/pages/CartPage.dart';
import 'package:furnitureapp/pages/FavoritePage.dart';
import 'package:furnitureapp/pages/HomePage.dart'; // Chỉnh sửa từ Homepage sang HomePage
import 'package:furnitureapp/pages/UserProfilePage.dart';
import 'package:furnitureapp/widgets/HomeNavigationBar.dart';

class HomeMainNavigationBar extends StatefulWidget {
  const HomeMainNavigationBar({super.key});

  @override
  _HomeMainNavigationBarState createState() => _HomeMainNavigationBarState();
}

class _HomeMainNavigationBarState extends State<HomeMainNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(), // Trang chính
    const CartPage(), // Trang giỏ hàng
    const FavoritePage(), // Trang yêu thích
    const UserProfilePage(), // Trang hồ sơ người dùng
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật chỉ số trang hiện tại
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Hiển thị trang hiện tại
      bottomNavigationBar: HomeNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped, // Xử lý sự kiện nhấn
      ),
    );
  }
}
