import 'package:crafty_bay/core/widgets/center_circular_progress_indicator.dart';
import 'package:crafty_bay/features/cart/data/model/cart_item_model.dart';
import 'package:crafty_bay/features/cart/ui/controller/cart_item_controller.dart';
import 'package:crafty_bay/features/products/widget/increment_decrement_count_widget.dart';
import 'package:crafty_bay/features/reviews/ui/screen/reviews_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CartItemController>().getCartList();
    });
  }

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
      body: GetBuilder<CartItemController>(builder: (controller) {
        // if (controller.inProgress) {
        //   return const CenterCircularProgressIndicator();
        // }

        if (controller.cartList.isEmpty) {
          return const Center(child: Text('Your cart is empty'));
        }

        return Visibility(
          visible: controller.inProgress == false,
          replacement: CenterCircularProgressIndicator(),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: controller.cartList.length,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  itemBuilder: (context, index) {
                    return _buildCartItem(controller.cartList[index]);
                  },
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: _buildCheckoutSection(),
    );
  }

  Widget _buildCartItem(CartItemModel cartItem) {
    return Container(
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Image.network(
                cartItem.productListModel?.images.first ?? '',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const Icon(Icons.error_outline, size: 50);
                },
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            cartItem.productListModel?.title ?? 'No Title',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
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
                    Text(
                      'Color: ${cartItem.color}   Size: ${cartItem.size}',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${cartItem.productListModel?.price ?? 0}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IncrementDecrementCountWidget(
                          initialValue: cartItem.quantity,
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
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return GetBuilder<CartItemController>(builder: (controller) {
      double totalPrice = 0;
      for (var item in controller.cartList) {
        totalPrice += (double.tryParse(item.productListModel?.price ?? '0') ?? 0) * item.quantity;
      }

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Total Price',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
                ),
                Text(
                  '\$$totalPrice',
                  style: const TextStyle(
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
    });
  }
}

