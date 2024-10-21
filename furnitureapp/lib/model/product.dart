class Product {
  String? id;
  String? name;
  String? description;
  String? shortDescription;
  double? price;
  Dimensions? dimensions;
  int? stockQuantity;
  String? material;
  String? color;
  List<String>? images;
  String? category;
  int? discount;
  String? promotionId;
  String? brand;
  String? style;
  bool? assemblyRequired;
  int? weight;

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
    this.discount = 0,  // Mặc định discount là 0 nếu không có giá trị
    this.promotionId,
    this.brand,
    this.style,
    this.assemblyRequired,
    this.weight,
  });

  // Phân tích JSON để tạo Product
  Product.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];  // Linh hoạt với cả _id và id
    name = json['name'];
    description = json['description'];
    shortDescription = json['shortDescription'];
    price = json['price']?.toDouble();
    dimensions = json['dimensions'] != null
        ? Dimensions.fromJson(json['dimensions'])
        : null;
    stockQuantity = json['stockQuantity'];
    material = json['material'];
    color = json['color'];
    images = json['images'] != null ? List<String>.from(json['images']) : [];
    category = json['category'];
    
    // Xử lý discount, đảm bảo kiểu int
    if (json['discount'] is String) {
      discount = int.tryParse(json['discount']) ?? 0;
    } else {
      discount = json['discount'] ?? 0;
    }
    
    promotionId = json['promotionId'];
    brand = json['brand'];
    style = json['style'];
    assemblyRequired = json['assemblyRequired'];
    weight = json['weight'];
  }

  // Chuyển Product thành JSON
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
    return data;
  }
}

class Dimensions {
  int? height;
  int? width;
  int? depth;
  String? unit;

  Dimensions({this.height, this.width, this.depth, this.unit});

  // Phân tích JSON để tạo Dimensions
  Dimensions.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    width = json['width'];
    depth = json['depth'];
    unit = json['unit'];
  }

  // Chuyển Dimensions thành JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['height'] = height;
    data['width'] = width;
    data['depth'] = depth;
    data['unit'] = unit;
    return data;
  }
}
