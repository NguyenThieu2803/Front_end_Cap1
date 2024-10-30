import 'add_bank_card.dart';
import 'add_credit_card.dart';
import '../model/card_model.dart';
import 'package:flutter/material.dart';
import '../services/data_service.dart';

class BankAccountPage extends StatefulWidget {
  const BankAccountPage({Key? key}) : super(key: key);

  @override
  _BankAccountPageState createState() => _BankAccountPageState();
}

class _BankAccountPageState extends State<BankAccountPage> {
  final DataService _dataService = DataService();
  List<CardModel> _cards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    try {
      final cards = await _dataService.loadCards();
      setState(() {
        _cards = cards;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading cards: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bank Account/Card',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Credit/Debit Cards',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            _buildCardSection(context),
            const SizedBox(height: 24),
            const Text(
              'Bank account',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            _buildBankSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_cards.isEmpty)
            ListTile(
              title: Text(
                'No cards added yet',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ..._cards.map((card) => ListTile(
                leading: Container(
                  width: 40,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.blue[400],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      card.cardType ?? 'CARD',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: Text('**** **** **** ${card.lastFourDigits}'),
                subtitle: Text(card.cardHolderName ?? ''),
              )),
          ListTile(
            leading: Container(
              width: 40,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.blue[400],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: Text(
                  'VISA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              '+ Add new cards',
              style: TextStyle(
                color: Colors.red[400],
                fontSize: 14,
              ),
            ),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddCreditCardPage()),
              );
              if (result == true) {
                _loadCards(); // Reload cards if a new card was added
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBankSection(BuildContext context) {
    // Thêm BuildContext context
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            title: Row(
              children: [
                Text(
                  '+ Add a bank account',
                  style: TextStyle(
                    color: Colors.red[400],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddBankCardPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
