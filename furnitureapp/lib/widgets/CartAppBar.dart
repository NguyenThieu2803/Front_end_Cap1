import 'package:flutter/material.dart';
import 'package:furnitureapp/services/ar_service.dart';
import 'package:furnitureapp/widgets/CartARViewer.dart';
import 'package:furnitureapp/pages/HomePage.dart'; // Đảm bảo bạn import đúng file HomePage
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import the Font Awesome package
// Import the AR plugin

class CartAppBar extends StatefulWidget {
  const CartAppBar({super.key});

  @override
  _CartAppBarState createState() => _CartAppBarState();
}

class _CartAppBarState extends State<CartAppBar> {
  void _openARViewer(BuildContext context) async {
    // Kiểm tra khả năng AR trước khi mở
    bool hasARCapability = await ArService.checkARCapabilities();
    if (!hasARCapability) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your device does not support AR features')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartARViewer(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              // Chuyển về trang chủ
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child: Icon(
              Icons.arrow_back,
              size: 30,
              color: Color(0xFF2B2321),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 1.0),
              child: Center(
                child: Text(
                  "Cart",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B2321),
                  ),
                ),
              ),
            ),
          ),
          // Unity icon with left padding to adjust its position
          Padding(
            padding: const EdgeInsets.only(right: 1.0),  // Adjust this value to move the icon left or right
            child: InkWell(
              onTap: () => _openARViewer(context),
              child: FaIcon(
                FontAwesomeIcons.unity,  // Unity icon from Font Awesome
                size: 25,
                color: Color(0xFF2B2321),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
