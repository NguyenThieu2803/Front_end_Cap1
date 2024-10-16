import 'package:flutter/material.dart';
import 'package:furnitureapp/admin/user_details_view.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final List<Map<String, String>> allUsers = [
    {"name": "Chiến Thiều", "address": "Da Nang", "phone": "0353654234"},
    {"name": "Bất Khả Thắng Bại", "address": "Da Nang", "phone": "0823362835"},
    {"name": "Giang Hồ Hiểm Ác", "address": "Da Nang", "phone": "0353654234"},
    {
      "name": "Chiến Thần Thăng Chinh",
      "address": "Da Nang",
      "phone": "0353654234"
    },
    {"name": "Thiên An", "address": "Da Nang", "phone": "0353654234"},
  ];

  List<Map<String, String>> displayedUsers = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayedUsers = allUsers;
  }

  void searchUsers() {
    setState(() {
      displayedUsers = allUsers
          .where((user) =>
              user["name"]!
                  .toLowerCase()
                  .contains(_nameController.text.toLowerCase()) &&
              user["phone"]!.contains(_phoneController.text) &&
              user["address"]!
                  .toLowerCase()
                  .contains(_addressController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('User Management',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: 'Phone',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: 'Address',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: searchUsers,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Check', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: displayedUsers.isEmpty
                  ? const Center(
                      child: Text("No users found",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)))
                  : ListView.builder(
                      itemCount: displayedUsers.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/default_avatar.png'),
                            ),
                            title: Text(displayedUsers[index]["name"]!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Address: ${displayedUsers[index]["address"]}"),
                                Text(
                                    "Phone: ${displayedUsers[index]["phone"]}"),
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserDetailsView(
                                      user: displayedUsers[index]),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
