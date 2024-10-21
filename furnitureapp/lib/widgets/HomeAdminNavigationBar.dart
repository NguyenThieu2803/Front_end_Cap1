import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomeAdminNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const HomeAdminNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      onTap: onTap, // Xử lý sự kiện nhấn
      height: 70,
      color: const Color(0xFF2B2321),
      index: selectedIndex,
      items: const [
        Icon(
          Icons.home,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.shopping_cart,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.admin_panel_settings,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.favorite,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.person,
          size: 30,
          color: Colors.white,
        ),
      ],
      animationDuration: const Duration(milliseconds: 300), // Thời gian hoạt ảnh
      animationCurve: Curves.easeInOut, // Đường cong hoạt ảnh
    );
  }
}
