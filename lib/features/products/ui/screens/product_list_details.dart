import 'package:crafty_bay/app/app_colors.dart';
import 'package:crafty_bay/features/products/widget/color_picker_widget.dart';
import 'package:crafty_bay/features/products/widget/increment_decrement_count_widget.dart';
import 'package:crafty_bay/features/products/widget/product_details_carousel_slider.dart';
import 'package:crafty_bay/features/products/widget/size_picker_widget.dart';
import 'package:flutter/material.dart';


class ProductListDetails extends StatefulWidget {
  const ProductListDetails({super.key});

  static const String name = '/product-details';

  @override
  State<ProductListDetails> createState() => _ProductListDetailsState();
}

class _ProductListDetailsState extends State<ProductListDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Details')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProductDetailsCarouselSlider(),
            _buildProductDetails(),
          ],
        ),
      ),
      bottomNavigationBar: _buildPriceAndAddToCartSection(),
    );
  }

  Widget _buildProductDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Nike 320 2025 new edition',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
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
                  Icon(Icons.star, size: 18, color: Colors.orange),
                  Text('3.5'),
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
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
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
            colors: ['red', 'blue', 'orange', 'black', 'white'],
            onColorSelected: (String value) {
              print(value);
            },
          ),
          const SizedBox(height: 16),
          SizePickerWidget(
            sizes: ['S', 'M', 'L', 'XL'],
            onSizeSelected: (String value) {
              print(value);
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text('''Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.''',style: TextStyle(color: Colors.grey.shade600),)
        ],
      ),
    );
  }

  Widget _buildPriceAndAddToCartSection() {
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
            child: ElevatedButton(
              onPressed: () {

              },
              child: const Text('Add to Cart'),
            ),
          ),
        ],
      ),
    );
  }
}
