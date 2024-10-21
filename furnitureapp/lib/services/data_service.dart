import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:furnitureapp/api/api.service.dart';
import '../model/product.dart';

class DataService {
  Future<List<Product>> loadProducts({required String category}) async {
    try {
      // Gọi API để lấy dữ liệu sản phẩm
      List<Map<String, dynamic>> productList = await APIService.fetchAllProducts();
      print(productList);

      // Chuyển đổi danh sách sản phẩm (List<Map>) thành List<Product>
      return productList
          .map((productJson) => Product.fromJson(productJson))
          .toList();
    } catch (error) {
      print('Failed to load products: $error');
      return [];
    }
  }
}
