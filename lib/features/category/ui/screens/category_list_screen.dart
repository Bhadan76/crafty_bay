import 'package:crafty_bay/features/common/ui/widget/category_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../../common/controllers/main_bottom_nav_bar_controller.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_ , __){
        Get.find<MainBottomNavBarController>().backToHome();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {
            Get.find<MainBottomNavBarController>().backToHome();
          }, icon: Icon(Icons.arrow_back_ios)),
          title: Text(
            'Categories',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: 15,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              return FittedBox(child: CategoryItem());
            },
          ),
        ),
      ),
    );
  }
}
