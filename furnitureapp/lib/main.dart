/*
import 'package:furnitureapp/pages/setting.dart';
import 'package:furnitureapp/widgets/CartItemSamples.dart';

import 'pages/Homepage.dart';
import 'pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:furnitureapp/pages/product.dart';
import 'package:furnitureapp/translate/localization.dart';
import 'package:furnitureapp/pages/NotificationPage.dart';
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
import 'package:furnitureapp/admin/user_management.dart';
import 'package:furnitureapp/pages/Homepage.dart';
import 'package:furnitureapp/pages/LoginPage.dart';
import 'package:furnitureapp/pages/setting.dart';
import 'package:furnitureapp/translate/localization.dart';
import 'package:furnitureapp/services/language_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final languageManager = LanguageManager();
  await languageManager.initializeLanguage();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LanguageManager _languageManager = LanguageManager();

  @override
  void initState() {
    super.initState();
    _languageManager.addListener(_onLocaleChange);
  }

  void _onLocaleChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _languageManager.removeListener(_onLocaleChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _languageManager.currentLocale,
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
        "/": (context) => UserManagementPage(),
        "/setting": (context) => Setting(),
      },
    );
  }
}
