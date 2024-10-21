class Product {
  String? id;
  String? name;
  String? description;
  String? shortDescription;
  double? price;
  Dimensions? dimensions;
  int? stockQuantity;
  String? material;
  Map<String, String>? color;
  List<String>? images;
  String? category;
  int? discount;
  String? promotionId;
  String? brand;
  String? style;
  bool? assemblyRequired;
  int? weight;
  int? sold;
  double? rating;

  Product({
    this.id,
    this.name,
    this.description,
    this.shortDescription,
    this.price,
    this.dimensions,
    this.stockQuantity,
    this.material,
    this.color,
    this.images,
    this.category,
    this.discount = 0,
    this.promotionId,
    this.brand,
    this.style,
    this.assemblyRequired,
    this.weight,
    this.sold,
    this.rating,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['_id']?['\$oid'] ?? json['id'];
    name = json['name'];
    description = json['description'];
    shortDescription = json['shortDescription'];
    price = json['price']?.toDouble();
    dimensions = json['dimensions'] != null
        ? Dimensions.fromJson(json['dimensions'])
        : null;
    stockQuantity = json['stockQuantity'] is String
        ? int.tryParse(json['stockQuantity'])
        : json['stockQuantity'];
    material = json['material'];
    color = json['color'] != null ? Map<String, String>.from(json['color']) : null;
    images = json['images'] != null ? List<String>.from(json['images']) : [];
    category = json['category'];
    discount = json['discount'] ?? 0;
    promotionId = json['promotionId'];
    brand = json['brand'];
    style = json['style'];
    assemblyRequired = json['assemblyRequired'];
    weight = json['weight'] is String
        ? int.tryParse(json['weight'])
        : json['weight'];
    sold = json['sold'] is String
        ? int.tryParse(json['sold'])
        : json['sold'];
    rating = json['rating']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['shortDescription'] = shortDescription;
    data['price'] = price;
    if (dimensions != null) {
      data['dimensions'] = dimensions!.toJson();
    }
    data['stockQuantity'] = stockQuantity;
    data['material'] = material;
    data['color'] = color;
    data['images'] = images;
    data['category'] = category;
    data['discount'] = discount;
    data['promotionId'] = promotionId;
    data['brand'] = brand;
    data['style'] = style;
    data['assemblyRequired'] = assemblyRequired;
    data['weight'] = weight;
    data['sold'] = sold;
    data['rating'] = rating;
    return data;
  }
}

class Dimensions {
  int? height;
  int? width;
  int? depth;
  String? unit;

  Dimensions({this.height, this.width, this.depth, this.unit});

  Dimensions.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    width = json['width'];
    depth = json['depth'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['height'] = height;
    data['width'] = width;
    data['depth'] = depth;
    data['unit'] = unit;
    return data;
  }
}
