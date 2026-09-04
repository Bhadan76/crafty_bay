import 'package:crafty_bay/features/auth/ui/controllers/auth_controller.dart';
import 'package:crafty_bay/features/auth/ui/screens/sign_in_screen.dart';
import 'package:crafty_bay/features/common/ui/widget/product_card.dart';
import 'package:crafty_bay/features/wish_list/ui/controller/wish_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/center_circular_progress_indicator.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  final WishListController wishListController = Get.find<WishListController>();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (AuthController.token != null) {
        wishListController.getWishList();
      }
    });
    _scrollController.addListener(_loadMoreData);
  }

  void _loadMoreData() {
    if (_scrollController.position.extentAfter < 300 && AuthController.token != null) {
      wishListController.getWishList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wish List',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: GetBuilder<WishListController>(
        builder: (controller) {
          if (AuthController.token == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Please login to see your wish list',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(SignInScreen.name);
                      },
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
            );
          }

          if (controller.inProgress && controller.wishList.isEmpty) {
            return const CenterCircularProgressIndicator();
          }

          if (controller.wishList.isEmpty) {
            return const Center(child: Text('Your wish list is empty'));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await controller.refreshLoading();
                    },
                    child: GridView.builder(
                      itemCount: controller.wishList.length,
                      controller: _scrollController,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 4,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        return FittedBox(
                          child: ProductCard(
                            productListModel: controller.wishList[index],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: controller.isLoadingMore,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
