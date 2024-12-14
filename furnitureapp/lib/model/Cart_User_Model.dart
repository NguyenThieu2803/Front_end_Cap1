import 'package:furnitureapp/model/product.dart';
import 'package:furnitureapp/services/ar_service.dart';

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

  // Parse JSON to create a CartItem object
  CartItem.fromJson(Map<String, dynamic> json) {
    // Parse the Product object if it exists
    product = json['product'] != null && json['product'] is Map<String, dynamic> 
        ? Product.fromJson(json['product']) 
        : null;
        
    name = json['name'];
    quantity = json['quantity'];
    
    // Convert price and total to double
    price = json['price']?.toDouble();
    total = json['total']?.toDouble();
    discount = json['discount'];
    
    // Parse the addedAt date if it exists
    addedAt = json['addedAt'] != null ? DateTime.parse(json['addedAt']) : null;
    
    id = json['_id'];
  }

  // Convert CartItem object to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    
    // Convert Product to JSON if it exists
    if (product != null) {
      data['product'] = product!.toJson();
      data['product_id'] = product!.id; // Ensure product ID is included
    }
    
    data['name'] = name;
    data['quantity'] = quantity;
    data['price'] = price;
    data['total'] = total;
    data['discount'] = discount;
    
    // Convert addedAt date to ISO 8601 format
    data['addedAt'] = addedAt?.toIso8601String();
    data['id'] = id;
    
    return data;
  }

  Future<bool> hasValidModel3D() async {
    if (product?.model3d != null && 
           product!.model3d!.isNotEmpty) {
      bool isValid = await ArService.validateModelUrl(product!.model3d!);
      return isValid;
    }
    return false;
  }
}
