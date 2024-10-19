import 'package:flutter/material.dart';
import 'package:furnitureapp/pages/product_page.dart';
import '../model/product.dart';
import '../services/data_service.dart';

class HomeItemsWidget extends StatefulWidget {
  // Change from StatelessWidget to StatefulWidget
  final String selectedCategory;

  HomeItemsWidget({super.key, required this.selectedCategory});

  @override
  _HomeItemsWidgetState createState() =>
      _HomeItemsWidgetState(); // Add createState method
}

class _HomeItemsWidgetState extends State<HomeItemsWidget> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = DataService().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: futureProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No products found'));
        } else {
          final products = snapshot.data!;

          return GridView.count(
            childAspectRatio: 0.85,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10),
            children: products
                .map((product) => ProductTile(product: product))
                .toList(),
          );
        }
      },
    );
  }
}

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  "${product.discount}%",
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color.fromARGB(255, 168, 149, 149),
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
              child: Image.network(
                product.images?.isNotEmpty == true
                    ? product.images!.first
                    : 'https://example.com/default_image.png', // URL mặc định nếu không có hình ảnh
                height: 110,
                width: 110,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 5),
            alignment: Alignment.centerLeft,
            child: Text(
              product.name ?? 'Unknown Product',
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
                  "${(product.price ?? 0).toStringAsFixed(0)}",
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
    );
  }
}
