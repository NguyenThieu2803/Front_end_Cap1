class Product {
  String name;
  String image;
  double price;
  String discount;
  String size;
  String material;
  String features;
  double rating;     // Thêm trường rating
  int soldCount;     // Thêm trường soldCount

  Product({
    required this.name,
    required this.image,
    required this.price,
    required this.discount,
    required this.size,
    required this.material,
    required this.features,
    this.rating = 0.0,    // Giá trị mặc định
    this.soldCount = 0,   // Giá trị mặc định
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      image: json['image'],
      price: json['price'],
      discount: json['discount'],
      size: json['size'],
      material: json['material'],
      features: json['features'],
      rating: (json['rating'] ?? 0.0).toDouble(),  // Xử lý dữ liệu từ JSON
      soldCount: json['soldCount'] ?? 0,           // Xử lý dữ liệu từ JSON
    );
  }
}