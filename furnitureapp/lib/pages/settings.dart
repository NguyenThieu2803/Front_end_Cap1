import 'package:flutter/material.dart';
import 'package:furnitureapp/services/auth_service.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // ...existing code...

  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                AuthService.logout(context); // Perform logout
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildLogoutButton() {
    return ListTile(
      leading: Icon(Icons.logout, color: Colors.red),
      title: Text(
        'Logout',
        style: TextStyle(color: Colors.red),
      ),
      onTap: _handleLogout,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          // ...existing settings options...
          _buildLogoutButton(),
        ],
      ),
    );
  }
}
