import 'package:crafty_bay/features/category/ui/screens/category_list_screen.dart';
import 'package:crafty_bay/features/common/controller/main_bottom_nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../home/ui/screens/home_screen.dart';

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
    HomeScreen(),
    HomeScreen(),
  ];

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
