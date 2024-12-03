class Product {
  String? _id; // Add the id field
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
  String? _model3d;
  String? _modelFormat; // Thêm field để lưu định dạng file (.glb, .gltf)
  Map<String, dynamic>? _modelConfig; // Thêm field để lưu cấu hình model (optional)
  
  

   Product({
    String? id,
    String? name,
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
    double? rating,
    String? model3d,
    String? modelFormat,
    Map<String, dynamic>? modelConfig,
  }) {
    if (id != null) _id = id;
    if (name != null) _name = name;
    if (description != null) _description = description;
    if (shortDescription != null) _shortDescription = shortDescription;
    if (price != null) _price = price;
    if (dimensions != null) _dimensions = dimensions;
    if (stockQuantity != null) _stockQuantity = stockQuantity;
    if (material != null) _material = material;
    if (color != null) _color = color;
    if (images != null) _images = images;
    if (category != null) _category = category;
    if (discount != null) _discount = discount;
    if (promotionId != null) _promotionId = promotionId;
    if (brand != null) _brand = brand;
    if (style != null) _style = style;
    if (assemblyRequired != null) _assemblyRequired = assemblyRequired;
    if (weight != null) _weight = weight;
    if (sold != null) _sold = sold;
    if (rating != null) _rating = rating;
    if (model3d != null) _model3d = model3d;
    if (modelFormat != null) _modelFormat = modelFormat;
    if (modelConfig != null) _modelConfig = modelConfig;
  }

  String? get id => _id; // Add getter for id
  set id(String? id) => _id = id; // Add setter for id
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
  String? get model3d => _model3d;
  set model3d(String? value) => _model3d = value;
  String? get modelFormat => _modelFormat;
  set modelFormat(String? value) => _modelFormat = value;

   Map<String, dynamic>? get modelConfig => _modelConfig;
  set modelConfig(Map<String, dynamic>? value) => _modelConfig = value;

 Product.fromJson(Map<String, dynamic> json) {
    _id = json['_id']?.toString(); // Convert to String if needed
    _name = json['name'];
    _description = json['description'];
    _shortDescription = json['shortDescription'];
    _price = (json['price'] is String)
        ? double.tryParse(json['price'])
        : (json['price'] is int)
            ? (json['price'] as int).toDouble()
            : json['price']?.toDouble();
    _dimensions = json['dimensions'] != null
        ? Dimensions.fromJson(json['dimensions'])
        : null;
    _stockQuantity = (json['stockQuantity'] is String)
        ? int.tryParse(json['stockQuantity'])
        : json['stockQuantity'];
    _material = json['material'];
    _color = json['color'] != null ? ProductColor.fromJson(json['color']) : null;
    _images = json['images'] != null ? List<String>.from(json['images']) : [];
    _category = json['category'];
    _discount = (json['discount'] is String)
        ? int.tryParse(json['discount'])
        : json['discount'];
    _promotionId = json['promotionId'];
    _brand = json['brand'];
    _style = json['style'];
    _assemblyRequired = json['assemblyRequired'];
    _weight = (json['weight'] is String)
        ? int.tryParse(json['weight'])
        : json['weight'];
    _sold = (json['sold'] is String)
        ? int.tryParse(json['sold'])
        : json['sold'];
    _rating = (json['rating'] is String)
        ? double.tryParse(json['rating'])
        : (json['rating'] is int)
            ? (json['rating'] as int).toDouble()
            : json['rating']?.toDouble();
    // Handle model3d with type checking
      print('Raw model3d from json: ${json['model3d']}');
  _model3d = json['model3d']?.toString();
  print('Converted model3d: $_model3d');

  if (json['model3d'] != null) {
      final modelUrl = json['model3d'].toString();
      // Kiểm tra URL có hợp lệ không
      if (Uri.tryParse(modelUrl)?.hasAbsolutePath ?? false) {
        _model3d = modelUrl;
      }
    }
        _modelFormat = json['modelFormat']?.toString();
    
    // Xử lý cấu hình model nếu có
    _modelConfig = json['modelConfig'] as Map<String, dynamic>?;
    
    // Log để debug
    print('Loaded model3d URL: $_model3d');
    print('Model format: $_modelFormat');
    print('Model config: $_modelConfig');
  }

   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = _id;
    data['name'] = _name;
    data['description'] = _description;
    data['shortDescription'] = _shortDescription;
    data['price'] = _price;
    if (_dimensions != null) {
      data['dimensions'] = _dimensions!.toJson();
    }
    data['stockQuantity'] = _stockQuantity;
    data['material'] = _material;
    if (_color != null) {
      data['color'] = _color!.toJson();
    }
    data['images'] = _images;
    data['category'] = _category;
    data['discount'] = _discount;
    data['promotionId'] = _promotionId;
    data['brand'] = _brand;
    data['style'] = _style;
    data['assemblyRequired'] = _assemblyRequired;
    data['weight'] = _weight;
    data['sold'] = _sold;
    data['rating'] = _rating;
       if (_model3d != null) data['model3d'] = _model3d;
    if (_modelFormat != null) data['modelFormat'] = _modelFormat;
    if (_modelConfig != null) data['modelConfig'] = _modelConfig;
    return data;
  }

    bool isModel3dReady() {
    return _model3d != null && 
           _model3d!.isNotEmpty && 
           Uri.tryParse(_model3d!)?.hasAbsolutePath == true;
  }

  String? getModelExtension() {
    if (_model3d == null) return null;
    return _model3d!.split('.').last.toLowerCase();
  }

  @override
  String toString() {
    return 'Product{id: $_id, name: $_name, price: $_price, images: $_images, rating: $_rating, sold: $_sold, model3d: $_model3d}';
  }
}

class Dimensions {
  int? _height;
  int? _width;
  int? _depth;
  String? _unit;

  Dimensions({int? height, int? width, int? depth, String? unit}) {
    if (height != null) {
      _height = height;
    }
    if (width != null) {
      _width = width;
    }
    if (depth != null) {
      _depth = depth;
    }
    if (unit != null) {
      _unit = unit;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['height'] = _height;
    data['width'] = _width;
    data['depth'] = _depth;
    data['unit'] = _unit;
    return data;
  }
}

class ProductColor {
  String? _primary;
  String? _secondary;

  ProductColor({String? primary, String? secondary}) {
    if (primary != null) {
      _primary = primary;
    }
    if (secondary != null) {
      _secondary = secondary;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['primary'] = _primary;
    data['secondary'] = _secondary;
    return data;
  }
}