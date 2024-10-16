import 'package:flutter/material.dart';

class Product {
  String name;
  String image;
  double price;

  Product({
    required this.name,
    required this.image,
    required this.price,
  });
}

class FavoriteItemSamples extends StatefulWidget {
  const FavoriteItemSamples({super.key});

  @override
  _FavoriteItemSamplesState createState() => _FavoriteItemSamplesState();
}

class _FavoriteItemSamplesState extends State<FavoriteItemSamples> {
  // Danh sách các sản phẩm
  List<Product> products = [
    Product(name: "Table A2343B", price: 100, image: "assets/images/1.png"),
    Product(name: "Chair B45", price: 50, image: "assets/images/2.png"),
    Product(name: "Lamp C23", price: 30, image: "assets/images/3.png"),
    Product(name: "Sofa D12", price: 200, image: "assets/images/4.png"),
    Product(name: "Bed E56", price: 300, image: "assets/images/5.png"),
    Product(name: "Desk F78", price: 150, image: "assets/images/6.png"),
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
                  child: Image.asset(products[i].image),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          products[i].name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2B2321),
                          ),
                        ),
                        Text(
                          "\$${products[i].price.toInt() == products[i].price ? products[i].price.toInt() : products[i].price}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2B2321),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          products.removeAt(i);
                        });
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 25), // Khoảng cách giữa 2 icon
                    InkWell(
                      onTap: () {
                        // Thêm navigation logic ở đây
                        // Ví dụ:
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ProductDetailPage(product: products[i]),
                        //   ),
                        // );
                      },
                      child: Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF2B2321),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}