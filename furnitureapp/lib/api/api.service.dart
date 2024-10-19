import 'dart:convert';
import 'package:http/http.dart' as http; //+
import 'package:furnitureapp/config/config.dart';

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
    }else {
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
      // await ShareService.setLoginDetails(loginResponseJson(repository.body));
      return true;
    }else {
      return false;
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
          'id': product['_id'],
          'name': product['name'],
          'description': product['description'],
          'price': product['price'],
          'stockQuantity': product['stockQuantity'],
          'material': product['material'],
          'color': product['color'],
          'images': product['images'],
          'discount': product['discount'] != 0 ? product['discount'].toString() : '',
          'category': product['category'],
          'brand': product['brand'],
          'style': product['style'],
          'assemblyRequired': product['assemblyRequired'],
          'dimensions': product['dimensions'],
          'weight': product['weight']
        };
      }).toList();

      return productList;
    } else {
      // Nếu yêu cầu không thành công, ném ngoại lệ
      throw Exception('Failed to fetch products');
    }
  }
}

