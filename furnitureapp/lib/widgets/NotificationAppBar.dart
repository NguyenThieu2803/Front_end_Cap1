import 'package:flutter/material.dart';
import 'package:furnitureapp/pages/HomePage.dart';

class NotificationAppBar extends StatefulWidget {
  const NotificationAppBar({super.key});

  @override
  _NotificationAppBarState createState() => _NotificationAppBarState();
}

class _NotificationAppBarState extends State<NotificationAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 80, 
        bottom: 20,
      ),
      color: Colors.white,
      child: Row(
        children: [
          // Back button with padding
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Color(0xFF2B2321),
              ),
            ),
          ),
          // Expanded to push the title to the center
          Expanded(
            child: Center(
              child: Text(
                "Notification",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B2321),
                ),
              ),
            ),
          ),
          // Empty padding to balance the back button
          const SizedBox(width: 46), // 30 (icon size) + 16 (left padding)
        ],
      ),
    );
  }
}