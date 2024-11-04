import 'package:flutter/material.dart';

class EditProductAppBar extends StatelessWidget {
  final String initialProductName;
  final String initialProductDescription;
  final double initialPrice;
  final VoidCallback? onAddPressed;
  final bool isFormValid;

  const EditProductAppBar({
    super.key,
    required this.initialProductName,
    required this.initialProductDescription,
    required this.initialPrice,
    required this.isFormValid,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 60, // Reduced from 70 to 60 to move content up
        bottom: 20,
      ),
      color: Colors.white,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Color(0xFF2B2321),
              ),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Center(
              child: const Text(
                "Edit Product",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B2321),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: isFormValid ? onAddPressed : null,
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(
              "Save",
              style: TextStyle(
                color: Colors.red.withOpacity(isFormValid ? 1.0 : 0.5),
                fontSize: 23,
                fontWeight: isFormValid ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }
}
