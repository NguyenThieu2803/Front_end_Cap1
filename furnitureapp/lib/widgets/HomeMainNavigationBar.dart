import 'package:flutter/material.dart';
import 'package:furnitureapp/pages/CartPage.dart';
import 'package:furnitureapp/pages/FavoritePage.dart';
import 'package:furnitureapp/pages/Homepage.dart';
import 'package:furnitureapp/pages/UserProfilePage.dart';
import 'package:furnitureapp/widgets/HomeNavigationBar.dart';

class HomeMainNavigationBar extends StatefulWidget {
  const HomeMainNavigationBar({Key? key}) : super(key: key);

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
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: HomeNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
