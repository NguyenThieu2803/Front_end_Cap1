import 'package:flutter/material.dart';
import 'package:furnitureapp/pages/FavoritePage.dart';
import 'package:furnitureapp/pages/NotificationPage.dart';
import 'package:furnitureapp/pages/UserProfilePage.dart';
import 'package:furnitureapp/pages/product.dart';
import 'package:furnitureapp/widgets/HomeMainNavigationBar.dart';
import 'package:furnitureapp/widgets/HomeNavigationBar.dart';
import 'pages/StartNow.dart';
import 'pages/LoginPage.dart';
import 'pages/Homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Tắt banner debug
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Thiết lập màu nền mặc định
      ),
<<<<<<< HEAD
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
      routes: {
        "/": (context) => Setting(),
        "/login": (context) => LoginPage(),
        
=======
      // Định nghĩa các routes cho ứng dụng
      routes: {
        "/": (context) => HomePage(), // Trang khởi đầu
        "/login": (context) => LoginPage(), // Trang login
        "/main": (context) => HomeMainNavigationBar(), // Trang chính với bottom navigation
        "/product": (context) => ProductPage(), // Trang sản phẩm
        "/user-profile": (context) => UserProfilePage(), // Trang hồ sơ người dùng
        "/notifications": (context) => NotificationPage(),
>>>>>>> bde22ff1206801364e2fc1c528d07ce745bf730e
      },
      initialRoute: "/", // Định nghĩa trang bắt đầu khi ứng dụng chạy
    );
  }
}