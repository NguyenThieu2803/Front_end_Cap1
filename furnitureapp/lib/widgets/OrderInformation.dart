import 'package:flutter/material.dart';
import 'package:furnitureapp/model/order_model.dart';

class OrderInformation extends StatefulWidget {
  final OrderData orderData;

  const OrderInformation({
    Key? key,
    required this.orderData,
  }) : super(key: key);

  @override
  _OrderInformationState createState() => _OrderInformationState();
}

class _OrderInformationState extends State<OrderInformation> {
  bool _isCancelling = false;

  void _cancelOrder() async {
    setState(() {
      _isCancelling = true;
    });

    // Add your order cancellation logic here
    await Future.delayed(const Duration(seconds: 2)); // Simulating cancellation process

    // Navigate back to the previous screen after successful cancellation
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(58.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Container(
            margin: const EdgeInsets.only(top: 5.0),
            child: const Text(
              'Order Information',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFEDECF2),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    _buildStatusSection(),
                    _buildAddressSection(),
                    _buildShopSection(),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Wait for the seller to send the goods',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.payment, color: Colors.white),
              const SizedBox(width: 5),
              Text(
                'Payment by ${widget.orderData.paymentMethod}',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Address',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.location_on),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${widget.orderData.shippingAddress.fullName} - ${widget.orderData.shippingAddress.phoneNumber}'),
                    Text(widget.orderData.shippingAddress.fullAddress),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add edit address functionality
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Transform.translate(
                  offset: const Offset(20, -45), // Shift the icon up
                  child: const Icon(Icons.edit),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShopSection() {
    return Container(
      padding: const EdgeInsets.only(right: 8, left: 8, bottom: 15),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          ...widget.orderData.products.map((product) {
            return Column(
              children: [
                _buildProductItem(
                  product.product.name ?? '',
                  product.product.shortDescription ?? '',
                  '\$${product.amount.toStringAsFixed(0)}',
                  '\$${(product.amount * 1.5).toStringAsFixed(0)}', // Assuming original price is 50% higher
                  product.quantity,
                  product.product.images?.first ?? '',
                ),
                if (product != widget.orderData.products.last) const Divider(),
              ],
            );
          }).toList(),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${widget.orderData.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(String title, String description, String price,
      String oldPrice, int quantity, String imageUrl) {
    return Column(
      children: [
        Row(
          children: [
            Image.network(
              imageUrl,
              width: 60,
              height: 60,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                );
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Row(
                    children: [
                      Text(
                        oldPrice,
                        style: const TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        price,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text('x$quantity'),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_isCancelling)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            ElevatedButton(
              onPressed: _cancelOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Cancel Order'),
            ),
        ],
      ),
    );
  }
}
