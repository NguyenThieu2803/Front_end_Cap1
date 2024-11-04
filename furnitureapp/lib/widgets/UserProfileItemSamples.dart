import 'package:flutter/material.dart';
import 'package:furnitureapp/widgets/Evaluate.dart';
import 'package:furnitureapp/widgets/WaitForConfirmation.dart';
import 'package:furnitureapp/widgets/WaitingForDelivery.dart';

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
            SizedBox(height: 10),
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

  // Updated: Change onTap's type to a function that accepts BuildContext
  Widget _buildOrderStatusButton(
      IconData icon, String label, Color color, BuildContext context, Function(BuildContext) onTap) {
    return InkWell(
      onTap: () => onTap(context),
      child: Column(
        children: [
          Icon(icon, size: 40, color: color),
          SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // Event handlers for each button with navigation
  void _onWaitForConfirmation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WaitForConfirmation()),
    );
  }

  void _onWaitingForDelivery(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WaitingForDelivery()),
    );
  }

  void _onEvaluate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Evaluate()),
    );
  }
}
