import 'package:flutter/material.dart';
import 'package:furnitureapp/widgets/EditProductAppBar.dart';
import 'package:furnitureapp/widgets/EditProductItemSamples.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({super.key});

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final String productName = "Sample Product";
  final String productDescription = "Sample Description";
  final double price = 0.0;
  bool isFormValid = false; // Ban đầu nút "Save" sẽ mờ đi

  void _onFieldChanged(bool hasChanged) {
    setState(() {
      isFormValid = hasChanged; // Cập nhật nút "Save" khi có thay đổi
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          EditProductAppBar(
            initialProductName: productName,
            initialProductDescription: productDescription,
            initialPrice: price,
            isFormValid: isFormValid,
            onAddPressed: isFormValid
                ? () {
                    // Xử lý sự kiện khi nhấn nút Save
                    print("Save button pressed");
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
                    EditProductItemSamples(
                      onFieldChanged: _onFieldChanged,
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
