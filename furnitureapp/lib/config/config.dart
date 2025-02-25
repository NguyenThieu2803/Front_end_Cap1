class Config {
  static const String appName = "Furniture APP";
  static const String apiURL = "10.0.2.2:3000";

  // static const String apiURL = "10.0.2.2:3000";
  // static const String apiURL = "192.168.5.104:3000";
  // static const String apiURL = "192.168.100.228:3000";
  // static const String apiURL = "127.0.0.1:3000";
  // static const String apiURL = "172.20.59.122:3000";
  //static const String apiURL = "172.16.20.238:3000";
  static const String registerAPI = "api/auth/register";
  static const String loginAPI = "api/auth/login";
  static const String profileAPI = "/api/auth/users/profile";
  static const String CartAPI = "api/v1/cart";
  static const String listProductAPI = "api/v1/getallproduct";
  static const String listCategoryAPI = "api/v1/getAllCategories";
  static const String listProductByCategoryAPI ="api/v1/getproductbycategory"; 
  static const String updateCartAPI = "api/v1/cart"; 
  static const String deleteCartAPI ="api/v1/cart"; 
  static const String addressAPI = "api/v1/address";
  static const String cardAPI = "api/v1/card"; 
  static const String checkoutAPI = "api/v1/checkout"; 
  static const String reviewByProductAPI = "api/v1/getReviewByProduct";
  static const String searchProductAPI = "api/v1/search";
  static const String userOrderAPI = "api/v1/checkout";
  static const String wishlistAPI="api/v1/wishlist";
  static const String deliveredOrdersAPI = "api/v1/orders/delivered";
  static const String createReviewAPI = "api/v1/createReview";
  static const String socialLoginAPI = "api/v1/social-login";
  static const String updateAvatarAPI = "api/auth/users/avatar";
  static const firebaseConfig = {
    'apiKey': 'AIzaSyD-bHXKm07yzCW-3XjuwY6RaM7UDaGOdY0',
    'appId': 'furniturear-4bdfe',
    'messagingSenderId': '988148291538',
    'projectId': '988148291538',
  }; // Add Firebase config
}
