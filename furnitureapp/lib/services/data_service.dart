import 'dart:convert';
import '../model/product.dart';
import '../model/card_model.dart';
import '../model/address_model.dart';
import 'package:furnitureapp/model/Review.dart';
import 'package:furnitureapp/api/api.service.dart';
import 'package:furnitureapp/model/Categories.dart';
import 'package:furnitureapp/model/order_model.dart';
import 'package:furnitureapp/model/wishlist_model.dart';
import 'package:furnitureapp/model/Cart_User_Model.dart';
import 'package:furnitureapp/model/UserProfile_model.dart';

class DataService {
  const DataService();

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
          productList = await APIService.fetchProductsByCategory(selectedCategory.id!);
        } else {
          productList = await APIService.fetchAllProducts();
        }
      }

      List<Product> products = [];
      for (var productJson in productList) {
        if (productJson['price'] == null) continue;

        double? price = productJson['price']?.toDouble();
        if (minPrice != null && price! < minPrice) continue;
        if (maxPrice != null && price! > maxPrice) continue;

        double avgRating = await getProductAverageRating(productJson['_id']);
        
        Product product = Product.fromJson(productJson);
        product.rating = avgRating;
        products.add(product);
      }

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

      return productList.map((json) {
        return Product(
          id: json['_id'],
          name: json['name'],
          description: json['description'],
          price: json['price']?.toDouble(),
          dimensions: json['dimensions'] != null ? Dimensions.fromJson(json['dimensions']) : null,
          stockQuantity: json['stockQuantity'],
          material: json['material'],
          color: json['color'] != null ? ProductColor.fromJson(json['color']) : null,
          images: List<String>.from(json['images'] ?? []),
          category: json['category'],
          discount: json['discount'],
          brand: json['brand'],
          style: json['style'],
          assemblyRequired: json['assemblyRequired'],
          weight: json['weight'],
          sold: json['sold'],
          rating: json['rating']?.toDouble(),
          model3d: json['model3d'],
          modelFormat: json['modelFormat'],
          modelConfig: json['modelConfig'],
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

  Future<List<OrderData>> getDeliveredOrders() async {
    try {
      final response = await APIService.getDeliveredOrders();
      print("Raw API Response: $response"); // Debug log
      
      if (response['success'] == true && response['data'] != null) {
        List<dynamic> ordersData = response['data'] as List;
        print("Orders data: $ordersData"); // Debug log
        
        return ordersData.map((orderJson) {
          try {
            return OrderData.fromJson(orderJson);
          } catch (e) {
            print("Error parsing individual order: $e");
            return null;
          }
        }).whereType<OrderData>().toList();
      }
      return [];
    } catch (error) {
      print('Error in getDeliveredOrders: $error');
      return [];
    }
  }

  Future<double> getProductAverageRating(String productId) async {
    try {
      return await APIService.getProductAverageRating(productId);
    } catch (e) {
      print('Error getting average rating: $e');
      return 0.0;
    }
  }
}
