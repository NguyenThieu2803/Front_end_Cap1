import 'package:flutter/material.dart';

class TaskBar extends StatefulWidget {
  final VoidCallback onClose;

  const TaskBar({Key? key, required this.onClose}) : super(key: key);

  @override
  _TaskBarState createState() => _TaskBarState();
}

class _TaskBarState extends State<TaskBar> {
  final _formKey = GlobalKey<FormState>();
  String selectedProduct = 'Table';
  final addressController = TextEditingController();
  final minPriceController = TextEditingController();
  final maxPriceController = TextEditingController();

  @override
  void dispose() {
    addressController.dispose();
    minPriceController.dispose();
    maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Nền của Material trong suốt
      child: Align(
        alignment: Alignment.bottomCenter, // Đặt TaskBar ở đáy màn hình
        child: Container(
          width: double.infinity, // Chiếm toàn bộ chiều ngang
          constraints: BoxConstraints(maxHeight: 500), // Mở rộng chiều cao tối đa của TaskBar (có thể điều chỉnh)
          padding: EdgeInsets.fromLTRB(20, 40, 20, 20), // Tăng padding dưới để có thêm không gian
          decoration: BoxDecoration(
            color: Color(0xFF1C1C1C), // Màu nền đen của TaskBar
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30), // Góc tròn ở trên
              bottomRight: Radius.circular(30), // Góc tròn ở trên
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header của TaskBar chứa tiêu đề và nút đóng
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
                  SizedBox(height: 20), // Tăng khoảng cách giữa các thành phần
                  _buildSectionTitle('Price range'),
                  SizedBox(height: 20),
                  _buildPriceRangeRow(),
                ],
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
    return Row(
      children: [
        Expanded(child: _buildProductDropdown()), // Dropdown field
        SizedBox(width: 15),
        Expanded(child: _buildAddressField()),    // Address field
      ],
    );
  }

  Widget _buildProductDropdown() {
    return Material(
      elevation: 5, // Đảm bảo dropdown được hiển thị ở trên cùng
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: DropdownButtonFormField<String>(
          value: selectedProduct,
          dropdownColor: Colors.white, // Màu dropdown
          icon: Icon(Icons.arrow_drop_down, color: Colors.black), // Mũi tên
          isExpanded: true, // Đảm bảo dropdown chiếm hết chiều ngang
          onChanged: (String? newValue) {
            if (newValue != null) { 
              setState(() => selectedProduct = newValue);
            }
          },
          items: ['Table', 'Chair', 'Sofa', 'Lamp'].map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAddressField() {
    return _buildTextField(
      controller: addressController,
      hintText: 'Address',
    );
  }

  Widget _buildPriceRangeRow() {
    return Row(
      children: [
        Expanded(child: _buildTextField(
          controller: minPriceController,
          hintText: 'vnd',
          keyboardType: TextInputType.number,
        )),
        SizedBox(width: 15),
        Expanded(child: _buildTextField(
          controller: maxPriceController,
          hintText: 'vnd',
          keyboardType: TextInputType.number,
        )),
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
    );
  }

  Widget _buildCheckButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Xử lý khi form hợp lệ
        }
      },
      child: Text(
        'Check',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
