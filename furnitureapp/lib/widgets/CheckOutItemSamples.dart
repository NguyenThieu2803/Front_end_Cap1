import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Product {
  String name;
  String image;
  double price;
  int quantity; // Thêm quantity

  Product({
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1, // Khởi tạo quantity với giá trị mặc định là 1
  });
}

class CheckOutItemSamples extends StatefulWidget {
  const CheckOutItemSamples({super.key});

  @override
  _CheckOutItemSamplesState createState() => _CheckOutItemSamplesState();
}

class _CheckOutItemSamplesState extends State<CheckOutItemSamples> {
  // Danh sách các sản phẩm
  List<Product> products = [
    Product(name: "Table A2343B", price: 100, image: "assets/images/1.png"),
    Product(name: "Chair B45", price: 50, image: "assets/images/2.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < products.length; i++)
        Container(
          height: 110,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                height: 70,
                width: 70,
                margin: EdgeInsets.only(right: 15),
                child: Image.asset(products[i].image), // Sử dụng đúng đường dẫn hình ảnh
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      products[i].name, // Tên sản phẩm
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B2321),      
                      ),
                    ),
                    Text(
                      "\$${products[i].price.toInt() == products[i].price ? products[i].price.toInt() : products[i].price}", // Kiểm tra và loại bỏ .0 nếu không cần thiết
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B2321),                              
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Nút tăng số lượng
                        InkWell(
                          onTap: () {
                            setState(() {
                              products[i].quantity++; // Tăng số lượng
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Icon(
                              CupertinoIcons.plus,
                              size: 15,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "${products[i].quantity}", // Hiển thị số lượng
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2B2321),                              
                            ),
                          ),
                        ),
                        // Nút giảm số lượng
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (products[i].quantity > 1) {
                                products[i].quantity--; // Giảm số lượng nhưng không giảm xuống dưới 1
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Icon(
                              CupertinoIcons.minus,
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
