import 'package:flutter/material.dart';
import 'package:front_end_cap1/model/categories.dart';
import 'package:front_end_cap1/services/api_service.dart';

class DataService {
  Future<List<Categories>> loadCategories() async {
    try {
      final categoriesData = await APIService.fetchAllCategories();
      return categoriesData.map((data) => Categories.fromJson(data)).toList();
    } catch (e) {
      print('Lỗi khi tải danh mục: $e');
      return []; // Trả về list rỗng thay vì null
    }
  }
}
