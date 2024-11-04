import 'dart:io';
import 'pages/Homepage.dart';
import 'pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:furnitureapp/model/product.dart';
import 'package:furnitureapp/model/product.dart';
import 'package:furnitureapp/pages/sign_up.dart';
import 'package:furnitureapp/pages/SearchPage.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:furnitureapp/pages/ProductPage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:furnitureapp/admin/HomePageAdmin.dart';
import 'package:furnitureapp/admin/UserManagement.dart';
import 'package:furnitureapp/translate/localization.dart';
import 'package:furnitureapp/pages/NotificationPage.dart';
import 'package:furnitureapp/services/language_manager.dart';
import 'package:furnitureapp/widgets/HomeMainNavigationBar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Đảm bảo tất cả plugin được khởi tạo trước khi chạy ứng dụng

  // Khởi tạo cho desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit(); // Khởi tạo ffi cho SQLite trên các nền tảng desktop
    databaseFactory = databaseFactoryFfi; // Đặt databaseFactory cho FFI
  }

  final languageManager = LanguageManager();
  await languageManager.initializeLanguage();

  runApp(
    ChangeNotifierProvider<LanguageManager>.value(
      value: languageManager,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageManager>(
      builder: (context, languageManager, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false, // Tắt banner debug
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white, // Thiết lập màu nền mặc định
          ),
          locale: languageManager.currentLocale, // Thiết lập ngôn ngữ
          supportedLocales: const [
            Locale('en', 'US'), // English
            Locale('vi', 'VN'), // Vietnamese
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate,
          ],
          navigatorKey: navigatorKey,

          // Định nghĩa các routes cho ứng dụng
          routes: {
            //  "/startnow": (context) => StartNow(),
            "/home": (context) => HomePage(),
            "/search": (context) => SearchPage(),
            "/user": (context) => UserManagement(), // Trang khởi đầu
            "/": (context) => HomePageAdmin(), // Trang khởi đầu
            // "/login": (context) => LoginPage(), // Trang login
            "/main": (context) =>
                HomeMainNavigationBar(), // Trang chính với bottom navigation
            "/product": (context) => ProductPage(
                product: Product()), // Pass a default Product instance
            "/notifications": (context) => NotificationPage(),
            "/register": (context) => SignUp()
          },
          initialRoute: "/search", // Định nghĩa trang bắt đầu khi ứng dụng chạy
        );
      },
    );
  }
}



/*final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding
      .ensureInitialized(); // Đảm bảo tất cả plugin được khởi tạo trước khi chạy ứng dụng

  // Khởi tạo cho desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit(); // Khởi tạo ffi cho SQLite trên các nền tảng desktop
    databaseFactory = databaseFactoryFfi; // Đặt databaseFactory cho FFI
  }
  Stripe.publishableKey =
      "pk_test_51Q4IszJ48Cc6e6PCqLUztrVyJYvPsIWd1hAOFRN842Jj7ldseweNpvw7eXXhBF26YTRZc3dvqEFAcRK8hCSFPSF400utPbzD2Q";
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
      navigatorKey: navigatorKey,

      // Định nghĩa các routes cho ứng dụng
      routes: {
        // "/startnow": (context) => StartNow(),
        "/home": (context) => HomePage(), // Trang khởi đầu
        "/": (context) => HomePageAdmin(), // Trang khởi đầu
        "/login": (context) => LoginPage(), // Trang login
        "/main": (context) =>
            HomeMainNavigationBar(), // Trang chính với bottom navigation
        "/product": (context) =>
            ProductPage(product: Product()), // Pass a default Product instance
        "/notifications": (context) => NotificationPage(),
        // "/register": (context) => SignUp()
      },
      initialRoute: "/login", // Định nghĩa trang bắt đầu khi ứng dụng chạy
    );
  }
}
*/