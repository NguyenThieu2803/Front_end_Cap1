import 'package:flutter/material.dart';
import 'package:furnitureapp/widgets/CartAppBar.dart';
import 'package:furnitureapp/widgets/CartItemSamples.dart';
import 'package:furnitureapp/widgets/CartBottomNavBar.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double _totalAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CartAppBar(),
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
                      CartItemSamples(
                        onTotalPriceChanged: (double totalPrice) {
                          setState(() {
                            _totalAmount = totalPrice;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CartBottomNavBar(totalAmount: _totalAmount),
    );
  }
}
