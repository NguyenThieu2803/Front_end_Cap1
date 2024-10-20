class Product {
  Id? _iId;
  String? _name;
  String? _description;
  String? _shortDescription;
  double? _price;
  Dimensions? _dimensions;
  int? _stockQuantity;
  String? _material;
  String? _color;
  List<String>? _images;
  String? _category;
  int? _discount;
  String? _promotionId;  // Đã thay Null? thành String?
  String? _brand;
  String? _style;
  bool? _assemblyRequired;
  int? _weight;

  Product(
      {Id? iId,
      String? name,
      String? description,
      String? shortDescription,
      double? price,
      Dimensions? dimensions,
      int? stockQuantity,
      String? material,
      String? color,
      List<String>? images,
      String? category,
      int? discount,
      String? promotionId,  // Đã thay Null? thành String?
      String? brand,
      String? style,
      bool? assemblyRequired,
      int? weight}) {
    _iId = iId;
    _name = name;
    _description = description;
    _shortDescription = shortDescription;
    _price = price;
    _dimensions = dimensions;
    _stockQuantity = stockQuantity;
    _material = material;
    _color = color;
    _images = images;
    _category = category;
    _discount = discount;
    _promotionId = promotionId;
    _brand = brand;
    _style = style;
    _assemblyRequired = assemblyRequired;
    _weight = weight;
  }

  Id? get iId => _iId;
  set iId(Id? iId) => _iId = iId;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get description => _description;
  set description(String? description) => _description = description;
  String? get shortDescription => _shortDescription;
  set shortDescription(String? shortDescription) =>
      _shortDescription = shortDescription;
  double? get price => _price;
  set price(double? price) => _price = price;
  Dimensions? get dimensions => _dimensions;
  set dimensions(Dimensions? dimensions) => _dimensions = dimensions;
  int? get stockQuantity => _stockQuantity;
  set stockQuantity(int? stockQuantity) => _stockQuantity = stockQuantity;
  String? get material => _material;
  set material(String? material) => _material = material;
  String? get color => _color;
  set color(String? color) => _color = color;
  List<String>? get images => _images;
  set images(List<String>? images) => _images = images;
  String? get category => _category;
  set category(String? category) => _category = category;
  int? get discount => _discount;
  set discount(int? discount) => _discount = discount;
  String? get promotionId => _promotionId;
  set promotionId(String? promotionId) => _promotionId = promotionId;
  String? get brand => _brand;
  set brand(String? brand) => _brand = brand;
  String? get style => _style;
  set style(String? style) => _style = style;
  bool? get assemblyRequired => _assemblyRequired;
  set assemblyRequired(bool? assemblyRequired) =>
      _assemblyRequired = assemblyRequired;
  int? get weight => _weight;
  set weight(int? weight) => _weight = weight;

  Product.fromJson(Map<String, dynamic> json) {
    _iId = json['_id'] != null ? Id.fromJson(json['_id']) : null;
    _name = json['name'];
    _description = json['description'];
    _shortDescription = json['shortDescription'];
    _price = json['price']?.toDouble(); // Đảm bảo luôn là double
    _dimensions = json['dimensions'] != null
        ? Dimensions.fromJson(json['dimensions'])
        : null;
    _stockQuantity = json['stockQuantity'];
    _material = json['material'];
    _color = json['color'];
    _images = json['images'] != null ? List<String>.from(json['images']) : null;
    _category = json['category'];
    
    // Xử lý discount, nếu là chuỗi thì chuyển sang int
    if (json['discount'] is String) {
      _discount = int.tryParse(json['discount']) ?? 0;
    } else {
      _discount = json['discount'] ?? 0;
    }
    
    _promotionId = json['promotionId'];
    _brand = json['brand'];
    _style = json['style'];
    _assemblyRequired = json['assemblyRequired'];
    _weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_iId != null) {
      data['_id'] = _iId!.toJson();
    }
    data['name'] = _name;
    data['description'] = _description;
    data['shortDescription'] = _shortDescription;
    data['price'] = _price;
    if (_dimensions != null) {
      data['dimensions'] = _dimensions!.toJson();
    }
    data['stockQuantity'] = _stockQuantity;
    data['material'] = _material;
    data['color'] = _color;
    data['images'] = _images;
    data['category'] = _category;
    data['discount'] = _discount;
    data['promotionId'] = _promotionId;
    data['brand'] = _brand;
    data['style'] = _style;
    data['assemblyRequired'] = _assemblyRequired;
    data['weight'] = _weight;
    return data;
  }
}

class Id {
  String? _oid;

  Id({String? oid}) {
    _oid = oid;
  }

  String? get oid => _oid;
  set oid(String? oid) => _oid = oid;

  Id.fromJson(Map<String, dynamic> json) {
    _oid = json['$oid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['$oid'] = _oid;
    return data;
  }
}

class Dimensions {
  int? _height;
  int? _width;
  int? _depth;
  String? _unit;

  Dimensions({int? height, int? width, int? depth, String? unit}) {
    _height = height;
    _width = width;
    _depth = depth;
    _unit = unit;
  }

  int? get height => _height;
  set height(int? height) => _height = height;
  int? get width => _width;
  set width(int? width) => _width = width;
  int? get depth => _depth;
  set depth(int? depth) => _depth = depth;
  String? get unit => _unit;
  set unit(String? unit) => _unit = unit;

  Dimensions.fromJson(Map<String, dynamic> json) {
    _height = json['height'];
    _width = json['width'];
    _depth = json['depth'];
    _unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['height'] = _height;
    data['width'] = _width;
    data['depth'] = _depth;
    data['unit'] = _unit;
    return data;
  }
}