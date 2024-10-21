import 'package:flutter/material.dart';

class UserDetailsView extends StatelessWidget {
  final Map<String, String> user;

  const UserDetailsView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('User Details View', style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () {
              // Implement save functionality
            },
            child: const Text('Save', style: TextStyle(color: Colors.red)),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/default_avatar.png'),
              ),
              const SizedBox(height: 20),
              buildInfoCard(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement deactivate account functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Deactivate Account', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildInfoRow(Icons.person, user['name'] ?? 'N/A'),
            const Divider(),
            buildInfoRow(Icons.location_on, user['address'] ?? 'N/A'),
            const Divider(),
            buildInfoRow(Icons.phone, user['phone'] ?? 'N/A'),
            const Divider(),
            buildInfoRow(Icons.email, user['email'] ?? 'N/A'),
            const Divider(),
            buildInfoRow(Icons.lock, user['password'] ?? 'N/A', obscure: true),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String value, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              obscure ? '••••••••' : value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}