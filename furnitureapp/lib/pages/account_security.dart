import 'package:flutter/material.dart';
import 'package:furnitureapp/pages/add_gmail.dart';
import 'package:furnitureapp/pages/add_phone_number.dart';
import 'package:furnitureapp/pages/change_password.dart';
import 'package:furnitureapp/pages/edit_profile.dart';

class AccountSecurityPage extends StatelessWidget {
  const AccountSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Account & Security',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    title: 'My profile',
                    onTap: () {
                      // Handle my profile tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditProfilePage()),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    title: 'Phone number',
                    onTap: () {
                      // Handle phone number tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddPhoneNumberPage()),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    title: 'Gmail',
                    onTap: () {
                      // Handle gmail tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddGmailPage()),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    title: 'Change password',
                    onTap: () {
                      // Handle change password tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePasswordPage()),
                      );
                    },
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFEEEEEE),
      indent: 16,
      endIndent: 16,
    );
  }
}
