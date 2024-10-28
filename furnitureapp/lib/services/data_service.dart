import 'dart:convert';
import '../model/product.dart';
import '../model/card_model.dart';
import '../model/address_model.dart';
import 'package:furnitureapp/api/api.service.dart';
import 'package:furnitureapp/model/Cart_User_Model.dart';
import 'package:furnitureapp/model/Categories.dart';
class DataService {
  Future<List<Product>> loadProducts({required String category}) async {
    try {
      List<Map<String, dynamic>> productList;
      
      if (category == 'All Product') {
        productList = await APIService.fetchAllProducts();
      } else {
        // Lấy danh sách categories để tìm categoryId
        List<Categories> categories = await loadCategories();
        Categories? selectedCategory = categories.firstWhere(
          (cat) => cat.name == category,
          orElse: () => Categories(),
        );
        
        if (selectedCategory.id != null) {
          print('Loading products for category: ${selectedCategory.id}');
          productList = await APIService.fetchProductsByCategory(selectedCategory.id!);
        } else {
          print('Category ID not found for: $category');
          productList = await APIService.fetchAllProducts();
        }
      }
      
      return productList.map((productJson) => Product.fromJson(productJson)).toList();
    } catch (error) {
      print('Failed to load products: $error');
      return [];
    }
  }

  Future<Cart?> loadCart() async {
    try {
      dynamic cartData = await APIService.getCart();
      print("Cart data received: $cartData");
      
      Map<String, dynamic> parsedData;
      if (cartData is String) {
        print("Parsing String to JSON");
        parsedData = json.decode(cartData);
      } else if (cartData is Map<String, dynamic>) {
        print("Data is already a Map");
        parsedData = cartData;
      } else {
        throw FormatException('Unexpected format of cart data: ${cartData.runtimeType}');
      }
      
      print("Parsed data type: ${parsedData.runtimeType}");
      print("Parsed data: $parsedData");
      
      Cart cart = Cart.fromJson(parsedData);
      return cart;
    } catch (error) {
      print('Failed to load cart: $error');
      if (error is FormatException) {
        print('FormatException details: ${error.message}');
      }
      return null;
    }
  }
  
  Future<List<Categories>> loadCategories() async {
    try {
      List<Map<String, dynamic>> categoriesList = await APIService.fetchAllCategories();
      return categoriesList.map((categoryJson) => Categories.fromJson(categoryJson)).toList();
    } catch (error) {
      print('Failed to load categories: $error');
    }
  }
  
  Future<List<Address>> loadAddresses() async {
    try {
      List<Map<String, dynamic>> addressData = await APIService.getAllAddresses();
      print("Address data received: $addressData");
      return addressData.map((data) => Address.fromJson(data)).toList();
    } catch (error) {
      print('Failed to load addresses: $error');
      return [];
    }
  }

  Future<List<CardModel>> loadCards() async {
    try {
      List<Map<String, dynamic>> cardData = await APIService.getAllCards();
      return cardData.map((data) => CardModel.fromJson(data)).toList();
    } catch (error) {
      print('Failed to load cards: $error');
      return [];
    }
  }
}
