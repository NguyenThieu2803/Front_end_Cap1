import 'package:flutter/material.dart';
import 'package:furnitureapp/services/data_service.dart';
import '../model/product.dart';
import '../model/Review.dart';
import '../pages/ProductPage.dart';

class HomeItemsWidget extends StatefulWidget {
  final String selectedCategory;
  final double? minPrice;
  final double? maxPrice;

  const HomeItemsWidget({
    super.key,
    required this.selectedCategory,
    this.minPrice,
    this.maxPrice,
  });

  @override
  _HomeItemsWidgetState createState() => _HomeItemsWidgetState();
}

class _HomeItemsWidgetState extends State<HomeItemsWidget> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void didUpdateWidget(HomeItemsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory ||
        oldWidget.minPrice != widget.minPrice ||
        oldWidget.maxPrice != widget.maxPrice) {
      _loadProducts();
    }
  }

  void _loadProducts() {
    final dataService = DataService();
    _productsFuture = dataService.loadProducts(
      category: widget.selectedCategory,
      minPrice: widget.minPrice,
      maxPrice: widget.maxPrice,
    );
  }

  List<Review> getReviewsForProducts(List<Product> products) {
    return products.map((product) {
      return Review(
        id: product.id,
        rating: (product.rating ?? 0).toInt(),
        comment: "This is a review for ${product.name}",
        reviewDate: DateTime.now().toString(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          child: Text(
            widget.selectedCategory == "All Product"
                ? "All Products"
                : "Products in ${widget.selectedCategory}",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B2321),
            ),
          ),
        ),
        FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'No products found in this category',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            } else {
              final products = snapshot.data!;
              List<Review> reviews = getReviewsForProducts(products);
              return GridView.count(
                childAspectRatio: 0.78,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10),
                children: List.generate(products.length, (index) {
                  return ProductTile(
                    product: products[index],
                    review: reviews[index],
                  );
                }),
              );
            }
          },
        ),
      ],
    );
  }
}

class ProductTile extends StatefulWidget {
  final Product product;
  final Review review;

  const ProductTile({super.key, required this.product, required this.review});

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  bool isFavorite = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10,),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
              if ((widget.product.discount ?? 0) > 0)
                Container(
                  width: 40,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "${widget.product.discount}%",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              Spacer(), // Thêm Spacer để đẩy icon về bên phải
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 30,
                  color: Colors.red,
                ),
                onPressed: toggleFavorite,
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPage(
                      product: widget.product, review: widget.review),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(5),
              alignment: Alignment.center, // Căn giữa hình ảnh trong Container
              height: 100, // Chiều cao của container (sửa tùy ý)
              width: 160, // Chiều rộng của container (sửa tùy ý)
              child: Image.network(
                widget.product.images?.isNotEmpty == true
                    ? widget.product.images!.first
                    : 'https://example.com/default_image.png',
                fit: BoxFit
                    .cover, // Điều chỉnh cách hình ảnh vừa vặn trong Container
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 2, vertical: 3), // Thêm khoảng cách 2 bên
            alignment: Alignment.centerLeft,
            child: Text(
              widget.product.name ?? 'Unknown Product',
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
            padding: EdgeInsets.only(top: 5, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${widget.product.price?.toStringAsFixed(0) ?? 'N/A'}",
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
                          widget.product.rating?.toStringAsFixed(1) ?? '0.0',
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
                  "${widget.product.sold ?? 0} sold",
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
