import 'package:flutter/material.dart';
import '../model/address_model.dart';

class AddNewAddressPage extends StatefulWidget {
  final List<Address> existingAddresses;

  const AddNewAddressPage({
    super.key,
    required this.existingAddresses,
  });

  @override
  _AddNewAddressPageState createState() => _AddNewAddressPageState();
}

class _AddNewAddressPageState extends State<AddNewAddressPage> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  bool isDefaultAddress = false;
  String selectedProvince = '';
  String selectedDistrict = '';
  String selectedCommune = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add New Address',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Contact',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    TextField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                    ),
                    const Divider(height: 1, color: Colors.grey),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Address',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showAddressBottomSheet(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 13),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedProvince.isEmpty
                                    ? 'Province/City, District/District, Ward/Commune'
                                    : '$selectedProvince, $selectedDistrict, $selectedCommune',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios,
                                color: Colors.grey, size: 16),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: Colors.grey),
                    TextField(
                      controller: _streetController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Street name, Building, House number',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Set as default address'),
                    Switch(
                      value: isDefaultAddress,
                      onChanged: (value) {
                        setState(() {
                          isDefaultAddress = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (_fullNameController.text.isEmpty ||
                      _phoneController.text.isEmpty ||
                      _streetController.text.isEmpty ||
                      selectedProvince.isEmpty ||
                      selectedDistrict.isEmpty ||
                      selectedCommune.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all fields'),
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context, {
                    'fullName': _fullNameController.text,
                    'phoneNumber': _phoneController.text,
                    'streetAddress': _streetController.text,
                    'province': selectedProvince,
                    'district': selectedDistrict,
                    'commune': selectedCommune,
                    'isDefault': isDefaultAddress,
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  'Complete',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddressBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Select Address',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: selectedProvince.isEmpty ? null : selectedProvince,
                    hint: const Text('Select Province/City'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedProvince = newValue!;
                        selectedDistrict = '';
                        selectedCommune = '';
                      });
                    },
                    items: <String>['Hanoi', 'Ho Chi Minh City', 'Da Nang']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: selectedDistrict.isEmpty ? null : selectedDistrict,
                    hint: const Text('Select District'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDistrict = newValue!;
                        selectedCommune = '';
                      });
                    },
                    items: <String>['District 1', 'District 2', 'District 3']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: selectedCommune.isEmpty ? null : selectedCommune,
                    hint: const Text('Select Ward/Commune'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCommune = newValue!;
                      });
                    },
                    items: <String>['Ward 1', 'Ward 2', 'Ward 3']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text('Done'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    super.dispose();
  }
}
