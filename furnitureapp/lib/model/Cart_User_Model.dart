import 'package:furnitureapp/model/product.dart';

class Cart {
  String? id;
  String? userId;
  List<CartItem>? items;
  double? cartTotal;
  int? version;

  Cart({this.id, this.userId, this.items, this.cartTotal, this.version});

  // Phân tích JSON để tạo đối tượng Cart
  Cart.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['user_id'];
    
    // Kiểm tra nếu danh sách product tồn tại và là List
    if (json['product'] != null && json['product'] is List) {
      items = <CartItem>[];
      json['product'].forEach((v) {
        if (v is Map<String, dynamic>) {
          items!.add(CartItem.fromJson(v)); // Parse từng CartItem từ JSON
        }
      });
    }
    
    // Chuyển đổi cartTotal thành double
    cartTotal = json['cartTotal']?.toDouble();
    
    // Version của đối tượng (nếu có)
    version = json['__v'];
  }

  // Chuyển đối tượng Cart thành JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['user_id'] = userId;
    
    // Chuyển items thành List<Map> nếu không null
    if (items != null) {
      data['product'] = items!.map((v) => v.toJson()).toList();
    }
    
    data['cartTotal'] = cartTotal;
    data['__v'] = version;
    
    return data;
  }
}

class CartItem {
  Product? product;
  String? name;
  int? quantity;
  double? price;
  double? total;
  int? discount;
  DateTime? addedAt;
  String? id;

  CartItem({
    this.product,
    this.name,
    this.quantity,
    this.price,
    this.total,
    this.discount,
    this.addedAt,
    this.id,
  });

  // Phân tích JSON để tạo đối tượng CartItem
  CartItem.fromJson(Map<String, dynamic> json) {
    // Kiểm tra và parse đối tượng Product nếu không null
    product = json['product'] != null && json['product'] is Map<String, dynamic> 
        ? Product.fromJson(json['product']) 
        : null;
        
    name = json['name'];
    quantity = json['quantity'];
    
    // Chuyển đổi price và total thành double
    price = json['price']?.toDouble();
    total = json['total']?.toDouble();
    discount = json['discount'];
    
    // Parse ngày addedAt nếu không null
    addedAt = json['addedAt'] != null ? DateTime.parse(json['addedAt']) : null;
    
    id = json['_id'];
  }

  // Chuyển đối tượng CartItem thành JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    
    // Chuyển Product thành JSON nếu không null
    if (product != null) {
      data['product'] = product!.toJson();
    }
    
    data['name'] = name;
    data['quantity'] = quantity;
    data['price'] = price;
    data['total'] = total;
    data['discount'] = discount;
    
    // Chuyển đổi ngày addedAt thành ISO 8601 format
    data['addedAt'] = addedAt?.toIso8601String();
    data['_id'] = id;
    
    return data;
  }
}
