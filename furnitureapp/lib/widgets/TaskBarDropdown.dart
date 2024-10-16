import 'package:flutter/material.dart';

class TaskBarDropdown extends StatefulWidget {
  @override
  _TaskBarDropdownState createState() => _TaskBarDropdownState();
}

class _TaskBarDropdownState extends State<TaskBarDropdown> {
  String? selectedProduct;
  bool isDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dropdown Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Đóng dropdown nếu đang mở
                if (isDropdownOpen) {
                  setState(() {
                    isDropdownOpen = false;
                  });
                }
              },
              child: DropdownButton<String>(
                hint: Text("Select Product"),
                value: selectedProduct,
                isExpanded: true,
                isDense: true,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedProduct = newValue;
                    isDropdownOpen = false; // Đánh dấu dropdown đã đóng
                  });
                },
                onTap: () {
                  // Đánh dấu dropdown đang mở
                  setState(() {
                    isDropdownOpen = true;
                  });
                },
                items: <String>['Table', 'Chair', 'Sofa']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TaskBarDropdown(),
  ));
}
