import 'package:flutter/material.dart';
import 'package:furnitureapp/services/data_service.dart';
import 'package:furnitureapp/model/UserProfile_model.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final DataService dataService = DataService();
  UserProfile? _userProfileScreen; // Optional to handle null checks

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    UserProfile? userProfile = await dataService.loadUserProfile();
    print("This is user profile: ${userProfile}"); // Added print statement for debugging
    if (userProfile != null) {
      setState(() {
        _userProfileScreen = userProfile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Added onPressed callback for back navigation
          },
        ),
        title: Text("User Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: _userProfileScreen == null
          ? Center(child: CircularProgressIndicator()) // Display loading indicator
          : Container(
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
                            backgroundImage: _userProfileScreen!.profileImage.isNotEmpty
                                ? NetworkImage(_userProfileScreen!.profileImage)
                                : null,
                            child: _userProfileScreen!.profileImage.isEmpty
                                ? Icon(Icons.person, size: 40, color: Colors.black)
                                : null,
                          ),
                          SizedBox(width: 16),
                          Text(
                            _userProfileScreen!.userName,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                            Icon(Icons.shopping_cart, color: Colors.black),
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
                        _buildOrderStatusButton(Icons.check_box, "Wait for confirmation", Colors.blue),
                        _buildOrderStatusButton(Icons.inbox, "Awaiting delivery", Colors.orange),
                        _buildOrderStatusButton(Icons.local_shipping, "Waiting for delivery", Colors.red),
                        _buildOrderStatusButton(Icons.star, "Evaluate", Colors.yellow),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Divider above My Utilities section
                    Divider(thickness: 1),
                    Row(
                      children: [
                        Icon(Icons.settings, color: Colors.black),
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
                        _buildUtilityButton(Icons.attach_money, "Accumulate points", Colors.orange),
                        _buildUtilityButton(Icons.card_giftcard, "Voucher", Colors.red),
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
        Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  // Helper function to build utilities buttons
  Widget _buildUtilityButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, size: 40, color: color),
        SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
