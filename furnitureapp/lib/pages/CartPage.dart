import 'package:flutter/material.dart';
import 'package:furnitureapp/widgets/CartAppBar.dart';
import 'package:furnitureapp/widgets/CartBottomNavBar.dart';
import 'package:furnitureapp/widgets/CartItemSamples.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CartAppBar(), // AppBar sẽ luôn ở trên cùng
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
                    padding: EdgeInsets.only(top: 10),
                    children: [
                      CartItemSamples(),
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
      bottomNavigationBar: CartBottomNavBar(),
    );
  }
}