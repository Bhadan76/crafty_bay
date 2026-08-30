import 'package:crafty_bay/app/app_colors.dart';
import 'package:crafty_bay/core/widgets/center_circular_progress_indicator.dart';
import 'package:crafty_bay/core/widgets/show_snackbar_message.dart';
import 'package:crafty_bay/features/common/controllers/add_to_cart_controller.dart';
import 'package:crafty_bay/features/products/ui/controller/product_details_controller.dart';
import 'package:crafty_bay/features/products/widget/color_picker_widget.dart';
import 'package:crafty_bay/features/products/widget/increment_decrement_count_widget.dart';
import 'package:crafty_bay/features/products/widget/product_details_carousel_slider.dart';
import 'package:crafty_bay/features/products/widget/size_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

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
  final AddToCartController _addToCartController =
      Get.find<AddToCartController>();
  String? _selectedColor;
  String? _selectedSize;

  @override
  void initState() {
    super.initState();
    _productDetailsController.getProductDetails(widget.productId);
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
                  print(value);
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
              Card(
                color: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.favorite_border,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
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
                'Price',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              Text(
                '\$1000',
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
            child: GetBuilder<AddToCartController>(
              init: _addToCartController,
              builder: (controller) {
                return Visibility(
                  visible:controller.inProgress == false,
                  replacement: CenterCircularProgressIndicator(),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (isColorAvailable && _selectedColor == null) {
                        ShowSnackBarMessage('Please select your color', true);
                        return;
                      }
                      if (isSizeAvailable && _selectedSize == null) {
                        ShowSnackBarMessage('Please select your size', true);
                        return;
                      }

                      bool isSuccess = await _addToCartController.getAddToCartProduct(
                        _productDetailsController.product.id,
                        _selectedColor!,
                        _selectedSize!,
                      );
                      if (isSuccess) {
                        ShowSnackBarMessage('Product Added To Cart');
                      } else {
                        ShowSnackBarMessage(
                            _addToCartController.errorMessage ?? 'Something went wrong');
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
