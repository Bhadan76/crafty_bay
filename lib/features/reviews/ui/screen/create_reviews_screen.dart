import 'package:cached_network_image/cached_network_image.dart';
import 'package:crafty_bay/core/widgets/center_circular_progress_indicator.dart';
import 'package:crafty_bay/core/widgets/show_snackbar_message.dart';

import 'package:crafty_bay/features/auth/ui/controllers/auth_controller.dart';
import 'package:crafty_bay/features/reviews/ui/controller/create_review_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateReviewsScreen extends StatefulWidget {
  const CreateReviewsScreen({
    super.key,
    this.productId,
    this.productTitle,
    this.productImage,
  });

  final String? productId;
  final String? productTitle;
  final String? productImage;

  static const String name = '/create-review';

  @override
  State<CreateReviewsScreen> createState() => _CreateReviewsScreenState();
}

class _CreateReviewsScreenState extends State<CreateReviewsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _reviewTEController = TextEditingController();

  late String _productId;
  String? _productTitle;
  String? _productImage;

  int _rating = 5;

  @override
  void initState() {
    super.initState();
    // Resolve arguments passed via constructor or Get.arguments
    final dynamic args = Get.arguments;
    if (args is Map<String, dynamic>) {
      _productId = widget.productId ?? args['productId'] ?? '';
      _productTitle = widget.productTitle ?? args['productTitle'];
      _productImage = widget.productImage ?? args['productImage'];
    } else if (args is String) {
      _productId = widget.productId ?? args;
    } else {
      _productId = widget.productId ?? '';
    }

    // Pre-fill user info if available
    final user = AuthController.user;
    if (user != null) {
      final names = user.fullName.trim().split(' ');
      if (names.isNotEmpty) {
        _firstNameTEController.text = names.first;
        if (names.length > 1) {
          _lastNameTEController.text = names.sublist(1).join(' ');
        }
      }
    }
  }

  @override
  void dispose() {
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _reviewTEController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Create Review',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_productTitle != null && _productTitle!.isNotEmpty)
                _buildProductPreviewCard(),
              const SizedBox(height: 16),

              // Rating Selection Header
              const Text(
                'Overall Rating',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1A1A2E),
                ),
              ),
              const SizedBox(height: 8),
              _buildRatingBar(),
              const SizedBox(height: 24),

              // User Info Fields
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameTEController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        hintText: 'Enter first name',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameTEController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        hintText: 'Enter last name',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Review Content Field
              TextFormField(
                controller: _reviewTEController,
                textInputAction: TextInputAction.done,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Write Review',
                  hintText: 'Describe your experience with this product...',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your review description';
                  }
                  if (value.trim().length < 5) {
                    return 'Review must be at least 5 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Submit Button
              GetBuilder<CreateReviewController>(
                builder: (controller) {
                  return SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: !controller.inProgress,
                      replacement: const CenterCircularProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: () => _onTapSubmit(controller),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Submit Review',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductPreviewCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            if (_productImage != null && _productImage!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: _productImage!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
                  ),

                ),
              ),
            if (_productImage != null && _productImage!.isNotEmpty)
              const SizedBox(width: 12),
            Expanded(
              child: Text(
                _productTitle ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar() {
    final ratingTexts = [
      '1 Star - Very Poor',
      '2 Stars - Poor',
      '3 Stars - Average',
      '4 Stars - Good',
      '5 Stars - Excellent!',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starValue = index + 1;
              final bool isSelected = starValue <= _rating;

              return IconButton(
                iconSize: 36,
                onPressed: () {
                  setState(() {
                    _rating = starValue;
                  });
                },
                icon: Icon(
                  isSelected ? Icons.star_rounded : Icons.star_border_rounded,
                  color: isSelected ? Colors.amber : Colors.grey.shade400,
                ),
              );
            }),
          ),
          const SizedBox(height: 4),
          Text(
            ratingTexts[_rating - 1],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.amber,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onTapSubmit(CreateReviewController controller) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_productId.isEmpty) {
      showSnackBarMessage('Product ID is missing', true);
      return;
    }

    final bool isSuccess = await controller.createReview(
      productId: _productId,
      description: _reviewTEController.text.trim(),
      rating: _rating,
    );

    if (isSuccess) {
      showSnackBarMessage('Review submitted successfully!');
      Get.back(result: true);
    } else {
      showSnackBarMessage(
        controller.errorMessage ?? 'Failed to submit review',
        true,
      );
    }
  }
}
