import 'package:flutter/material.dart';

import '../pages/product.dart';

class Product {
  String name;
  String image;
  double price;
  String discount;
  String size;
  String material;
  String features;

  Product({
    required this.name,
    required this.image,
    required this.price,
    required this.discount,
    required this.size,
    required this.material,
    required this.features,
  });
}

class HomeItemsWidget extends StatefulWidget {
  const HomeItemsWidget({super.key});

  @override
  _HomeItemsWidgetState createState() => _HomeItemsWidgetState();
}

class _HomeItemsWidgetState extends State<HomeItemsWidget> {
  List<Product> products = [
    Product(
      name: "Study desk BGC62",
      image: "assets/images/1.png",
      price: 100.0,
      discount: "-50%",
      size: "120cm x 60cm x 75cm", // Thông tin kích thước
      material: "Wood & Metal", // Chất liệu
      features: "Adjustable height, Built-in storage", // Tính năng
    ),
    Product(
      name: "Office Chair A12",
      image: "assets/images/2.png",
      price: 150.0,
      discount: "-20%",
      size: "45cm - 55cm (height adjustable)", // Thông tin kích thước
      material: "Leather & Foam", // Chất liệu
      features: "Reclining, Swivel base, Lumbar support", // Tính năng
    ),
    Product(
      name: "Bookshelf X34",
      image: "assets/images/3.png",
      price: 80.0,
      discount: "-30%",
      size: "180cm x 60cm x 30cm", // Thông tin kích thước
      material: "Pine Wood", // Chất liệu
      features: "6 Shelves, Easy assembly", // Tính năng
    ),
    Product(
      name: 'Ghế Công',
      image: 'assets/images/ghe_cong_thai_hoc.png',
      price: 100.0,
      discount: '10%',
      size:
          'Chiều cao: 45 - 55 cm, Chiều rộng: 45 - 55 cm, Chiều sâu: 40 - 50 cm',
      material:
          'Khung ghế: Thép không gỉ, Đệm: Mút xốp đàn hồi, Bề mặt: Vải lưới thoáng khí',
      features: '+ Điều chỉnh chiều cao ghế: Có piston thủy lực\n'
          '+ Điều chỉnh độ nghiêng lưng ghế: Có cơ chế ngả lưng lên đến 180°\n'
          '+ Tay vịn 3D hoặc 4D\n'
          '+ Tựa đầu điều chỉnh\n'
          '+ Xoay 360°',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 0.85, // Điều chỉnh tỷ lệ khung hình để phù hợp hơn
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 10), // Thêm padding phía trên
      children: [
        for (var product in products)
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10), // Giảm margin dọc
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xFF2B2321),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        product.discount,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductPage(product: product),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(5), // Giảm margin xung quanh hình ảnh
                    child: Image.asset(
                      product.image,
                      height: 110, // Giảm chiều cao hình ảnh
                      width: 110,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 5), // Giảm khoảng cách dưới tên sản phẩm
                  alignment: Alignment.centerLeft,
                  child: Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16, // Giảm kích thước font chữ
                      color: Color(0xFF2B2321),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5), // Giảm khoảng cách trên giá tiền
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${product.price.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B2321),
                        ),
                      ),
                      Icon(
                        Icons.shopping_cart_checkout,
                        color: Color(0xFF2B2321),
                      )
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