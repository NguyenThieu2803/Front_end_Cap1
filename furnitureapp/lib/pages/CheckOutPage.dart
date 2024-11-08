import 'package:flutter/material.dart';
import 'package:furnitureapp/api/api.service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:furnitureapp/model/card_model.dart';
import 'package:furnitureapp/model/address_model.dart';
import 'package:furnitureapp/model/Cart_User_Model.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

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

  @override
  void initState() {
    super.initState();
    Stripe.publishableKey = "pk_test_51Q4IszJ48Cc6e6PCngveNBvfhkg9qO12qhW65Au0spXnyY59DGhbfLf2WgpVV7Yg6bKJivrIZBYmtezg24kEh7L700mAjoAcEK";
    Stripe.instance.applySettings();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final addressesData = await APIService.getAllAddresses();
      final addresses = addressesData.map((addressData) => AddressUser.fromJson(addressData)).toList();
      _defaultAddress = addresses.firstWhere((address) => address.isDefault, orElse: () => addresses.first);
      
      final cartData = await APIService.getCart();
      _cart = Cart.fromJson(cartData);
      
      final cardsData = await APIService.getAllCards();
      _cards = cardsData.map((cardData) => CardModel.fromJson(cardData)).toList();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
    }
  }

  Future<String?> generateStripeToken() async {
    var month = _cardExpMonthController.text.trim();
    var year = _cardExpYearController.text.trim();

    CardTokenParams cardParams = CardTokenParams(
      type: TokenType.Card,
      name: _cardHolderNameController.text,
    );

    await Stripe.instance.dangerouslyUpdateCardDetails(CardDetails(
      number: _cardNumberController.text,
      cvc: _cardCVCController.text,
      expirationMonth: int.tryParse(month),
      expirationYear: int.tryParse("20$year"),
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
    final cardToken = await generateStripeToken();
    if (cardToken == null) return;

    try {
      Map<String, dynamic> checkoutData = {
        'paymentMethod': _selectedPaymentMethod,
        'addressId': _defaultAddress?.id,
        'cardToken': cardToken, // Use the token instead of raw card details
      };

      final result = await APIService.checkout(checkoutData);

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thanh toán thành công'),
            content: Text('Đơn hàng của quý khách đã thanh toán thành công. MISA sẽ sớm liên hệ với quý khách sớm để bàn giao sản phẩm, dịch vụ.'),
            actions: <Widget>[
              TextButton(
                child: Text('Đóng'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pushReplacementNamed('/home'); // Navigate to home
                },
              ),
            ],
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
      appBar: AppBar(title: Text('Checkout')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
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
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, -3),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: _buildTotalAndBuyButton(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCartItems() {
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
          ..._cart!.items!.map((item) => _buildCartItem(item)),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Image.network(
            item.product?.images?.first ?? '',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                if (item.product?.description != null)
                  Text(
                    item.product!.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quantity: ${item.quantity}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '\$${(item.price ?? 0) * (item.quantity ?? 1)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (_defaultAddress != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_defaultAddress!.fullName),
                Text(_defaultAddress!.phoneNumber),
                Text(_defaultAddress!.streetAddress),
                Text('${_defaultAddress!.ward}, ${_defaultAddress!.district}, ${_defaultAddress!.province}'),
              ],
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
          Text('Payment method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          RadioListTile(
            title: Text('Payment Upon Receipt'),
            value: 'Payment Upon Receipt',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) => setState(() => _selectedPaymentMethod = value.toString()),
          ),
          RadioListTile(
            title: Text('Credit Card'),
            value: 'Credit Card',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) => setState(() => _selectedPaymentMethod = value.toString()),
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
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:', 
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold
                )
              ),
              Text(
                '\$${(_cart?.cartTotal ?? 0) + 10}', 
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                )
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _processCheckout,
            child: Text(
              'BUY', 
              style: TextStyle(
                fontSize: 18, 
                color: Colors.white
              )
            ), // Call _processCheckout
          ),
        ],
      ),
    );
  }
}
