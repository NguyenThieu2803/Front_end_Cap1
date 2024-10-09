import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //+
import 'package:furnitureapp/config/config.dart';
import 'package:furnitureapp/utils/share_service.dart';
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
}
