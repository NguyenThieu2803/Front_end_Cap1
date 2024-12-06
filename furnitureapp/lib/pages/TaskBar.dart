import 'package:flutter/material.dart';
import 'package:furnitureapp/model/Categories.dart';
import 'package:furnitureapp/services/data_service.dart';

class TaskBar extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String?, double?, double?) onFiltersApplied;

  const TaskBar({
    super.key,
    required this.onClose,
    required this.onFiltersApplied,
  });

  @override
  _TaskBarState createState() => _TaskBarState();
}

class _TaskBarState extends State<TaskBar> {
  final _formKey = GlobalKey<FormState>();
  String? selectedCategory;
  List<Categories> categories = [];
  final minPriceController = TextEditingController();
  final maxPriceController = TextEditingController();
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final dataService = DataService();
      final loadedCategories = await dataService.loadCategories();
      setState(() {
        categories = loadedCategories;
        selectedCategory = categories.isNotEmpty ? categories[0].name : null;
      });
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  @override
  void dispose() {
    minPriceController.dispose();
    maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: widget.onClose,
        child: Container(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(maxHeight: 500),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                decoration: BoxDecoration(
                  color: Color(0xFF1C1C1C),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSectionTitle('Product'),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.white),
                              onPressed: widget.onClose,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        _buildProductRow(),
                        SizedBox(height: 20),
                        _buildSectionTitle('Price range'),
                        SizedBox(height: 20),
                        _buildPriceRangeRow(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildProductRow() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isDropdownOpen = !_isDropdownOpen;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: _isDropdownOpen
                  ? BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    )
                  : BorderRadius.circular(25),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedCategory ?? 'Select Category',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                Icon(
                  _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
        if (_isDropdownOpen) _buildDropdownMenu(),
      ],
    );
  }

  Widget _buildDropdownMenu() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: categories.map((category) => _buildDropdownItem(category.name ?? '')).toList(),
      ),
    );
  }

  Widget _buildDropdownItem(String product) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = product;
          _isDropdownOpen = false;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: selectedCategory == product ? Colors.grey[300] : Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              product,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRangeRow() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            controller: minPriceController,
            hintText: 'Min...',
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: _buildTextField(
            controller: maxPriceController,
            hintText: 'Max...',
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: 15),
        _buildCheckButton(),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 15),
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          if (double.parse(value) < 0) {
            return 'Price cannot be negative';
          }
        }
        return null;
      },
    );
  }

  Widget _buildCheckButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          double? minPrice = minPriceController.text.isEmpty 
              ? null 
              : double.tryParse(minPriceController.text);
          double? maxPrice = maxPriceController.text.isEmpty 
              ? null 
              : double.tryParse(maxPriceController.text);

          if (minPrice != null && maxPrice != null && minPrice > maxPrice) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Min price cannot be greater than max price')),
            );
            return;
          }

          widget.onFiltersApplied(selectedCategory, minPrice, maxPrice);
          widget.onClose();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Text(
        'Apply Filters',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
