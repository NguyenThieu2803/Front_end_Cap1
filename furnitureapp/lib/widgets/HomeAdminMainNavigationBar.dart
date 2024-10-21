import 'package:flutter/material.dart';
import 'package:furnitureapp/admin/AdminPage.dart';
import 'package:furnitureapp/pages/CartPage.dart';
import 'package:furnitureapp/pages/FavoritePage.dart';
import 'package:furnitureapp/pages/HomePage.dart'; // Chỉnh sửa từ Homepage sang HomePage
import 'package:furnitureapp/pages/UserProfilePage.dart';
import 'package:furnitureapp/widgets/HomeAdminNavigationBar.dart';

class HomeAdminMainNavigationBar extends StatefulWidget {
  const HomeAdminMainNavigationBar({super.key});

  @override
  _HomeAdminMainNavigationBarState createState() => _HomeAdminMainNavigationBarState();
}

class _HomeAdminMainNavigationBarState extends State<HomeAdminMainNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(), // Trang chính
    const CartPage(), // Trang giỏ hàng
    const AdminPage(), // Trang admin
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
      bottomNavigationBar: HomeAdminNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped, // Xử lý sự kiện nhấn
      ),
    );
  }
}
