
import 'package:crafty_bay/core/widgets/center_circular_progress_indicator.dart';
import 'package:crafty_bay/features/common/controllers/category_controller.dart';
import 'package:crafty_bay/features/products/ui/controller/product_by_remark_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../../../../app/assets_path.dart';
import '../../../common/controllers/main_bottom_nav_bar_controller.dart';
import '../../../common/controllers/slider_controller.dart';
import '../widget/app_bar_action_button.dart';
import '../../../common/ui/widget/category_item.dart';
import '../widget/home_carousel_slider.dart';
import '../../../common/ui/widget/product_card.dart';
import '../widget/selection_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTextField(),
              const SizedBox(height: 16),
              HomeCarouselSlider_widget(),
              const SizedBox(height: 16),
              SelectionHeader(name: 'Category', onPressed: () {
                Get.find<MainBottomNavBarController>().moveToCategory();
              }),
              const SizedBox(height: 16),
              _buildCategorySection(),
              const SizedBox(height: 16),
              SelectionHeader(name: 'Popular', onPressed: () {}),
              const SizedBox(height: 16),
              _buildProductSectionByRemark('popular'),
              const SizedBox(height: 16),
              SelectionHeader(name: 'Special', onPressed: () {}),
              const SizedBox(height: 16),
              _buildProductSectionByRemark('special'),
              const SizedBox(height: 16),
              SelectionHeader(name: 'New', onPressed: () {}),
              const SizedBox(height: 16),
              _buildProductSectionByRemark('new'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductSectionByRemark(String remark) {
    return GetBuilder<ProductByRemarkController>(builder: (controller) {
      if (controller.inProgress(remark)) {
        return const SizedBox(
          height: 100,
          child: CenterCircularProgressIndicator(),
        );
      }

      final products = remark == 'popular'
          ? controller.popularProducts
          : remark == 'special'
              ? controller.specialProducts
              : controller.newProducts;

      if (products.isEmpty) {
        return const SizedBox(
          height: 100,
          child: Center(child: Text('No products found')),
        );
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: products.map((e) {
            return ProductCard(productListModel: e);
          }).toList(),
        ),
      );
    });
  }

  Widget _buildCategorySection() {
    return GetBuilder<CategoryController>(
      builder: (controller) {
        if (controller.inProgress) {
          return const SizedBox(
            height: 90,
            child: CenterCircularProgressIndicator(),
          );
        }
        if (controller.categoryList.isEmpty) {
          return const SizedBox(
            height: 90,
            child: Center(child: Text('No categories found')),
          );
        }
        return SizedBox(
          height: 110,
          child: ListView.builder(
            itemCount: controller.categoryList.length > 6
                ? 6
                : controller.categoryList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return CategoryItem(categoryModel: controller.categoryList[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildTextField() {
    return TextField(
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: SvgPicture.asset(AssetsPath.logoNavSvg),
      actions: [
        AppBarActionButton(icon: Icons.person_outline, onTap: () {}),
        const SizedBox(width: 10),
        AppBarActionButton(icon: Icons.call, onTap: () {}),
        const SizedBox(width: 10),
        AppBarActionButton(
          icon: Icons.notifications_active_outlined,
          onTap: () {},
        ),
      ],
    );
  }
}

