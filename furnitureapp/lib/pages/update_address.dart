import 'dart:convert';
import '../model/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../api/api.service.dart'; // Import the API service

class UpdateAddressPage extends StatefulWidget {
  final AddressUser address;

  const UpdateAddressPage({
    super.key,
    required this.address,
  });

  @override
  _UpdateAddressPageState createState() => _UpdateAddressPageState();
}

class _UpdateAddressPageState extends State<UpdateAddressPage> {
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _streetController;
  bool isDefaultAddress = false;
  String selectedProvince = '';
  String selectedDistrict = '';
  String selectedWard = '';
  List<dynamic> provinces = [];
  List<dynamic> districts = [];
  List<dynamic> wards = [];

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.address.fullName);
    _phoneController = TextEditingController(text: widget.address.phoneNumber);
    _streetController = TextEditingController(text: widget.address.streetAddress);
    isDefaultAddress = widget.address.isDefault;
    selectedProvince = widget.address.province;
    selectedDistrict = widget.address.district;
    selectedWard = widget.address.ward;
    _loadAddressData();
  }

  Future<void> _loadAddressData() async {
    final String response = await rootBundle.loadString(
        'assets/detail/vn_only_simplified_json_generated_data_vn_units.json');
    final data = await json.decode(response);
    setState(() {
      provinces = data;
      // Initialize districts and wards based on the current address
      districts = provinces.firstWhere((province) =>
          province['FullName'] == selectedProvince)['District'];
      wards = districts.firstWhere((district) =>
          district['FullName'] == selectedDistrict)['Ward'];
    });
  }

  Future<void> _updateAddress() async {
    if (_fullNameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _streetController.text.isEmpty ||
        selectedProvince.isEmpty ||
        selectedDistrict.isEmpty ||
        selectedWard.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return;
    }

    try {
      bool success = await APIService.updateAddress(
        widget.address.id,
        _fullNameController.text,
        _phoneController.text,
        _streetController.text,
        selectedDistrict,
        selectedWard,
        selectedWard,
        selectedDistrict,
        selectedProvince,
        isDefaultAddress,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Address updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, {
          'id': widget.address.id,
          'userId': widget.address.userId,
          'fullName': _fullNameController.text,
          'phoneNumber': _phoneController.text,
          'streetAddress': _streetController.text,
          'district': selectedDistrict,
          'ward': selectedWard,
          'commune': selectedWard,
          'city': selectedDistrict,
          'province': selectedProvince,
          'isDefault': isDefaultAddress,
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

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
          'Update Address',
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
                      keyboardType: TextInputType.text,
                      enableSuggestions: true,
                      autocorrect: true,
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
                                    : '$selectedProvince, $selectedDistrict, $selectedWard',
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
                onPressed: _updateAddress, // Call the update function
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  'Update',
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
                        selectedWard = '';
                        districts = provinces.firstWhere((province) =>
                            province['FullName'] == newValue)['District'];
                      });
                    },
                    items: provinces
                        .map<DropdownMenuItem<String>>((dynamic province) {
                      return DropdownMenuItem<String>(
                        value: province['FullName'],
                        child: Text(province['FullName']),
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
                        selectedWard = '';
                        wards = districts.firstWhere((district) =>
                            district['FullName'] == newValue)['Ward'];
                      });
                    },
                    items: districts
                        .map<DropdownMenuItem<String>>((dynamic district) {
                      return DropdownMenuItem<String>(
                        value: district['FullName'],
                        child: Text(district['FullName']),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: selectedWard.isEmpty ? null : selectedWard,
                    hint: const Text('Select Ward/Commune'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedWard = newValue!;
                      });
                    },
                    items: wards
                        .map<DropdownMenuItem<String>>((dynamic ward) {
                      return DropdownMenuItem<String>(
                        value: ward['FullName'],
                        child: Text(ward['FullName']),
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
