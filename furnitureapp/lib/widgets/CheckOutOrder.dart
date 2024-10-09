import 'package:flutter/material.dart';

class CheckOutOrder extends StatelessWidget {
  final double productTotal;
  final double transportFee;

  const CheckOutOrder({
    super.key,
    required this.productTotal,
    required this.transportFee,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20), // Thêm khoảng cách phía trên
        Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 8),
          child: Text(
            "Order summary",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 15),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildRow("Product", "\$$productTotal"),
              SizedBox(height: 8),
              _buildRow("Transport", "\$$transportFee"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1, color: Colors.grey[300]),
              ),
              _buildRow("Total", "\$${productTotal + transportFee}", isBold: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? const Color(0xFF2B2321) : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? const Color(0xFF2B2321) : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}