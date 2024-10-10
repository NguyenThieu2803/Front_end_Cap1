import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
        title: Text("User Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200], 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200], 
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 40, color: Colors.black),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'User',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              // Divider below the profile section
              Divider(thickness: 1),

              // Purchase Order Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shopping_cart,
                          color: Colors.black), 
                      SizedBox(width: 8),
                      Text(
                        "Purchase Order",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {}, 
                    child: Row(
                      children: [
                        Text("View purchase history"),
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
              // Divider after the purchase order section
              Divider(thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOrderStatusButton(
                      Icons.check_box, "Wait for confirmation", Colors.blue),
                  _buildOrderStatusButton(
                      Icons.inbox, "Awaiting delivery", Colors.orange),
                  _buildOrderStatusButton(
                      Icons.local_shipping, "Waiting for delivery", Colors.red),
                  _buildOrderStatusButton(
                      Icons.star, "Evaluate", Colors.yellow),
                ],
              ),
              SizedBox(height: 20),

              // Divider above My Utilities section
              Divider(thickness: 1),
              Row(
                children: [
                  Icon(Icons.settings,
                      color: Colors.black), // Biểu tượng cho My Utilities
                  SizedBox(width: 8),
                  Text(
                    "My Utilities",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              // Divider below My Utilities section
              Divider(thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildUtilityButton(
                      Icons.attach_money, "Accumulate points", Colors.orange),
                  _buildUtilityButton(
                      Icons.card_giftcard, "Voucher", Colors.red),
                ],
              ),
              Divider(thickness: 1), // Added divider below My Utilities section
            ],
          ),
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
