import 'package:flutter/material.dart';
import 'package:furnitureapp/widgets/CheckOutAddress.dart';
import 'package:furnitureapp/widgets/CheckOutAppBar.dart';
import 'package:furnitureapp/widgets/CheckOutBottomNavBar.dart';
import 'package:furnitureapp/widgets/CheckOutItemSamples.dart';
import 'package:furnitureapp/widgets/CheckOutOrder.dart';
import 'package:furnitureapp/widgets/CheckOutPay.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  // Thêm biến để lưu phương thức thanh toán đã chọn
  String _selectedMethod = "Payment Upon Receipt"; // Giá trị mặc định

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CheckOutAppBar(),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFEDECF2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: ListView(
                    padding: EdgeInsets.only(top: 15),
                    children: [
                      CheckOutItemSamples(),
                      CheckOutAddress(
                        address: "Võ Lê Hữu Thắng",
                        phone: "(+84) 825 362 835",
                        fullAddress:
                            "Tổ 2, Bình Trúc\nXã Bình Sa, Huyện Thăng Bình, Quảng Nam",
                      ),
                      CheckOutOrder(
                        productTotal: 150,
                        transportFee: 10,
                      ),                    
                      CheckOutPay(
                        selectedMethod: _selectedMethod,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedMethod = newValue ?? _selectedMethod;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CheckOutBottomNavBar(),
    );
  }
}