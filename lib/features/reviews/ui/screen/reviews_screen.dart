import 'package:crafty_bay/features/reviews/ui/screen/create_reviews_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../../app/app_colors.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});
  static const String name = '/reviews';

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
      ),
      body: ListView.builder(
        itemCount: 3,
          itemBuilder: (context,index){
        return ListTile(
          leading: Icon(Icons.person_outline),
          title: Text('Bhadan paul',style: TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',style: TextStyle(color: Colors.grey.shade600),),
        );
      }),
     bottomNavigationBar: _buildReviewsSection(),
    );
  }
}

Widget _buildReviewsSection() {
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
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Reviews (1000)',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: AppColors.primary,
          onPressed: () {
            Get.toNamed(CreateReviewsScreen.name);
          } , child: Icon(Icons.add,color: Colors.white,),),
      ],
    ),
  );
}

