import 'package:flutter/material.dart';

class UserProfileItemSamples extends StatelessWidget {
  const UserProfileItemSamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Section
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.black),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'User',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Divider below the profile section          
            Divider(thickness: 1),

            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 8),
                    Text(
                      "Purchase Order",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2B2321),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Adding space before the order status buttons
            SizedBox(height: 10),

            // Order status buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOrderStatusButton(
                    Icons.check_box, "Wait for confirmation", Colors.black, context, _onWaitForConfirmation),
                _buildOrderStatusButton(
                    Icons.local_shipping, "Waiting for delivery", Colors.black, context, _onWaitingForDelivery),
                _buildOrderStatusButton(
                    Icons.star, "Evaluate", Colors.black, context, _onEvaluate),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper function to build buttons for purchase order status
  Widget _buildOrderStatusButton(IconData icon, String label, Color color, BuildContext context, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 40, color: color),
          SizedBox(height: 8),
          Text(label,
              textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // Event handlers for each button
  void _onWaitForConfirmation() {
    // Xử lý sự kiện khi ấn vào "Wait for confirmation"
    print("Wait for confirmation clicked");
  }

  void _onWaitingForDelivery() {
    // Xử lý sự kiện khi ấn vào "Waiting for delivery"
    print("Waiting for delivery clicked");
  }

  void _onEvaluate() {
    // Xử lý sự kiện khi ấn vào "Evaluate"
    print("Evaluate clicked");
  }
}
