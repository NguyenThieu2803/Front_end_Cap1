import 'package:flutter/material.dart';

class UserProfileItemSamples extends StatelessWidget {
  const UserProfileItemSamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Section
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey[200], // Changed to white for better contrast
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white, // Slightly grey background
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

            SizedBox(height: 5), // Thêm khoảng cách ở đây
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
            SizedBox(height: 10), // Thêm khoảng cách ở đây

            // Order status buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOrderStatusButton(
                    Icons.check_box, "Wait for confirmation", Colors.black),
                _buildOrderStatusButton(
                    Icons.local_shipping, "Waiting for delivery", Colors.black),
                _buildOrderStatusButton(Icons.star, "Evaluate", Colors.black),
              ],
            ),
            SizedBox(height: 20), // Khoảng cách dưới hàng biểu tượng

            // Divider above My Utilities section
          ],
        ),
      ),
    );
  }

  // Helper function to build buttons for purchase order status
  Widget _buildOrderStatusButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, size: 40, color: color),
        SizedBox(height: 8),
        Text(label,
            textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  // Helper function to build utilities buttons
  Widget _buildUtilityButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, size: 40, color: color),
        SizedBox(height: 8),
        Text(label,
            textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
