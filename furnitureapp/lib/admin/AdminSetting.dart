import 'package:flutter/material.dart';
import 'package:furnitureapp/admin/UserManagement.dart';
import 'package:furnitureapp/admin/OrderManagement.dart';
import 'package:furnitureapp/admin/ProductManagement.dart';
import 'package:furnitureapp/admin/ReviewAndFeedback.dart';
import 'package:furnitureapp/admin/InventoryManagement.dart';


class AdminSetting extends StatelessWidget {
  const AdminSetting({super.key});

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Widget _buildSettingItem(String title, BuildContext context, Widget destinationScreen, {bool showDivider = true}) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.black54,
          ),
          onTap: () => _navigateToScreen(context, destinationScreen),
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDECF2),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
          size: 30,
          color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Admin Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 20, bottom: 8),
            child: Text(
              'Admin account',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSettingItem('User Management', context, const UserManagement()),
                _buildSettingItem('Product Management', context, const ProductManagement() /* ProductManagement() */),
                _buildSettingItem('Order Management', context, const OrderManagement() /* OrderManagement() */),
                _buildSettingItem('Inventory Management', context, const InventoryManagement() /* InventoryManagement() */),
                _buildSettingItem('Promotions and Discounts', context, Container() /* PromotionsAndDiscounts() */),
                _buildSettingItem('Review and Feedback', context, const ReviewAndFeedback() /* ReviewAndFeedback() */),
                _buildSettingItem('Analytics and Reporting', context, Container() /* AnalyticsAndReporting() */),
                _buildSettingItem('Notification Management', context, Container() /* NotificationManagement() */, showDivider: false),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D2D2D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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