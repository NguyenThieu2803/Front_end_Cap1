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
  String category;

  Product({
    required this.name,
    required this.image,
    required this.price,
    required this.discount,
    required this.size,
    required this.material,
    required this.features,
    required this.category,
  });
}

class HomeItemsWidget extends StatelessWidget {
  final String selectedCategory;

  HomeItemsWidget({super.key, required this.selectedCategory});

  final List<Product> products = [
    Product(
      name: "Study desk BGC62",
      image: "assets/images/1.png",
      price: 100.0,
      discount: "-50%",
      size: "120cm x 60cm x 75cm",
      material: "Wood & Metal",
      features: "Adjustable height, Built-in storage",
      category: "Desk",
    ),
    Product(
      name: "Office Chair A12",
      image: "assets/images/2.png",
      price: 150.0,
      discount: "-20%",
      size: "45cm - 55cm (height adjustable)",
      material: "Leather & Foam",
      features: "Reclining, Swivel base, Lumbar support",
      category: "Chair",
    ),
    Product(
      name: "Bookshelf X34",
      image: "assets/images/3.png",
      price: 80.0,
      discount: "-30%",
      size: "180cm x 60cm x 30cm",
      material: "Pine Wood",
      features: "6 Shelves, Easy assembly",
      category: "Cabinet",
    ),
    Product(
      name: 'Ghế Công Thái Học',
      image: 'assets/images/ghe_cong_thai_hoc.png',
      price: 100.0,
      discount: '10%',
      size: 'Chiều cao: 45 - 55 cm, Chiều rộng: 45 - 55 cm, Chiều sâu: 40 - 50 cm',
      material: 'Khung ghế: Thép không gỉ, Đệm: Mút xốp đàn hồi, Bề mặt: Vải lưới thoáng khí',
      features: '+ Điều chỉnh chiều cao ghế: Có piston thủy lực\n'
          '+ Điều chỉnh độ nghiêng lưng ghế: Có cơ chế ngả lưng lên đến 180°\n'
          '+ Tay vịn 3D hoặc 4D\n'
          '+ Tựa đầu điều chỉnh\n'
          '+ Xoay 360°',
      category: "Chair",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProducts = selectedCategory == 'All Product'
        ? products
        : products.where((product) => product.category == selectedCategory).toList();

    return GridView.count(
      childAspectRatio: 0.85,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 10),
      children: [
        for (var product in filteredProducts)
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                    margin: EdgeInsets.all(5),
                    child: Image.asset(
                      product.image,
                      height: 110,
                      width: 110,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2B2321),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
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