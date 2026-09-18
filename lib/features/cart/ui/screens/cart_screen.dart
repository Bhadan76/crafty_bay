import 'package:crafty_bay/core/widgets/center_circular_progress_indicator.dart';
import 'package:crafty_bay/features/cart/data/model/cart_item_model.dart';
import 'package:crafty_bay/features/cart/ui/controller/cart_item_controller.dart';
import 'package:crafty_bay/features/cart/ui/screens/payment_gateway_screen.dart';
import 'package:crafty_bay/features/products/widget/increment_decrement_count_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../../app/app_colors.dart';
import '../../../common/controllers/main_bottom_nav_bar_controller.dart';
import '../controller/remove_cart_item_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  static final String name = '/cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CartItemController>().getCartList();
    });
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
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
        if (controller.inProgress == false && controller.cartList.isEmpty) {
          return const CenterCircularProgressIndicator();
        }

        if (controller.cartList.isEmpty) {
          return const Center(child: Text('Your cart is empty'));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.cartList.length,
                padding: const EdgeInsets.symmetric(vertical: 1),
                itemBuilder: (context, index) {
                  return _buildCartItem(controller.cartList[index], index);
                },
              ),
            ),
            _buildCouponSection(controller),
          ],
        );
      }),
      bottomNavigationBar: _buildCheckoutSection(),
    );
  }

  Widget _buildCouponSection(CartItemController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _couponController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Coupon Code',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(100, 45),
                ),
                onPressed: () async {
                  if (_couponController.text.trim().isNotEmpty) {
                    bool result = await controller.applyCoupon(_couponController.text.trim());
                    if (result) {
                      Get.snackbar('Success', 'Coupon applied successfully!', backgroundColor: Colors.green, colorText: Colors.white);
                    } else {
                      Get.snackbar('Error', controller.errorMessage ?? 'Failed to apply coupon', backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  }
                },
                child: const Text('Apply'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Outside Dhaka Shipping?'),
              Switch(
                value: controller.isOutsideDhaka,
                onChanged: (value) {
                  controller.toggleShippingLocation(value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildCartItem(CartItemModel cartItem, int index) {
    return Container(
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: _productItemCard(cartItem, index),
    );
  }

  Widget _productItemCard(CartItemModel cartItem, int index) {
    return Card(
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
              errorBuilder: (_, _, _) {
                return const Icon(Icons.error_outline, size: 50);
              },
            ),
            SizedBox(width: 12),
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
                      GetBuilder<RemoveCartItemController>(
                        builder: (controller) {
                          if (controller.isDeleting(cartItem.id)) {
                            return const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          }
                          return IconButton(
                            onPressed: () async {
                              bool result = await controller.getRemoveCartItem(cartItem.id);
                              if (result) {
                                Get.find<CartItemController>().getCartList();
                              }
                            },
                            icon: const Icon(Icons.delete_outline, color: Colors.grey),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          );
                        }
                      ),
                    ],
                  ),
                  Text(
                    'Color: ${cartItem.color}   Size: ${cartItem.size}',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '\$${cartItem.productListModel?.price ?? 0}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IncrementDecrementCountWidget(
                        initialValue: cartItem.quantity,
                        onChanged: (int value) {
                          Get.find<CartItemController>().changeQuantity(index, value);
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
    return GetBuilder<CartItemController>(builder: (controller) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPriceRow('Subtotal', controller.subtotal),
            _buildPriceRow('Shipping', controller.shippingCharge),
            if (controller.discountAmount > 0)
              _buildPriceRow('Discount', -controller.discountAmount),
            const Divider(),
            Row(
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
                      '\$${controller.totalPrice}',
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
                      Get.toNamed(PaymentGatewayScreen.name,
                          arguments: controller.totalPrice);
                    },
                    child: const Text('Checkout'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPriceRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text('\$$amount', style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

}

