class Config {
  static const String appName = "Furniture APP";
  static const String apiURL = "10.0.2.2:3000";
  //static const String apiURL = "172.16.20.33:3000";
  static const String registerAPI = "api/auth/register";
  static const String loginAPI = "api/auth/login";
  static const String CartAPI = "api/v1/cart";
  static const String listProductAPI = "api/v1/getallproduct";
  static const String listCategoryAPI = "api/v1/getAllCategories";
  static const String listProductByCategoryAPI =
      "api/v1/getproductbycategory"; // Đảm bảo endpoint này khớp với backend
  static const String updateCartAPI =
      "api/v1/cart"; // Assuming the same endpoint for update
  static const String deleteCartAPI =
      "api/v1/cart"; // Assuming the same endpoint for delete
  static const String addressAPI = "api/v1/address";
  static const String cardAPI =
      "api/v1/card"; // Add this line for card operations
  static const String checkoutAPI =
      "api/v1/checkout"; // Add this line for checkout operations
}
