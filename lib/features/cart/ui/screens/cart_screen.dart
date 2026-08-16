import 'package:crafty_bay/app/assets_path.dart';
import 'package:crafty_bay/features/products/widget/increment_decrement_count_widget.dart';
import 'package:crafty_bay/features/reviews/ui/screen/reviews_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../../app/app_colors.dart';
import '../../../common/controllers/main_bottom_nav_bar_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  static final String name = '/cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        leading: IconButton(
          onPressed: () {
            Get.find<MainBottomNavBarController>().backToHome();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: ListView.builder(
        itemCount: 5,
        padding: const EdgeInsets.symmetric(vertical: 2),
        itemBuilder: (context, index) {
          return _buildCartItem();
        },
      ),
      bottomNavigationBar: _buildCheckoutSection(),
    );
  }

  Widget _buildCartItem() {
    return Container(
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
       child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Image.asset(
              AssetsPath.dummeShoePng,
              height: 100,
              width: 100,

            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Nike 320 2025 new edition',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete_outline, color: Colors.grey),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const Text(
                    'Color: Black   Size: M',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '\$1000',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IncrementDecrementCountWidget(
                        onChanged: (int value) {
                          print(value);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total Price',
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
              ),
              Text(
                '\$5000',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 140,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(ReviewsScreen.name);
              },
              child: const Text('Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}
