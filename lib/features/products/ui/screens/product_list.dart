import 'package:crafty_bay/core/widgets/center_circular_progress_indicator.dart';
import 'package:crafty_bay/features/common/ui/widget/product_card.dart';
import 'package:crafty_bay/features/products/ui/controller/product_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key, required this.categoryId, required this.categoryName});

  final String categoryId;
  final String categoryName;
  static const String name = '/products';

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ProductListController _productListController = Get.find<ProductListController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _productListController.refreshLoading(widget.categoryId);
    });
    _scrollController.addListener(_loadData);
  }

  void _loadData(){
    if(_scrollController.position.extentAfter < 300){
      _productListController.getProductListCategory(widget.categoryId);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: GetBuilder<ProductListController>(
        builder: (controller) {
          if (controller.inProgress && controller.productList.isEmpty) {
            return const CenterCircularProgressIndicator();
          }
          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await controller.refreshLoading(widget.categoryId);
                  },
                  child: GridView.builder(
                    itemCount: controller.productList.length,
                    controller: _scrollController,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 4,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      return FittedBox(
                        child: ProductCard(
                          productListModel: controller.productList[index],
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
              ),
            ],
          );
        },
      ),
    );
  }
}
