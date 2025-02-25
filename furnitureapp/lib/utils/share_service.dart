import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:furnitureapp/main.dart';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:furnitureapp/model/login_response_model.dart';

const String KEY_NAME = "login_key";

// Assuming you have a global navigator key defined somewhere in your app

class ShareService {
  static Future<bool> isLoggedIn() async {
    var isCacheKeyExists = await APICacheManager().isAPICacheKeyExist(KEY_NAME);
    return isCacheKeyExists;
  }

  static Future<void> setLoginDetails(LoginResponseModel model) async {
    print('Saving login details: ${jsonEncode(model.toJson())}');

    APICacheDBModel cacheDBmodel = APICacheDBModel(
      key: KEY_NAME,
      syncData: jsonEncode(
          model.toJson()), // Chuyển đổi đối tượng sang JSON và lưu vào cache
    );
    await APICacheManager().addCacheData(cacheDBmodel);
  }

  static Future<LoginResponseModel?> getLoginDetails() async {
    var isCacheDataExist = await APICacheManager().isAPICacheKeyExist(KEY_NAME);

    if (isCacheDataExist) {
      var cacheData = await APICacheManager().getCacheData(KEY_NAME);
      return loginResponseJson(cacheData
          .syncData); // Chuyển đổi JSON từ cache về đối tượng LoginResponseModel
        } else {
      // Nếu cache key không tồn tại
      return null;
    }
  }

  // Lấy token từ đối tượng loginDetails
  static Future<String?> getToken() async {
    LoginResponseModel? loginDetails = await getLoginDetails();
    if (loginDetails?.accesstoken == null) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil("/login", (route) => false);
    }
    return loginDetails?.accesstoken;
  }

  static Future<void> logout(BuildContext context) async {
    await APICacheManager().deleteCache(KEY_NAME);
    Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
  }
}
