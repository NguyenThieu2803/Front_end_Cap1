import 'package:flutter/material.dart';
import 'package:furnitureapp/pages/account_security.dart';
import 'package:furnitureapp/pages/bank_account_card.dart';
import 'package:furnitureapp/pages/language.dart';
import 'address.dart';
import 'notification_settings.dart';


class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Handle back button press
          },
        ),
        title: Text(
          'Account Setup',
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // My account section
          buildSectionTitle('My account'),
          buildListTile(context, 'Account & Security', () {
            // Handle navigation to Account & Security
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AccountSecurityPage()));
          }),
          buildListTile(context, 'Address', () {
            // Handle navigation to Address
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddressPage()));
          }),
          buildListTile(context, 'Bank Account/Card', () {
            // Handle navigation to Bank Account/Card
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BankAccountPage()));
          }),

          // Setting section
          buildSectionTitle('Setting'),
          buildListTile(context, 'Notification settings', () {
            // Handle navigation to Notification settings
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotificationSettingsPage()));
          }),
          buildListTile(context, 'Language', () {
            // Handle navigation to Language page
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LanguagePage(onLanguageChanged: (String ) {  },)));
          }),

          // Support section
          buildSectionTitle('Support'),
          buildListTile(context, 'Support center', () {
            // Handle navigation to Support center
          }),
          buildListTile(context, 'Community standards', () {
            // Handle navigation to Community standards
          }),
          buildListTile(context,
              'Satisfied with FurniFit AR? Let\'s evaluate together', () {}),

          // Log Out button
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle log out
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Black background
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                'Log Out',
                style:
                    TextStyle(fontSize: 18, color: Colors.white), // White text
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 0.0, 5.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildListTile(
      BuildContext context, String title, VoidCallback onPressed) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onPressed, // Use the onPressed function passed from the parent
      ),
    );
  }
}
