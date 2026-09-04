class AppUrls {
  static const String _baseUrl = 'https://crafty-bay-app-api.onrender.com';
  static const String signUpUrl = '$_baseUrl/Signup';
  static const String signInUrl = '$_baseUrl/UserLogin';
  static const String otpVerifyUrl = '$_baseUrl/VerifyOtp';
  static const String sliderUrl = '$_baseUrl/ListProductSlider';
  static const String categoryUrl = '$_baseUrl/CategoryList';
  static const String wishListUrl = '$_baseUrl/ProductWishList';
  static String productListUrl(String categoryId) => '$_baseUrl/ListProductByCategory/$categoryId';
  static String productDetailsUrl(String productId) => '$_baseUrl/ProductDetailsById/$productId';
  static String addToCartUrl = '$_baseUrl/AddToCart';
  static String CartListUrl = '$_baseUrl/CartList';
  static String productByRemarkUrl(String remark) => '$_baseUrl/ListProductByRemark/$remark';
}
