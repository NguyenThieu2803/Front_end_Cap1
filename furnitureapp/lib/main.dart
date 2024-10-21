import 'dart:io';
import 'pages/Homepage.dart';
import 'pages/Homepage.dart';
import 'pages/LoginPage.dart';
import 'pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:furnitureapp/model/product.dart';
import 'package:furnitureapp/pages/sign_up.dart';
import 'package:furnitureapp/pages/setting.dart';
import 'package:furnitureapp/pages/StartNow.dart';
import 'package:furnitureapp/pages/ProductPage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; 
import 'package:furnitureapp/admin/HomePageAdmin.dart';
import 'package:furnitureapp/translate/localization.dart';
import 'package:furnitureapp/pages/NotificationPage.dart';
import 'package:furnitureapp/widgets/CartItemSamples.dart';
import 'package:furnitureapp/widgets/CartItemSamples.dart';
import 'package:furnitureapp/widgets/HomeMainNavigationBar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';






  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo tất cả plugin được khởi tạo trước khi chạy ứng dụng

  // Khởi tạo cho desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit(); // Khởi tạo ffi cho SQLite trên các nền tảng desktop
    databaseFactory = databaseFactoryFfi; // Đặt databaseFactory cho FFI
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Tắt banner debug
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Thiết lập màu nền mặc định
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate, 
      ],
      supportedLocales: [
        Locale('en', 'US'), // English
        Locale('vi', 'VN'), // Vietnamese
      ],
      navigatorKey: _navigatorKey,
      
      // Định nghĩa các routes cho ứng dụng
      routes: {
        "/startnow": (context) => StartNow(),
        "/home": (context) => HomePage(), // Trang khởi đầu
        "/": (context) => HomePageAdmin(), // Trang khởi đầu
        "/login": (context) => LoginPage(), // Trang login
        "/main": (context) => HomeMainNavigationBar(), // Trang chính với bottom navigation
        "/product": (context) => ProductPage(product: Product), // Trang sản phẩm
        "/notifications": (context) => NotificationPage(),
        "/register": (context) => SignUp()
      },
      initialRoute: "/startnow", // Định nghĩa trang bắt đầu khi ứng dụng chạy
    );
  }
}

