import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/product.dart';


class DataService {
  Future<List<Product>> loadProducts() async {
    String jsonString = await rootBundle.loadString('assets/detail/product.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);

    return jsonResponse.map((productJson) => Product.fromJson(productJson)).toList();
  }
}
