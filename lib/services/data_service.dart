import 'package:flutter/material.dart';
import 'package:front_end_cap1/model/categories.dart';
import 'package:front_end_cap1/services/api_service.dart';

class DataService {
  Future<List<Categories>> loadCategories() async {
    try {
      // Fetch categories data from API
      List<Categories> categoriesList = await APIService.fetchAllCategories();
      print("Categories data received: $categoriesList");
      
      // Hiển thị thông tin chi tiết của từng category
      for (var category in categoriesList) {
        // Kiểm tra xem thuộc tính 'id' có tồn tại không
        print("Category ID: ${category.id ?? 'N/A'}");
        print("Category Name: ${category.name}");
        print("------------------------");
      }
      
      return categoriesList;
    } catch (error) {
      print('Failed to load categories: $error');
      return [];
    }
  }
}
