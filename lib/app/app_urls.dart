class AppUrls {
  static const String _baseUrl = 'https://crafty-bay-app-api.onrender.com';
  static const String signUpUrl = '$_baseUrl/Signup';
  static const String signInUrl = '$_baseUrl/UserLogin';
  static const String otpVerifyUrl = '$_baseUrl/VerifyOtp';
  static const String sliderUrl = '$_baseUrl/ListProductSlider';
  static const String categoryUrl = '$_baseUrl/CategoryList';
  static String productListUrl(String categoryId) => '$_baseUrl/ListProductByCategory/$categoryId';
  static String productDetailsUrl(String productId) => '$_baseUrl/ProductDetailsById/$productId';
  static String removeCartItemUrl(String cartId) => '$_baseUrl/DeleteCartList/$cartId';
  static String addToWishListUrl(String productId) => '$_baseUrl/CreateWishList/$productId';
  static String removeWishListUrl(String productId) => '$_baseUrl/RemoveWishList/$productId';
  static const String wishListUrl = '$_baseUrl/ProductWishList';
  static const String addToCartUrl = '$_baseUrl/CreateCartList';
  static const String cartListUrl = '$_baseUrl/CartList';
  static const String createProfileUrl = '$_baseUrl/CreateProfile';
  static const String searchListUrl = '$_baseUrl/SearchProduct';
  static const String searchSuggestionsUrl = '$_baseUrl/SearchSuggestions';
  static String productByRemarkUrl(String remark) => '$_baseUrl/ListProductByRemark/$remark';
}
