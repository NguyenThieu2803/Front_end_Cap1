import 'package:flutter/material.dart';
import 'package:furnitureapp/pages/CartPage.dart';
import 'package:furnitureapp/pages/FavoritePage.dart';
import 'package:furnitureapp/pages/Homepage.dart';
import 'package:furnitureapp/pages/UserProfilePage.dart';
import 'package:furnitureapp/widgets/HomeNavigationBar.dart';

class HomeMainNavigationBar extends StatefulWidget {
  const HomeMainNavigationBar({Key? key, required void Function(String language) onLanguageChanged}) : super(key: key);

  @override
  _HomeMainNavigationBarState createState() => _HomeMainNavigationBarState();
}

class _HomeMainNavigationBarState extends State<HomeMainNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const CartPage(),
    const FavoritePage(),
    const UserProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật chỉ số được chọn
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Hiển thị trang tương ứng
      bottomNavigationBar: HomeNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped, // Gọi hàm khi nhấn vào biểu tượng
      ),
    );
  }
}
