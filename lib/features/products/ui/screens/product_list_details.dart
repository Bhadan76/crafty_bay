import 'package:crafty_bay/app/app_colors.dart';
import 'package:crafty_bay/core/widgets/center_circular_progress_indicator.dart';
import 'package:crafty_bay/core/widgets/show_snackbar_message.dart';
import 'package:crafty_bay/features/cart/ui/controller/product_add_to_cart_controller.dart';
import 'package:crafty_bay/features/products/ui/controller/product_details_controller.dart';
import 'package:crafty_bay/features/products/widget/color_picker_widget.dart';
import 'package:crafty_bay/features/products/widget/increment_decrement_count_widget.dart';
import 'package:crafty_bay/features/products/widget/product_details_carousel_slider.dart';
import 'package:crafty_bay/features/products/widget/size_picker_widget.dart';
import 'package:crafty_bay/features/wish_list/ui/controller/add_to_wish_list_controller.dart';
import 'package:crafty_bay/features/wish_list/ui/controller/wish_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../auth/ui/controllers/auth_controller.dart';
import '../../../auth/ui/screens/sign_in_screen.dart';

class ProductListDetails extends StatefulWidget {
  const ProductListDetails({super.key, required this.productId});

  final String productId;

  static const String name = '/product-details';

  @override
  State<ProductListDetails> createState() => _ProductListDetailsState();
}

class _ProductListDetailsState extends State<ProductListDetails> {
  final ProductDetailsController _productDetailsController =
      Get.find<ProductDetailsController>();
  final ProductAddToCartController _productAddToCartController =
      Get.find<ProductAddToCartController>();
  String? _selectedColor;
  String? _selectedSize;
  int _quantity = 1;


  @override
  void initState() {
    super.initState();
    _productDetailsController.getProductDetails(widget.productId);
    if (AuthController.token != null) {
      Get.find<WishListController>().getWishList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: GetBuilder<ProductDetailsController>(
        builder: (controller) {
          if (controller.inProgress) {
            return const CenterCircularProgressIndicator();
          }
          if (controller.errorMessage != null) {
            return Center(child: Text(controller.errorMessage!));
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                ProductDetailsCarouselSlider(
                  imageList: controller.product.images,
                ),
                _buildProductDetails(controller),
                SizedBox(height: 100.h,),
                _buildPriceAndAddToCartSection(controller.product.sizes.isNotEmpty,controller.product.colors.isNotEmpty),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductDetails(ProductDetailsController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  controller.product.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              IncrementDecrementCountWidget(
                onChanged: (int value) {
                  _quantity = value;
                },
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Wrap(
                children: [
                  const Icon(Icons.star, size: 18, color: Colors.orange),
                  Text(controller.product.rating),
                ],
              ),
              const SizedBox(width: 10),
              Text(
                'Reviews',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              GetBuilder<WishListController>(
                builder: (wishListController) {
                  final bool isWishlisted = wishListController.wishList.any((e) => e.id == widget.productId);
                  
                  return GetBuilder<AddToWishListController>(
                    builder: (addToWishListController) {
                      return Visibility(
                        visible: addToWishListController.inProgress == false,
                        replacement: const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            if (AuthController.token == null) {
                              Get.toNamed(SignInScreen.name);
                              return;
                            }
                            
                            bool isSuccess;
                            if (isWishlisted) {
                              isSuccess = await addToWishListController.removeFromWishList(widget.productId);
                              if (isSuccess) {
                                showSnackBarMessage('Removed from wish list');
                                wishListController.getWishList(); // Refresh the list
                              }
                            } else {
                               isSuccess = await addToWishListController.addToWishList(widget.productId);
                              if (isSuccess) {
                                showSnackBarMessage('Added to wish list');
                                wishListController.getWishList(); // Refresh the list
                              }
                            }
                            
                            if (!isSuccess) {
                              showSnackBarMessage(addToWishListController.errorMessage ?? 'Action failed', true);
                            }
                          },
                          child: Card(
                            color: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Icon(
                                isWishlisted ? Icons.favorite : Icons.favorite_border,
                                size: 14,
                                color: isWishlisted ? Colors.yellow[50] : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  );
                }
              ),
            ],
          ),
          const SizedBox(height: 16),
          ColorPickerWidget(
            colors: controller.product.colors,
            onColorSelected: (String selectedColor) {
              _selectedColor = selectedColor;
            },
          ),
          const SizedBox(height: 16),
          SizePickerWidget(
            sizes: controller.product.sizes,
            onSizeSelected: (String selectedSize) {
              _selectedSize = selectedSize;
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            controller.product.description,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceAndAddToCartSection(
    bool isSizeAvailable,
    bool isColorAvailable,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
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
                'Price',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              Text(
                '\$${_productDetailsController.product.price}',
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
            child: GetBuilder<ProductAddToCartController>(
              builder: (controller) {
                return Visibility(
                  visible: controller.inProgress == false,
                  replacement: const CenterCircularProgressIndicator(),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (AuthController.token == null) {
                        Get.toNamed(SignInScreen.name);
                        return;
                      }
                      if (isColorAvailable && _selectedColor == null) {
                        showSnackBarMessage('Please select your color', true);
                        return;
                      }
                      if (isSizeAvailable && _selectedSize == null) {
                        showSnackBarMessage('Please select your size', true);
                        return;
                      }

                      bool isSuccess = await _productAddToCartController.addToCart(
                        _productDetailsController.product.id,
                        _selectedColor!,
                        _selectedSize!,
                        _quantity,
                      );
                      if (isSuccess) {
                        showSnackBarMessage('Product Added To Cart');
                      } else {
                        showSnackBarMessage(
                            controller.errorMessage ?? 'Something went wrong');
                      }
                    },
                    child: const Text('Add to Cart'),
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
