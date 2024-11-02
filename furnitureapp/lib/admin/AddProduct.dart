import 'package:flutter/material.dart';
import 'package:furnitureapp/widgets/AddProductAppBar.dart';
import 'package:furnitureapp/widgets/AddProductItemSamples.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final String productName = "Sample Product";
  final String productDescription = "Sample Description";
  final double price = 0.0;
  bool isFormValid = false; // Initially, the "Save" button will be disabled

  void _onFieldChanged(bool hasChanged) {
    setState(() {
      isFormValid = hasChanged; // Update the "Save" button state when changes occur
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AddProductAppBar(
            initialProductName: productName,
            initialProductDescription: productDescription,
            initialPrice: price,
            isFormValid: isFormValid,
            onAddPressed: isFormValid
                ? () {
                    // Handle the event when the Save button is pressed
                    print("Add button pressed");
                  }
                : null,
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFEDECF2),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: ListView(
                  padding: const EdgeInsets.only(top: 10),
                  children: [
                    AddProductItemSamples(
                      onValidationChanged: _onFieldChanged, // Pass the callback function here
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
