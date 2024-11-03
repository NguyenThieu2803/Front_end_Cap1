import 'dart:convert';
import '../model/product.dart';
import '../model/card_model.dart';
import '../model/address_model.dart';
import 'package:furnitureapp/api/api.service.dart';
import 'package:furnitureapp/model/Cart_User_Model.dart';
import 'package:furnitureapp/model/Categories.dart';
import 'package:furnitureapp/model/Review.dart';

class DataService {
  Future<List<Product>> loadProducts({
    String? category,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      List<Map<String, dynamic>> productList;
      
      if (category == null || category == 'All Product') {
        productList = await APIService.fetchAllProducts();
      } else {
        List<Categories> categories = await loadCategories();
        Categories? selectedCategory = categories.firstWhere(
          (cat) => cat.name == category,
          orElse: () => Categories(),
        );
        
        if (selectedCategory.id != null) {
          print('Loading products for category: ${selectedCategory.id}');
          productList = await APIService.fetchProductsByCategory(selectedCategory.id!);
        } else {
          productList = await APIService.fetchAllProducts();
        }
      }
      
      List<Product> products = productList
          .map((productJson) => Product.fromJson(productJson))
          .where((product) {
            if (product.price == null) return false;
            
            bool meetsMinPrice = minPrice == null || product.price! >= minPrice;
            bool meetsMaxPrice = maxPrice == null || product.price! <= maxPrice;
            
            print('Product: ${product.name}, Price: ${product.price}, ' 
                  'Meets min: $meetsMinPrice, Meets max: $meetsMaxPrice');
            
            return meetsMinPrice && meetsMaxPrice;
          })
          .toList();
      
      print('Filtered products count: ${products.length}');
      return products;
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
      final categoriesData = await APIService.fetchAllCategories();
      return categoriesData.map((data) => Categories.fromJson(data)).toList();
    } catch (e) {
      print('Lỗi khi tải danh mục: $e');
      return []; // Trả về list rỗng thay vì null
    }
  }

  Future<List<AddressUser>> loadAddresses() async {
    try {
      List<Map<String, dynamic>> addressData = await APIService.getAllAddresses();
      print("Address data received: $addressData");
      return addressData.map((data) => AddressUser.fromJson(data)).toList();
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

  Future<List<Review>> loadReviews(String productId) async {
    try {
      final response = await APIService.getReviewsByProduct(productId);
      
      if (response['success'] == true && response['data'] != null) {
        List<dynamic> reviewsData = response['data']['reviews'];
        return reviewsData.map((reviewJson) => Review.fromJson(reviewJson)).toList();
      }
      return [];
    } catch (e) {
      print('Error loading reviews: $e');
      return [];
    }
  }
}
