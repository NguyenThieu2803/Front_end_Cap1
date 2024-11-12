import 'dart:convert';
import '../model/product.dart';
import '../model/card_model.dart';
import '../model/address_model.dart';
import 'package:furnitureapp/model/Review.dart';
import 'package:furnitureapp/api/api.service.dart';
import 'package:furnitureapp/model/Categories.dart';
import 'package:furnitureapp/model/Order_model.dart';
import 'package:furnitureapp/model/wishlist_model.dart';
import 'package:furnitureapp/model/Cart_User_Model.dart';
import 'package:furnitureapp/model/UserProfile_model.dart';



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
          productList =
              await APIService.fetchProductsByCategory(selectedCategory.id!);
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
      }).toList();

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
        throw FormatException(
            'Unexpected format of cart data: ${cartData.runtimeType}');
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
      return categoriesData
          .map<Categories>((data) => Categories.fromJson(data))
          .toList();
    } catch (e) {
      print('Lỗi khi tải danh mục: $e');
      return []; // Trả về list rỗng thay vì null
    }
  }

  Future<List<AddressUser>> loadAddresses() async {
    try {
      List<Map<String, dynamic>> addressData =
          await APIService.getAllAddresses();
      print("Address data received: $addressData");
      return addressData
          .map<AddressUser>((data) => AddressUser.fromJson(data))
          .toList();
    } catch (error) {
      print('Failed to load addresses: $error');
      return [];
    }
  }

  Future<List<CardModel>> loadCards() async {
    try {
      List<Map<String, dynamic>> cardData = await APIService.getAllCards();
      return cardData
          .map<CardModel>((data) => CardModel.fromJson(data))
          .toList();
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
        return reviewsData
            .map<Review>((reviewJson) => Review.fromJson(reviewJson))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error loading reviews: $e');
      return [];
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      List<Map<String, dynamic>> productList = await APIService.searchProducts(query);
      print('API Response: $productList'); // Debug log

      return productList.map((json) {
        // Parse dimensions if available
        Dimensions? dimensions;
        if (json['dimensions'] != null) {
          dimensions = Dimensions(
            height: json['dimensions']['height'],
            width: json['dimensions']['width'],
            depth: json['dimensions']['depth'],
            unit: json['dimensions']['unit'],
          );
        }

        // Parse color if available
        ProductColor? color;
        if (json['color'] != null) {
          color = ProductColor(
            primary: json['color']['primary'],
            secondary: json['color']['secondary'],
          );
        }

        return Product(
          id: json['_id'] ?? '', // MongoDB usually uses _id
          name: json['name'] ?? 'No Name',
          description: json['description'] ?? '',
          shortDescription: json['shortDescription'] ?? '',
          price: (json['price'] ?? 0).toDouble(),
          dimensions: dimensions,
          stockQuantity: json['stockQuantity'] ?? 0,
          material: json['material'] ?? '',
          color: color,
          images: List<String>.from(json['images'] ?? []),
          category: json['category'] ?? '',
          discount: json['discount'] ?? 0,
          promotionId: json['promotionId'],
          brand: json['brand'] ?? '',
          style: json['style'] ?? '',
          assemblyRequired: json['assemblyRequired'] ?? false,
          weight: json['weight'] ?? 0,
          sold: json['sold'] ?? 0,
          rating: (json['rating'] ?? 0).toDouble(),
        );
      }).toList();
    } catch (error) {
      print('Failed to search products: $error');
      return [];
    }
  }

  // Method to fetch user profile
  Future<UserProfile?> loadUserProfile() async {
    try {
      final Map<String, dynamic> userData = await APIService.getUserProfile();
      print("This is user profile: $userData");
      return UserProfile.fromJson(userData);
    } catch (error) {
      print('Failed to load user profile: $error');
      return null;
    }
  }

  // Get Order By UserId
    Future<List<OrderData>> getOrdersByUserId() async {
    try {
      final response = await APIService.getOrders();
      Order order = Order.fromJson(response);
      return order.data;
    } catch (error) {
      print('Failed to load orders: $error');
      return [];
    }
  }

   // get wishlist by userid
   Future<Wishlist?> getWishlistByUserId() async {
    try {
      final response = await APIService.getWishlist();

      //  Extract the nested "wishlist" object
      if (response.containsKey('wishlist')) {
        final wishlistData = response['wishlist'] as Map<String, dynamic>;
        return Wishlist.fromJson(wishlistData);
      } else {
        print('Invalid wishlist data format: $response');
        return null; // Or throw an error if you prefer
      }
    } catch (error) {
      print('Failed to load wishlist: $error');
      return null;
    }
  }
  
  Future<bool> removeFromWishlist(String productId) async {
    try {
      return await APIService.deleteWishlist(productId);
    } catch (e) {
      print('Error removing from wishlist: $e');
      return false;
    }
  }

  Future<bool> addToWishlist(String productId) async {
    try {
      return await APIService.addWishlist(productId);
    } catch (e) {
      print('Error adding to wishlist: $e');
      return false;
    }
  }
}
