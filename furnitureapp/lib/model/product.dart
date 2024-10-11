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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      image: json['image'],
      price: json['price'],
      discount: json['discount'],
      size: json['size'],
      material: json['material'],
      features: json['features'],
    );
  }
}
