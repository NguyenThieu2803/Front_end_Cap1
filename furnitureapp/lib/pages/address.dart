import 'add_new_address.dart';
import '../model/address_model.dart';
import 'package:flutter/material.dart';
import 'package:furnitureapp/pages/update_address.dart';
import '../api/api.service.dart'; // Import the APIService
import '../services/data_service.dart'; // Import the DataService


class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  List<AddressUser> addresses = [];
  final DataService dataService = DataService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAddresses(); // Fetch addresses on initialization
  }

  Future<void> _fetchAddresses() async {
    try {
      List<AddressUser> addressList = await dataService.loadAddresses();
      setState(() {
        addresses = addressList;
      });
    } catch (e) {
      print("Error fetching addresses: $e");
    }
  }

  Future<void> _deleteAddress(String addressId) async {
    try {
      bool success = await APIService.deleteAddress(addressId);
      if (success) {
        setState(() {
          addresses.removeWhere((address) => address.id == addressId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Address deleted successfully')),
        );
      }
    } catch (e) {
      print("Error deleting address: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete address')),
      );
    }
  }

  Future<void> _setDefaultAddress(AddressUser address) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Call API to update address with correct boolean type
      final response = await APIService.updateAddress(
        address.id,
        address.fullName,
        address.phoneNumber,
        address.streetAddress,
        address.district,
        address.ward,
        address.commune,
        address.city,
        address.province,
        true, // Explicitly pass boolean true instead of String
      );

      if (response) {
        setState(() {
          // Set all addresses to non-default
          for (var addr in addresses) {
            addr.isDefault = false;
          }
          // Find and update the current address
          final index = addresses.indexWhere((addr) => addr.id == address.id);
          if (index != -1) {
            addresses[index].isDefault = true;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Default address updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error setting default address: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update default address'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateAddress(AddressUser address) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateAddressPage(address: address),
      ),
    );

    if (result != null) {
      try {
        bool success = await APIService.updateAddress(
          address.id,
          result['fullName'],
          result['phoneNumber'],
          result['streetAddress'],
          result['district'],
          result['ward'],
          result['commune'],
          result['city'],
          result['province'],
          result['isDefault'],
        );

        if (success) {
          setState(() {
            int index = addresses.indexWhere((a) => a.id == address.id);
            if (index != -1) {
              addresses[index] = AddressUser(
                id: address.id,
                userId: address.userId,
                fullName: result['fullName'],
                phoneNumber: result['phoneNumber'],
                streetAddress: result['streetAddress'],
                district: result['district'],
                ward: result['ward'],
                commune: result['commune'],
                city: result['city'],
                province: result['province'],
                isDefault: result['isDefault'],
              );
              if (result['isDefault']) {
                _setDefaultAddress(addresses[index]);
              }
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Address updated successfully')),
          );
        }
      } catch (e) {
        print("Error updating address: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update address')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(address.fullName),
                                      SizedBox(width: 8),
                                      SizedBox(width: 8),
                                      Text(
                                        address.phoneNumber,
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.settings),
                                    onPressed: () => _updateAddress(address),
                                  ),
                                ],
                              ),
                              Divider(thickness: 1),
                              Text(address.streetAddress),
                              Divider(thickness: 1),
                              Text(
                                  '${address.ward}, ${address.district}, ${address.city}, ${address.province}'),
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
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () => _deleteAddress(address.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.white),
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
                          final newAddress = AddressUser(
                            id: result['id'], // Ensure you provide the id here
                            userId: result['userId'],
                            fullName: result['fullName'],
                            phoneNumber: result['phoneNumber'],
                            streetAddress: result['streetAddress'],
                            district: result['district'],
                            ward: result['ward'],
                            commune: result['commune'],
                            city: result['city'],
                            province: result['province'],
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
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
