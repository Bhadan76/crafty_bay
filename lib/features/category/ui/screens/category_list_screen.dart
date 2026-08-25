import 'package:crafty_bay/core/widgets/center_circular_progress_indicator.dart';
import 'package:crafty_bay/features/common/controllers/category_controller.dart';
import 'package:crafty_bay/features/common/ui/widget/category_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../common/controllers/main_bottom_nav_bar_controller.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final CategoryController categoryController = Get.find<CategoryController>();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
   _scrollController.addListener(_loadMoreData);
  }
  void _loadMoreData(){
    if(_scrollController.position.extentAfter < 300){
       categoryController.getCategoryList();
    }
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_ , __){
        Get.find<MainBottomNavBarController>().backToHome();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {
            Get.find<MainBottomNavBarController>().backToHome();
          }, icon: Icon(Icons.arrow_back_ios)),
          title: Text(
            'Categories',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: GetBuilder<CategoryController>(
          builder: (controller) {
            if (controller.inProgress) {
              return const CenterCircularProgressIndicator();
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        controller.refreshLoading();
                      },
                      child: GridView.builder(
                        itemCount: controller.categoryList.length,
                        controller: _scrollController,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 16,
                        ),
                        itemBuilder: (context, index) {
                          return FittedBox(
                            child: CategoryItem(
                              categoryModel: controller.categoryList[index],
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
      ),
    );
  }
}
