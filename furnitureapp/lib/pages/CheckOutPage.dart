import 'package:flutter/material.dart';
import 'package:furnitureapp/api/api.service.dart';
import 'package:furnitureapp/model/card_model.dart';
import 'package:furnitureapp/model/address_model.dart';
import 'package:furnitureapp/model/Cart_User_Model.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({Key? key}) : super(key: key);

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  Address? _defaultAddress;
  Cart? _cart;
  List<CardModel> _cards = [];
  String _selectedPaymentMethod = 'Payment Upon Receipt';
  bool _isLoading = true;
  CardModel? _selectedCard;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final addressesData = await APIService.getAllAddresses();
      final addresses = addressesData.map((addressData) => Address.fromJson(addressData)).toList();
      _defaultAddress = addresses.firstWhere((address) => address.isDefault, orElse: () => addresses.first);
      
      final cartData = await APIService.getCart();
      _cart = Cart.fromJson(cartData);
      
      final cardsData = await APIService.getAllCards();
      _cards = cardsData.map((cardData) => CardModel.fromJson(cardData)).toList();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _processCheckout() async {
    try {
      if (_selectedPaymentMethod == 'Credit Card' && _selectedCard != null) {
        final result = await APIService.checkout(_selectedCard!.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Checkout successful: Order ID ${result['order']['_id']}')),
        );
      } else if (_selectedPaymentMethod == 'Payment Upon Receipt') {
        // Handle payment upon receipt
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order placed for payment upon receipt')),
        );
      } else {
        throw Exception('Invalid payment method or no card selected');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checkout failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Out'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_cart != null && _cart!.items != null && _cart!.items!.isNotEmpty)
                    _buildCartItem(_cart!.items!.first),
                  _buildAddressSection(),
                  _buildOrderSummary(),
                  _buildPaymentMethod(),
                  _buildTotalAndBuyButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(item.product?.images?.first ?? '', width: 100, height: 100, fit: BoxFit.cover),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name ?? '', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(item.product?.description ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                Text('\$${item.price}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text('${item.quantity}'),
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

  Widget _buildOrderSummary() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Product'),
              Text('\$${_cart?.cartTotal ?? 0}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Transport'),
              Text('\$10'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('\$${(_cart?.cartTotal ?? 0) + 10}', style: TextStyle(fontWeight: FontWeight.bold)),
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
              child: DropdownButton<CardModel>(
                value: _selectedCard,
                hint: Text('Select a card'),
                isExpanded: true,
                items: _cards.map((CardModel card) {
                  return DropdownMenuItem<CardModel>(
                    value: card,
                    child: Text('**** **** **** ${card.lastFourDigits}'),
                  );
                }).toList(),
                onChanged: (CardModel? newValue) {
                  setState(() {
                    _selectedCard = newValue;
                  });
                },
              ),
            ),
          RadioListTile(
            title: Text('Bank Card'),
            value: 'Bank Card',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) => setState(() => _selectedPaymentMethod = value.toString()),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalAndBuyButton() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('\$${(_cart?.cartTotal ?? 0) + 10}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            child: Text('BUY', style: TextStyle(fontSize: 18, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: _processCheckout,
          ),
        ],
      ),
    );
  }
}
