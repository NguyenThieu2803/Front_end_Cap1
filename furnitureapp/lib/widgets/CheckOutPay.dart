import 'package:flutter/material.dart';

class CheckOutPay extends StatefulWidget {
  final String selectedMethod;
  final Function(String?) onChanged;

  const CheckOutPay({
    super.key,
    required this.selectedMethod,
    required this.onChanged,
  });

  @override
  State<CheckOutPay> createState() => _CheckOutPayState();
}

class _CheckOutPayState extends State<CheckOutPay> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.only(left: 15, bottom: 8),
          child: Text(
            "Payment method",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              buildPaymentMethod(
                title: "Payment Upon Receipt",
                icon: Icons.local_shipping,
              ),
              buildPaymentMethod(
                title: "Credit Card",
                icon: Icons.credit_card,
              ),
              buildPaymentMethod(
                title: "Bank Card",
                icon: Icons.account_balance,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPaymentMethod({
    required String title,
    required IconData icon,
  }) {
    return GestureDetector( // Thay InkWell bằng GestureDetector
      onTap: () => widget.onChanged(title),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, size: 24,
            color: Color(0xFF2B2321),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Radio<String>(
              value: title,
              groupValue: widget.selectedMethod,
              onChanged: widget.onChanged,
              activeColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}