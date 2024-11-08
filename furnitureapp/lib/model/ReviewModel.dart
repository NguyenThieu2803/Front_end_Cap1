class ReviewData {
  final int id;
  final UserData user;
  final ProductData product;

  ReviewData({
    required this.id,
    required this.user,
    required this.product,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      id: json['id'],
      user: UserData.fromJson(json['user']),
      product: ProductData.fromJson(json['product']),
    );
  }
}

class UserData {
  final String username;
  final String? avatar;
  final String reviewDate;

  UserData({
    required this.username,
    this.avatar,
    required this.reviewDate,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      username: json['username'],
      avatar: json['avatar'],
      reviewDate: json['review_date'],
    );
  }
}

class ProductData {
  final String name;
  final ProductSpecs specs;

  ProductData({
    required this.name,
    required this.specs,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      name: json['name'],
      specs: ProductSpecs.fromJson(json['specs']),
    );
  }
}

class ProductSpecs {
  final String material;
  final List<String> colors;
  final String origin;

  ProductSpecs({
    required this.material,
    required this.colors,
    required this.origin,
  });

  factory ProductSpecs.fromJson(Map<String, dynamic> json) {
    return ProductSpecs(
      material: json['material'],
      colors: List<String>.from(json['colors']),
      origin: json['origin'],
    );
  }
}