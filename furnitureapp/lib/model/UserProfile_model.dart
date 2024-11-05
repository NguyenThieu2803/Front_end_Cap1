import 'package:flutter/foundation.dart';

class UserProfile {
  final String id;
  final String userName;
  final String email;
  final String phoneNumber;
  final List<String> addresses;
  final List<String> wishlist;
  final List<Purchase> purchaseHistory;
  final String profileImage;

  UserProfile({
    required this.id,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.addresses,
    required this.wishlist,
    required this.purchaseHistory,
    required this.profileImage,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'] as String,
      userName: json['user_name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      addresses: List<String>.from(json['addresses']),
      wishlist: List<String>.from(json['wishlist']),
      purchaseHistory: (json['purchaseHistory'] as List)
          .map((item) => Purchase.fromJson(item))
          .toList(),
      profileImage: json['profileImage'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_name': userName,
      'email': email,
      'phone_number': phoneNumber,
      'addresses': addresses,
      'wishlist': wishlist,
      'purchaseHistory': purchaseHistory.map((item) => item.toJson()).toList(),
      'profileImage': profileImage,
    };
  }
}

class Purchase {
  final String product;
  final DateTime purchaseDate;
  final String id;

  Purchase({
    required this.product,
    required this.purchaseDate,
    required this.id,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      product: json['product'] as String,
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      id: json['_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product,
      'purchaseDate': purchaseDate.toIso8601String(),
      '_id': id,
    };
  }
}
