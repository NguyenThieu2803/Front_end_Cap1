import 'package:flutter/material.dart';

class TaskBar extends StatefulWidget {
  final VoidCallback onClose;

  const TaskBar({super.key, required this.onClose});

  @override
  _TaskBarState createState() => _TaskBarState();
}

class _TaskBarState extends State<TaskBar> {
  final _formKey = GlobalKey<FormState>();
  String selectedProduct = 'Table';
  final addressController = TextEditingController();
  final minPriceController = TextEditingController();
  final maxPriceController = TextEditingController();
  bool _isDropdownOpen = false; // Biến boolean để kiểm soát trạng thái menu

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
      color: Colors.transparent,
      child: GestureDetector(
        onTap: widget.onClose,
        child: Container(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {}, // Ngăn chặn sự kiện tap truyền xuống
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
            _isDropdownOpen = !_isDropdownOpen; // Thay đổi trạng thái của menu
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: _isDropdownOpen
                ? BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ) // Khi mở: chỉ bo góc phía trên
                : BorderRadius.circular(25), // Khi đóng: bo góc toàn bộ
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedProduct,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Icon(
                _isDropdownOpen
                    ? Icons.arrow_drop_up // Nếu mở thì hiển thị mũi tên lên
                    : Icons.arrow_drop_down, // Nếu đóng thì hiển thị mũi tên xuống
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
      if (_isDropdownOpen)
        _buildDropdownMenu(), // Hiển thị menu nếu _isDropdownOpen = true
    ],
  );
}


  Widget _buildDropdownMenu() {
    return Column(
      children: [
        _buildDropdownItem('Table'),
        _buildDropdownItem('Chair'),
        _buildDropdownItem('Sofa'),
        _buildDropdownItem('Lamp'),
      ],
    );
  }

  Widget _buildDropdownItem(String product) {
  return GestureDetector(
    onTap: () {
      setState(() {
        selectedProduct = product; // Cập nhật sản phẩm được chọn
        _isDropdownOpen = false;   // Đóng menu sau khi chọn
      });
    },
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: selectedProduct == product ? Colors.grey[300] : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey, // Màu sắc của đường viền dưới
            width: 1.0,        // Độ dày của đường viền dưới
          ),
        ),
        borderRadius: product == 'Lamp'
            ? BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              )
            : BorderRadius.zero, // Không có bo góc cho các mục khác
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
            hintText: 'vnd',
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: _buildTextField(
            controller: maxPriceController,
            hintText: 'vnd',
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
    );
  }

  Widget _buildCheckButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Xử lý khi form hợp lệ
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
        'Check',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
