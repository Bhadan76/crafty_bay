
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<SliderController>().getSlider();
    });
  }

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
              _buildProductSection(),
              const SizedBox(height: 16),
              SelectionHeader(name: 'Special', onPressed: () {}),
              const SizedBox(height: 16),
              _buildProductSection(),
              const SizedBox(height: 16),
              SelectionHeader(name: 'New', onPressed: () {}),
              const SizedBox(height: 16),
              _buildProductSection(),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CategoryItem(),
          CategoryItem(),
          CategoryItem(),
          CategoryItem(),
          CategoryItem(),
        ],
      ),
    );
  }

  Widget _buildProductSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ProductCard(),
          ProductCard(),
          ProductCard(),
          ProductCard(),
          ProductCard(),
        ],
      ),
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

