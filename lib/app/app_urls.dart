class AppUrls {
  static const String _baseUrl = 'https://crafty-bay-app-api.onrender.com';
  static const String signUpUrl = '$_baseUrl/Signup';
  static const String signInUrl = '$_baseUrl/UserLogin';
  static const String otpVerifyUrl = '$_baseUrl/VerifyOtp';
  static const String sliderUrl = '$_baseUrl/ListProductSlider';
  static const String categoryUrl = '$_baseUrl/CategoryList';
  static String productListUrl(String categoryId) => '$_baseUrl/ListProductByCategory/$categoryId';
  static String productDetailsUrl(String productId) => '$_baseUrl/ProductDetailsById/$productId';
  static String addToCartUrl = '$_baseUrl/AddToCart';
  static String productByRemarkUrl(String remark) => '$_baseUrl/ListProductByRemark/$remark';
}
