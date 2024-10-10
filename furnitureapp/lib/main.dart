/*
import 'package:furnitureapp/pages/setting.dart';
import 'package:furnitureapp/widgets/CartItemSamples.dart';

import 'pages/StartNow.dart';
import 'pages/Homepage.dart';
import 'pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:furnitureapp/pages/product.dart';
import 'package:furnitureapp/pages/FavoritePage.dart';
import 'package:furnitureapp/pages/UserProfilePage.dart';
import 'package:furnitureapp/translate/localization.dart';
import 'package:furnitureapp/pages/NotificationPage.dart';
import 'package:furnitureapp/widgets/HomeNavigationBar.dart';
import 'package:furnitureapp/widgets/HomeMainNavigationBar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';



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
      
      // Định nghĩa các routes cho ứng dụng
      routes: {
        "/": (context) => HomePage(), // Trang khởi đầu
        "/login": (context) => LoginPage(), // Trang login
        "/main": (context) => HomeMainNavigationBar(), // Trang chính với bottom navigation
        "/product": (context) => ProductPage(product: Product), // Trang sản phẩm
        "/notifications": (context) => NotificationPage(),
      },
      initialRoute: "/", // Định nghĩa trang bắt đầu khi ứng dụng chạy
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:furnitureapp/pages/Homepage.dart';
import 'package:furnitureapp/pages/setting.dart';
import 'package:furnitureapp/pages/language.dart';
import 'package:furnitureapp/translate/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Đảm bảo Flutter được khởi tạo trước
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale(); // Load ngôn ngữ lưu trữ trước khi build ứng dụng
  }

  Future<void> _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      setState(() {
        _locale = Locale(languageCode); // Áp dụng ngôn ngữ đã lưu
      });
    }
  }

  void _changeLanguage(String languageCode) {
    setState(() {
      _locale = Locale(languageCode); // Thay đổi ngôn ngữ
    });
    _saveLanguage(languageCode);
  }

  Future<void> _saveLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'language_code', languageCode); // Lưu ngôn ngữ vào SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale, // Thiết lập ngôn ngữ
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('vi', 'VN'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      initialRoute: "/",
      routes: {
        "/": (context) => Setting(
            onLanguageChanged: _changeLanguage), // Mở trang mặc định
        "/language": (context) => LanguagePage(
            onLanguageChanged: _changeLanguage), // Truyền hàm thay đổi ngôn ngữ
        //"/language": (context) => LanguagePage(onLanguageChanged: (_) {}),
      },
    );
  }
}
