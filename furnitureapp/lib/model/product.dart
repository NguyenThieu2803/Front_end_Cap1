class Product {
  String? _name;
  String? _description;
  String? _shortDescription;
  double? _price;
  Dimensions? _dimensions;
  int? _stockQuantity;
  String? _material;
  ProductColor? _color;
  List<String>? _images;
  String? _category;
  int? _discount;
  String? _promotionId;
  String? _brand;
  String? _style;
  bool? _assemblyRequired;
  int? _weight;
  int? _sold;
  double? _rating;

  Product(
      {String? name,
      String? description,
      String? shortDescription,
      double? price,
      Dimensions? dimensions,
      int? stockQuantity,
      String? material,
      ProductColor? color,
      List<String>? images,
      String? category,
      int? discount,
      String? promotionId,
      String? brand,
      String? style,
      bool? assemblyRequired,
      int? weight,
      int? sold,
      double? rating}) {
    if (name != null) {
      this._name = name;
    }
    if (description != null) {
      this._description = description;
    }
    if (shortDescription != null) {
      this._shortDescription = shortDescription;
    }
    if (price != null) {
      this._price = price;
    }
    if (dimensions != null) {
      this._dimensions = dimensions;
    }
    if (stockQuantity != null) {
      this._stockQuantity = stockQuantity;
    }
    if (material != null) {
      this._material = material;
    }
    if (color != null) {
      this._color = color;
    }
    if (images != null) {
      this._images = images;
    }
    if (category != null) {
      this._category = category;
    }
    if (discount != null) {
      this._discount = discount;
    }
    if (promotionId != null) {
      this._promotionId = promotionId;
    }
    if (brand != null) {
      this._brand = brand;
    }
    if (style != null) {
      this._style = style;
    }
    if (assemblyRequired != null) {
      this._assemblyRequired = assemblyRequired;
    }
    if (weight != null) {
      this._weight = weight;
    }
    if (sold != null) {
      this._sold = sold;
    }
    if (rating != null) {
      this._rating = rating;
    }
  }

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
  ProductColor? get color => _color;
  set color(ProductColor? color) => _color = color;
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
  int? get sold => _sold;
  set sold(int? sold) => _sold = sold;
  double? get rating => _rating;
  set rating(double? rating) => _rating = rating;

  Product.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _description = json['description'];
    _shortDescription = json['shortDescription'];
    _price = json['price'];
    _dimensions = json['dimensions'] != null
        ? new Dimensions.fromJson(json['dimensions'])
        : null;
    _stockQuantity = json['stockQuantity'];
    _material = json['material'];
    _color = json['color'] != null ? new ProductColor.fromJson(json['color']) : null;
    _images = json['images'].cast<String>();
    _category = json['category'];
    _discount = json['discount'];
    _promotionId = json['promotionId'];
    _brand = json['brand'];
    _style = json['style'];
    _assemblyRequired = json['assemblyRequired'];
    _weight = json['weight'];
    _sold = json['sold'];
    _rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['description'] = this._description;
    data['shortDescription'] = this._shortDescription;
    data['price'] = this._price;
    if (this._dimensions != null) {
      data['dimensions'] = this._dimensions!.toJson();
    }
    data['stockQuantity'] = this._stockQuantity;
    data['material'] = this._material;
    if (this._color != null) {
      data['color'] = this._color!.toJson();
    }
    data['images'] = this._images;
    data['category'] = this._category;
    data['discount'] = this._discount;
    data['promotionId'] = this._promotionId;
    data['brand'] = this._brand;
    data['style'] = this._style;
    data['assemblyRequired'] = this._assemblyRequired;
    data['weight'] = this._weight;
    data['sold'] = this._sold;
    data['rating'] = this._rating;
    return data;
  }
}

class Dimensions {
  int? _height;
  int? _width;
  int? _depth;
  String? _unit;

  Dimensions({int? height, int? width, int? depth, String? unit}) {
    if (height != null) {
      this._height = height;
    }
    if (width != null) {
      this._width = width;
    }
    if (depth != null) {
      this._depth = depth;
    }
    if (unit != null) {
      this._unit = unit;
    }
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this._height;
    data['width'] = this._width;
    data['depth'] = this._depth;
    data['unit'] = this._unit;
    return data;
  }
}

class ProductColor {
  String? _primary;
  String? _secondary;

  ProductColor({String? primary, String? secondary}) {
    if (primary != null) {
      this._primary = primary;
    }
    if (secondary != null) {
      this._secondary = secondary;
    }
  }

  String? get primary => _primary;
  set primary(String? primary) => _primary = primary;
  String? get secondary => _secondary;
  set secondary(String? secondary) => _secondary = secondary;

  ProductColor.fromJson(Map<String, dynamic> json) {
    _primary = json['primary'];
    _secondary = json['secondary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['primary'] = this._primary;
    data['secondary'] = this._secondary;
    return data;
  }
}