import '../model/product.dart';
import 'package:flutter/material.dart';
import '../services/data_service.dart';
import 'package:furnitureapp/pages/ProductPage.dart';

class HomeItemsWidget extends StatefulWidget {
  final String selectedCategory;

  const HomeItemsWidget({super.key, required this.selectedCategory});

  @override
  _HomeItemsWidgetState createState() => _HomeItemsWidgetState();
}

class _HomeItemsWidgetState extends State<HomeItemsWidget> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = DataService().loadProducts(category: widget.selectedCategory);
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
                  "${product.discount ?? 0}%", // Thêm giá trị mặc định cho discount nếu null
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
              product.name ?? 'Unknown Product', // Thêm giá trị mặc định cho name nếu null
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${product.price?.toStringAsFixed(0) ?? 'N/A'}", // Thêm giá trị mặc định cho price nếu null
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B2321),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        SizedBox(width: 2),
                        Text(
                          // product.rating?.toStringAsFixed(1) ?? '0.0', // Hiển thị rating
                          "3.5",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  // "${product.sold ?? 0} sold", // Thêm giá trị mặc định cho sold nếu null
                  "10 sold",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
