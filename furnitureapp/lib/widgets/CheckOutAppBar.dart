import 'package:flutter/material.dart';

class CheckOutAppBar extends StatefulWidget {
  const CheckOutAppBar({super.key});

  @override
  _CheckOutAppBarState createState() => _CheckOutAppBarState();
}

class _CheckOutAppBarState extends State<CheckOutAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              // goes back to previous screen/page
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              size: 30,
              color: Color(0xFF2B2321),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 30), // Thêm padding bên phải
              child: Center(
                child: Text(
                  "Check Out",
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