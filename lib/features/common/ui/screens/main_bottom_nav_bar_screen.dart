import 'package:crafty_bay/features/cart/ui/screens/cart_screen.dart';
import 'package:crafty_bay/features/category/ui/screens/category_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../home/ui/screens/home_screen.dart';
import '../../../products/ui/controller/product_by_remark_controller.dart';
import '../../../wish_list/ui/screens/wish_list_screen.dart';
import '../../controllers/category_controller.dart';
import '../../controllers/main_bottom_nav_bar_controller.dart';
import '../../controllers/slider_controller.dart';

class MainBottomNavBarScreen extends StatefulWidget {
  const MainBottomNavBarScreen({super.key});

  static const String name = '/main-bottom-nav-bar';

  @override
  State<MainBottomNavBarScreen> createState() => _MainBottomNavBarScreenState();
}

class _MainBottomNavBarScreenState extends State<MainBottomNavBarScreen> {
  final List<Widget> _screens = const [
    HomeScreen(),
    CategoryListScreen(),
    CartScreen(),
    WishListScreen(),
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<SliderController>().getSlider();
      Get.find<CategoryController>().getCategoryList();
      Get.find<ProductByRemarkController>().getProductByRemark('popular');
      Get.find<ProductByRemarkController>().getProductByRemark('special');
      Get.find<ProductByRemarkController>().getProductByRemark('new');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MainBottomNavBarController>(
        builder: (controller) => _screens[controller.selectedIndex],
      ),
      bottomNavigationBar: GetBuilder<MainBottomNavBarController>(
        builder: (controller) =>
         BottomNavigationBar(
          currentIndex: controller.selectedIndex,
          onTap: controller.changeIndex,
          selectedItemColor: Theme
              .of(context)
              .primaryColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: 'Category'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: 'Cart'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border), label: 'Wish list'),
          ],
        ),
      ),
    );
  }

}
