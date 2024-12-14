import 'package:flutter/material.dart';
import 'package:furnitureapp/api/api.service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:furnitureapp/model/card_model.dart';
import 'package:furnitureapp/model/address_model.dart';
import 'package:furnitureapp/model/Cart_User_Model.dart';

class CheckOutPage extends StatefulWidget {
  final Set<String> selectedProductIds;
  final double totalAmount;

  const CheckOutPage({
    super.key,
    required this.selectedProductIds,
    required this.totalAmount,
  });

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  AddressUser? _defaultAddress;
  Cart? _cart;
  List<CardModel> _cards = [];
  String _selectedPaymentMethod = 'Payment Upon Receipt';
  bool _isLoading = true;
  CardModel? _selectedCard;
  final _cardNumberController = TextEditingController();
  final _cardExpMonthController = TextEditingController();
  final _cardExpYearController = TextEditingController();
  final _cardCVCController = TextEditingController();
  final _cardHolderNameController = TextEditingController();
  final double shippingFee = 30.0;
  double subTotal = 0.0;
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    subTotal = widget.totalAmount;
    total = widget.totalAmount + shippingFee;
    
    Stripe.publishableKey =
        "pk_test_51Q4IszJ48Cc6e6PCngveNBvfhkg9qO12qhW65Au0spXnyY59DGhbfLf2WgpVV7Yg6bKJivrIZBYmtezg24kEh7L700mAjoAcEK";
    Stripe.instance.applySettings();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final addressesData = await APIService.getAllAddresses();
      final addresses = addressesData
          .map((addressData) => AddressUser.fromJson(addressData))
          .toList();
      _defaultAddress = addresses.firstWhere((address) => address.isDefault,
          orElse: () => addresses.first);

      final cartData = await APIService.getCart();
      _cart = Cart.fromJson(cartData);

      // Filter cart items based on selected product IDs
      _cart?.items = _cart?.items
          ?.where(
              (item) => widget.selectedProductIds.contains(item.product?.id))
          .toList();

