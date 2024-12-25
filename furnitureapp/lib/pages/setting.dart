import 'package:flutter/material.dart';
import 'package:furnitureapp/translate/localization.dart';
import 'package:furnitureapp/pages/language.dart';
import 'package:furnitureapp/pages/bank_account_card.dart';
import 'package:furnitureapp/pages/notification_settings.dart';
import 'package:furnitureapp/services/auth_service.dart';
import 'account_security.dart';
import 'address.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  void _handleLogout(BuildContext context) {
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
              onPressed: () async {
                Navigator.of(context).pop(); // Đóng dialog
                await AuthService.logout(context); // Thực hiện logout
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.appTitle,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            buildSectionTitle(l10n.myAccount),
            buildListTile(context, l10n.accountSecurity, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AccountSecurityPage()));
            }),
            buildListTile(context, l10n.address, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddressPage()));
            }),
            buildListTile(context, l10n.bankAccount, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BankAccountPage()));
            }),
            buildSectionTitle(l10n.setting),
            buildListTile(context, l10n.notificationSettings, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationSettingsPage()));
            }),
            buildListTile(context, l10n.language, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LanguagePage()));
            }),
            buildSectionTitle(l10n.supportCenter),
            buildListTile(context, l10n.supportCenter, () {}),
            buildListTile(context, l10n.communityStandards, () {}),
            buildListTile(context, l10n.satisfactionSurvey, () {}),
            SizedBox(height: 20), // Add some space before the logout button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => _handleLogout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  l10n.logOut,
                  style: const TextStyle(
                    fontSize: 18, 
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 0.0, 5.0),
      child: Text(
        title,
        style: const TextStyle(
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
      child: Column(
        children: [
          ListTile(
            title: Text(title),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: onPressed,
          ),
        ],
      ),
    );
  }
}
