import 'product.dart';

class Wishlist {
  String? id;
  String? userId;
  List<WishlistItem> product;
  int? v;


  Wishlist({
    this.id,
    this.userId,
    required this.product,
    this.v,
  });

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
      id: json['_id'] as String?,
      userId: json['user_id'] as String?,
      product: (json['product'] as List<dynamic>?)
              ?.map((e) => WishlistItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      v: json['__v'] as int?,

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['user_id'] = userId;
    data['product'] = product.map((v) => v.toJson()).toList();
    data['__v'] = v;
    return data;
  }
}


class WishlistItem {
  Product? product;
  String? id;


  WishlistItem({this.product, this.id});

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
      id: json['_id'] as String?,
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['_id'] = this.id;
    return data;
  }
}

