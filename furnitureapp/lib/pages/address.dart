import 'add_new_address.dart';
import '../model/address_model.dart';
import 'package:flutter/material.dart';
import '../services/data_service.dart'; // Import the DataService

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  List<Address> addresses = [];
  final DataService dataService = DataService();

  @override
  void initState() {
    super.initState();
    _fetchAddresses(); // Fetch addresses on initialization
  }

  Future<void> _fetchAddresses() async {
    try {
      List<Address> addressList = await dataService.loadAddresses();
      setState(() {
        addresses = addressList;
      });
    } catch (e) {
      print("Error fetching addresses: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Address',
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Address',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(address.fullName),
                              SizedBox(width: 8),
                              Text('|'),
                              SizedBox(width: 8),
                              Text(
                                address.phoneNumber,
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                          Divider(thickness: 1),
                          Text(address.streetAddress),
                          Divider(thickness: 1),
                          Text(
                              '${address.commune}, ${address.district}, ${address.province}'),
                          SizedBox(height: 8),
                          if (address.isDefault)
                            ElevatedButton(
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.red),
                              ),
                              child: Text(
                                'Default',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: TextButton.icon(
                onPressed: () async {
                  final result = await Navigator.push<Map<String, dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddNewAddressPage(
                        existingAddresses: addresses,
                      ),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      final newAddress = Address(
                        fullName: result['fullName'],
                        phoneNumber: result['phoneNumber'],
                        streetAddress: result['streetAddress'],
                        province: result['province'],
                        district: result['district'],
                        commune: result['commune'],
                        isDefault: result['isDefault'],
                      );

                      if (newAddress.isDefault) {
                        for (var address in addresses) {
                          address.isDefault = false;
                        }
                        addresses.insert(0, newAddress);
                      } else {
                        addresses.add(newAddress);
                      }
                    });
                  }
                },
                icon: Icon(Icons.add_circle, color: Colors.red),
                label: Text(
                  'Add New Address',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
