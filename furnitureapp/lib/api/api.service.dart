import 'dart:convert';
import 'package:http/http.dart' as http; //+
import 'package:furnitureapp/config/config.dart';
import 'package:furnitureapp/utils/share_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:furnitureapp/model/login_response_model.dart';

class APIService {
  static var client = http.Client();
  

  // register post request
  static Future<bool> register(String username, String password, String email,
      String phoneNumber, String address) async {
    Map<String, String> requestHeaders = {'Content-type': 'application/json'};
    var url = Uri.http(Config.apiURL, Config.registerAPI);

    var repository = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'phonenumber': phoneNumber,
        'address': address,
      }),
    );
    if (repository.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  // login post request
  static Future<bool> login(String username, String passwords) async {
    Map<String, String> requestHeaders = {'Content-type': 'application/json'};
    var url = Uri.http(Config.apiURL, Config.loginAPI);

    var repository = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode({
        'username': username,
        'password': passwords,
      }),
    );
    print("Raw API Response: ${repository.body}"); // Print the raw response
    if (repository.statusCode == 200) {
      await ShareService.setLoginDetails(loginResponseJson(repository.body));
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> socialLogin(String firebaseToken) async {
    try {
      final response = await http.post(
        Uri.parse('http://${Config.apiURL}/${Config.socialLoginAPI}'),
        headers: {
          'Content-Type': 'application/json',
          'firebaseToken': firebaseToken,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Save access token to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['accessToken']);
        return true;
      }
      return false;
    } catch (e) {
      print('Error during social login: $e');
      return false;
    }
  }

// get cart
  static Future<Map<String, dynamic>> getCart() async {
    try {
      String? token = await ShareService.getToken();
      print("Token: $token");
      if (token == null) {
        throw Exception('User not logged in');
      } else {
        Map<String, String> requestHeaders = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        };
        var url = Uri.http(Config.apiURL, Config.CartAPI);
        var repository = await client.get(
          url,
          headers: requestHeaders,
        );
        print("Cart API Response Status Code: ${repository.statusCode}");
        print("Cart API Response Body: ${repository.body}");

        if (repository.statusCode == 200) {
          var body = repository.body;
          if (body.isNotEmpty) {
            // Kiểm tra nếu body là chuỗi JSON hợp lệ
            try {
              // Nếu phản hồi là chuỗi JSON hợp lệ, parse nó thành Map
              return jsonDecode(body) as Map<String, dynamic>;
            } catch (e) {
              // Nếu không thể parse, xử lý ngoại lệ
              throw FormatException("Invalid JSON format in response: $e");
            }
          } else {
            throw Exception('Empty response body');
          }
        } else {
          throw Exception(
              'Failed to fetch cart: ${repository.statusCode} - ${repository.body}');
        }
      }
    } catch (e) {
      print("Error in getCart: $e");
      rethrow;
    }
  }

// add cart
  static Future<bool> addToCart(String productId, int quantity) async {
    String? token = await ShareService.getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var url = Uri.http(
        Config.apiURL, Config.CartAPI); // Ensure the correct API endpoint
    var repository = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode({
        'productId': productId,
        'quantity': quantity,
      }),
    );
    print("Cart API Response Status Code: ${repository.statusCode}");
    print("Cart API Response Body: ${repository.body}");

    if (repository.statusCode == 200) {
      return true;
    } else if (repository.statusCode == 400) {
      // Navigate to the login page if the status code is 400
      // _navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
      return false;
    } else {
      throw Exception(
          'Failed to add to cart: ${repository.statusCode} - ${repository.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchAllProducts() async {
    // Headers cho yêu cầu HTTP
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    // Tạo URL với các tham số cần thiết (nếu có)
    var url = Uri.http(Config.apiURL, Config.listProductAPI);

    // Gửi yêu cầu GET
    var response = await http.get(url, headers: requestHeaders);

    // Kiểm tra xem yêu cầu có thành công hay không (status code 200)
    if (response.statusCode == 200) {
      // Parse JSON từ body của response
      var jsonResponse = jsonDecode(response.body);
      List<dynamic> products = jsonResponse['products'];

      // Chuyển đổi danh sách thành List<Map<String, dynamic>>
      List<Map<String, dynamic>> productList = products.map((product) {
        return {
          '_id': product['_id'],
          'name': product['name'],
          'description': product['description'],
          'price': product['price'] is String
              ? double.tryParse(product['price'])
              : product['price']?.toDouble(),
          'stockQuantity': product['stockQuantity'],
          'material': product['material'],
          'color': product['color'],
          'images': product['images'],
          'discount':
              product['discount'] != 0 ? product['discount'].toString() : '',
          'category': product['category'],
          'brand': product['brand'],
          'style': product['style'],
          'assemblyRequired': product['assemblyRequired'],
          'dimensions': product['dimensions'],
          'weight': product['weight'],
          'sold': product['sold'], // Thêm trường sold
          'rating': product['rating'], // Thêm trường rating
          'model3d': product['model3d'],
        };
      }).toList();

      return productList;
    } else {
      // Nếu yêu cầu không thành công, ném ngoại lệ
      throw Exception('Failed to fetch products');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchAllCategories() async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.http(Config.apiURL, Config.listCategoryAPI);

    var response = await http.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<dynamic> categoriesJson = jsonResponse['categories'];

      return categoriesJson
          .map((categoryJson) => categoryJson as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  static Future<Map<String, dynamic>> checkout(
      Map<String, dynamic> checkoutData) async {
    String? token = await ShareService.getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var url = Uri.http(Config.apiURL, Config.checkoutAPI);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(checkoutData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Checkout failed: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchProductsByCategory(
      String categoryId) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    // Sửa cách gửi categoryId trong URL
    var url = Uri.http(
        Config.apiURL, '${Config.listProductByCategoryAPI}/$categoryId');

    var response = await http.get(url, headers: requestHeaders);
    print('Fetching products for category: $categoryId');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<dynamic> products = jsonResponse['products'];

      List<Map<String, dynamic>> productList = products.map((product) {
        return {
          '_id': product['_id'],
          'name': product['name'],
          'description': product['description'],
          'price': product['price'] is String
              ? double.tryParse(product['price'])
              : product['price']?.toDouble(),
          'stockQuantity': product['stockQuantity'],
          'material': product['material'],
          'color': product['color'],
          'images': product['images'],
          'discount':
              product['discount'] != 0 ? product['discount'].toString() : '',
          'category': product['category'],
          'brand': product['brand'],
          'style': product['style'],
          'assemblyRequired': product['assemblyRequired'],
          'dimensions': product['dimensions'],
          'weight': product['weight'],
          'sold': product['sold'],
          'rating': product['rating'],
          'model3d': product['model3d'],
        };
      }).toList();

      return productList;
    } else {
      throw Exception('Failed to fetch products for category: $categoryId');
    }
  }

  // Move all methods inside the class
  static Future<bool> updateCartItem(String productId, int quantity) async {
    String? token = await ShareService.getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var url = Uri.http(
        Config.apiURL, Config.updateCartAPI); // Ensure the correct API endpoint
    var repository = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode({
        'productId': productId,
        'quantity': quantity,
      }),
    );
    print("Update Cart API Response Status Code: ${repository.statusCode}");
    print("Update Cart API Response Body: ${repository.body}");

    if (repository.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Failed to update cart item: ${repository.statusCode} - ${repository.body}');
    }
  }

  static Future<bool> deleteCartItem(String productId) async {
    String? token = await ShareService.getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var url = Uri.http(
        Config.apiURL, Config.deleteCartAPI); // Ensure the correct API endpoint
    var repository = await client.delete(
      url,
      headers: requestHeaders,
      body: jsonEncode({
        'productId': productId,
      }),
    );
    print("Delete Cart API Response Status Code: ${repository.statusCode}");
    print("Delete Cart API Response Body: ${repository.body}");

    if (repository.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Failed to delete cart item: ${repository.statusCode} - ${repository.body}');
    }
  }

  static Future<bool> addAddress(Map<String, dynamic> addressData) async {
    String? token = await ShareService.getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var url = Uri.http(Config.apiURL, Config.addressAPI);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(addressData),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception(
          'Failed to add address: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<bool> updateAddress(
      String addressId,
      String name,
      String phone,
      String street,
      String district,
      String ward,
      String commune,
      String city,
      String province,
      bool isDefault,
  ) async {
    String? token = await ShareService.getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var url = Uri.http(Config.apiURL, '${Config.addressAPI}/$addressId');
    var repository = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'street': street,
        'city': city,
        'province': province,
        'isDefault': isDefault,
      }),
    );
    if (repository.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Failed to update address: ${repository.statusCode} - ${repository.body}');
    }
  }

  static Future<bool> deleteAddress(String addressId) async {
    String? token = await ShareService.getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var url = Uri.http(Config.apiURL, Config.addressAPI);
    var repository = await client.delete(
      url,
      headers: requestHeaders,
      body: jsonEncode({
        "addressId": addressId,
      }),
    );
    if (repository.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Failed to delete address: ${repository.statusCode} - ${repository.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllAddresses() async {
    String? token = await ShareService.getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var url = Uri.http(Config.apiURL, Config.addressAPI);
    var repository = await client.get(
      url,
      headers: requestHeaders,
    );
    if (repository.statusCode == 200) {
      var jsonResponse = jsonDecode(repository.body);
      if (jsonResponse is List) {
        return List<Map<String, dynamic>>.from(jsonResponse);
      } else if (jsonResponse is Map && jsonResponse.containsKey('addresses')) {
        // Adjust this line if the API response wraps the list in an object
        return List<Map<String, dynamic>>.from(jsonResponse['addresses']);
      } else {
        throw Exception('Unexpected JSON format');
      }
    } else {
      throw Exception(
          'Failed to fetch addresses: ${repository.statusCode} - ${repository.body}');
    }
  }

  static Future<bool> addCard(Map<String, dynamic> cardData) async {
    String? token = await ShareService.getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var url = Uri.http(Config.apiURL, Config.cardAPI);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(cardData),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception(
          'Failed to add card: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<bool> updateCard(
      String cardId, Map<String, dynamic> cardData) async {
    String? token = await ShareService.getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var url = Uri.http(Config.apiURL, '${Config.cardAPI}/$cardId');
    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(cardData),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Failed to update card: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<bool> deleteCard(String cardId) async {
    String? token = await ShareService.getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var url = Uri.http(Config.apiURL, '${Config.cardAPI}/$cardId');
    var response = await client.delete(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Failed to delete card: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllCards() async {
    String? token = await ShareService.getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var url = Uri.http(Config.apiURL, Config.cardAPI);
    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse is List) {
        return List<Map<String, dynamic>>.from(jsonResponse);
      } else if (jsonResponse is Map && jsonResponse.containsKey('cards')) {
        // Giả sử API trả về một đối tượng với key 'cards' chứa danh sách thẻ
        return List<Map<String, dynamic>>.from(jsonResponse['cards']);
      } else {
        throw Exception('Unexpected JSON format');
      }
    } else {
      throw Exception(
          'Failed to fetch cards: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getReviewsByProduct(
      String productId) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
      };

      var url =
          Uri.http(Config.apiURL, '${Config.reviewByProductAPI}/$productId');
      var response = await client.get(url, headers: requestHeaders);

      print('Fetching reviews for product: $productId');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return {
          'success': jsonResponse['success'] ?? false,
          'data': {
            'reviews': jsonResponse['data']['reviews'] ?? [],
            'pagination': jsonResponse['data']['pagination'] ?? {},
          }
        };
      } else {
        throw Exception('Failed to load reviews: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching reviews: $e");
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    try {
      Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
      var queryParams = {'query': query};
      
      var url = Uri.http(Config.apiURL, Config.searchProductAPI, queryParams);
      
      var response = await http.get(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['success'] == true && 
            jsonResponse['data'] != null && 
            jsonResponse['data']['products'] != null) {
          
          List<dynamic> products = jsonResponse['data']['products'];
          return products.map((product) => {
            '_id': product['_id'],
            'name': product['name'],
            'description': product['description'],
            'price': product['price'],
            'stockQuantity': product['stockQuantity'],
            'material': product['material'],
            'color': product['color'],
            'images': product['images'],
            'category': product['category'],
            'discount': product['discount'],
            'brand': product['brand'],
            'style': product['style'],
            'assemblyRequired': product['assemblyRequired'],
            'dimensions': product['dimensions'],
            'weight': product['weight'],
            'sold': product['sold'],
            'rating': product['rating'],
            'model3d': product['model3d'],
            'modelFormat': product['modelFormat'],
            'modelConfig': product['modelConfig'],
          }).toList();
        }
        return [];
      } else {
        throw Exception('Failed to search products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in searchProducts: $e');
      rethrow;
    }
  }

  // get User Profile
  static Future<Map<String, dynamic>> getUserProfile() async {
    String? token = await ShareService.getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var url = Uri.http(Config.apiURL, Config.profileAPI);
    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to fetch profile: ${response.statusCode} - ${response.body}');
    }
  }

  // get API order đơn hàng của user
  static Future<Map<String, dynamic>> getOrders() async {
    String? token = await ShareService.getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var url = Uri.http(Config.apiURL, Config.userOrderAPI);
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to fetch orders: ${response.statusCode} - ${response.body}');
    }
  }

// get API wishlist of user
  static Future<Map<String, dynamic>> getWishlist() async {
    String? token = await ShareService.getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var url = Uri.http(Config.apiURL, Config.wishlistAPI);
    var response = await http.get(url, headers: requestHeaders);
    print("favorite List : ${response.body}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to fetch wishlist: ${response.statusCode} - ${response.body}');
    }
  }

  // delete API wishlist of user
  static Future<bool> deleteWishlist(String productId) async {
    String? token = await ShareService.getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var url = Uri.http(Config.apiURL, '${Config.wishlistAPI}/$productId');
    var response = await http.delete(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Failed to delete wishlist: ${response.statusCode} - ${response.body}');
    }
  }

  // add API wishlist of user
  static Future<bool> addWishlist(String productId) async {
    String? token = await ShareService.getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var url = Uri.http(Config.apiURL, '${Config.wishlistAPI}/$productId');
    var response = await http.post(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Failed to add wishlist: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getDeliveredOrders() async {
    String? token = await ShareService.getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }
    
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    
    var url = Uri.http(Config.apiURL, Config.deliveredOrdersAPI);
    print("Request URL: $url"); // Debug URL
    
    var response = await client.get(url, headers: requestHeaders);
    print("Response status: ${response.statusCode}"); // Debug status
    print("Response body: ${response.body}"); // Debug response
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch delivered orders: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<bool> createReview(
      String productId,
      double rating,
      String comment,
      List<String> imagePaths,
  ) async {
    try {
      String? token = await ShareService.getToken();
      if (token == null) throw Exception('User not logged in');

      var userProfile = await getUserProfile();
      String userId = userProfile['_id'];

      var uri = Uri.http(Config.apiURL, Config.createReviewAPI);
      var request = http.MultipartRequest('POST', uri);
      
      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      // Add text fields
      request.fields['userId'] = userId;
      request.fields['productId'] = productId;
      request.fields['rating'] = rating.toString();
      request.fields['comment'] = comment;

      // Add image files
      for (String path in imagePaths) {
        request.files.add(
          await http.MultipartFile.fromPath('image', path),
        );
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      print('Review creation response: $responseData');

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('Error creating review: $e');
      rethrow;
    }
  }

  static Future<String?> getUserId() async {
    // Implement logic để lấy userId từ local storage hoặc state management
    // Ví dụ:
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  static Future<double> getProductAverageRating(String productId) async {
    try {
      String? token = await ShareService.getToken();
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Authorization': token != null ? 'Bearer $token' : '',
      };

      var url = Uri.http(Config.apiURL, '${Config.reviewByProductAPI}/$productId');
      var response = await client.get(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          List<dynamic> reviews = data['data']['reviews'];
          if (reviews.isEmpty) return 0.0;
          
          double totalRating = reviews.fold(0.0, (sum, review) => 
            sum + (review['rating']?.toDouble() ?? 0.0));
          return totalRating / reviews.length;
        }
      }
      return 0.0;
    } catch (e) {
      print('Error calculating average rating: $e');
      return 0.0;
    }
  }

  static Future<bool> updateAvatar(String imagePath) async {
    String? token = await ShareService.getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }

    var uri = Uri.http(Config.apiURL, Config.updateAvatarAPI);
    var request = http.MultipartRequest('PUT', uri);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    print('Update avatar response: $responseData');

    return response.statusCode == 200;
  }

  static Future<bool> cancelOrder(String orderId) async {
    String? token = await ShareService.getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var url = Uri.http(Config.apiURL, '/api/v1/orders/$orderId');
    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode({'payment_status': 'Cancelled'}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to cancel order: ${response.statusCode} - ${response.body}');
    }
  }
}