      final cardsData = await APIService.getAllCards();
      _cards =
          cardsData.map((cardData) => CardModel.fromJson(cardData)).toList();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
    }
  }

  Future<String?> generateStripeToken() async {
    var month = _cardExpMonthController.text.trim();
    var year = _cardExpYearController.text.trim();

    // Ensure month and year are not empty and are valid integers
    if (month.isEmpty || year.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Expiration month and year are required.')),
      );
      return null;
    }

    int? expMonth = int.tryParse(month);
    int? expYear = int.tryParse("20$year");

    // Check if parsing was successful
    if (expMonth == null || expYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid expiration date.')),
      );
      return null;
    }

    CardTokenParams cardParams = CardTokenParams(
      type: TokenType.Card,
      name: _cardHolderNameController.text,
    );

    await Stripe.instance.dangerouslyUpdateCardDetails(CardDetails(
      number: _cardNumberController.text,
      cvc: _cardCVCController.text,
      expirationMonth: expMonth,
      expirationYear: expYear,
    ));

    try {
      TokenData token = await Stripe.instance.createToken(
        CreateTokenParams.card(params: cardParams),
      );
      print("Flutter Stripe token: ${token.toJson()}");
      return token.id;
    } on StripeException catch (e) {
      print("Flutter Stripe error: ${e.error.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create token: ${e.error.message}')),
      );
    } catch (e) {
      print("Unexpected error: $e");
    }
    return null;
  }

  Future<void> _processCheckout() async {
    // Generate card token only if the selected payment method is 'Credit Card'
    String? cardToken;
    if (_selectedPaymentMethod == 'Credit Card') {
      cardToken = await generateStripeToken();
      if (cardToken == null) return; // Exit if token generation failed
    }

    try {
      Map<String, dynamic> checkoutData = {
        'paymentMethod': _selectedPaymentMethod,
        'addressId': _defaultAddress?.id,
        'totalPrices': total,
        if (cardToken != null) 'cardToken': cardToken,
        'products':
            widget.selectedProductIds.map((id) => {'productId': id}).toList(),
      };

      final result = await APIService.checkout(checkoutData);

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(16.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 80.0,
                ),
                SizedBox(height: 20),
                Text(
                  'Thanh toán thành công',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Đơn hàng của quý khách đã thanh toán thành công. '
                  'FurniFit AR sẽ sớm liên hệ với quý khách để bàn giao sản phẩm, dịch vụ.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context)
                        .pushReplacementNamed('/home'); // Navigate to home
                  },
                  child: Text('Đóng'),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checkout failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text(
    'Check Out',
    style: TextStyle(
      fontSize: 23,
      fontWeight: FontWeight.bold,
    ),
  ),
  backgroundColor: Color(0xFFEDECF2),
  leading: IconButton(
    icon: Icon(
      Icons.arrow_back,
      size: 30, // Thêm dòng này để chỉnh kích thước icon
    ),
    onPressed: () {
      Navigator.of(context).pop(); // Quay lại trang trước
    },
  ),
),

      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 50), // Adjust as needed
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAddressSection(),
                        _buildCartItems(),
                        _buildPaymentMethod(),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child:
                      _buildTotalAndBuyButton(), // Moved outside of the Stack
                ),
              ],
            ),
    );
  }

  Widget _buildCartItems() {
    print(_cart);
    if (_cart == null || _cart!.items == null || _cart!.items!.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text('No items in cart'),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Items',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 200, // Adjust height as needed
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _cart!.items!.length,
              itemBuilder: (context, index) {
                final item = _cart!.items![index];
                print(item.toJson()); // Log the item to the console
                return _buildCartItem(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    padding: EdgeInsets.all(16), // Thêm padding để nội dung không quá chật
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15), // Bo góc mềm mại
      border: Border.all(
        color: Colors.grey.withOpacity(0.2), // Viền nhẹ với màu xám
        width: 2.0, // Độ dày của viền
      ),
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12), // Bo góc của hình ảnh
          child: Image.network(
            item.product?.images?.first ?? '',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name ?? 'Unknown Product',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B2321),
                ),
              ),
              SizedBox(height: 4),
              Text(
                '\$${item.price?.toStringAsFixed(2) ?? '0.00'}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600], // Màu xám đậm hơn cho giá
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  Widget _buildQuantityButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Color(0xFF2B2321)),
        onPressed: () {
          // Handle quantity change
        },
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipping to',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B2321),
            ),
          ),
          SizedBox(height: 8),
          if (_defaultAddress != null)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.radio_button_checked,
                    color: const Color(0xFF2B2321),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _defaultAddress!.fullName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2B2321),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          _defaultAddress!.phoneNumber,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          _defaultAddress!.streetAddress,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${_defaultAddress!.ward}, ${_defaultAddress!.district}, ${_defaultAddress!.province}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          RadioListTile(
            title: Text('Payment Upon Receipt'),
            value: 'Payment Upon Receipt',
            groupValue: _selectedPaymentMethod,
            activeColor: Color(0xFF2B2321),
            onChanged: (value) =>
                setState(() => _selectedPaymentMethod = value.toString()),
          ),
          RadioListTile(
            title: Text('Credit Card'),
            value: 'Credit Card',
            groupValue: _selectedPaymentMethod,
            activeColor: Color(0xFF2B2321),
            onChanged: (value) =>
                setState(() => _selectedPaymentMethod = value.toString()),
          ),
          if (_selectedPaymentMethod == 'Credit Card')
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Column(
                children: [
                  TextField(
                    controller: _cardHolderNameController,
                    decoration: InputDecoration(labelText: 'Card Holder Name'),
                  ),
                  TextField(
                    controller: _cardNumberController,
                    decoration: InputDecoration(labelText: 'Card Number'),
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _cardExpMonthController,
                          decoration: InputDecoration(labelText: 'Exp Month'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _cardExpYearController,
                          decoration: InputDecoration(labelText: 'Exp Year'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _cardCVCController,
                    decoration: InputDecoration(labelText: 'CVC'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTotalAndBuyButton() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(20),  // Bo góc trên trái
    topRight: Radius.circular(20), // Bo góc trên phải
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.3),
      blurRadius: 4,
      offset: Offset(0, -3),
    ),
  ],
),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow('Shipping fee', '\$${shippingFee.toStringAsFixed(2)}'),
          SizedBox(height: 8),
          _buildRow('Sub total', '\$${subTotal.toStringAsFixed(2)}'),
          Divider(thickness: 1, color: Colors.grey[300]),
          _buildRow('Total', '\$${total.toStringAsFixed(2)}', isBold: true),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _processCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3E3364),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Payment',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFFFD700),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.9,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: const Color(0xFF2B2321),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: isBold ? const Color(0xFF2B2321) : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
