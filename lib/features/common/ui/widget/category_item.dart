import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 8),
          color: AppColors.primary.withOpacity(0.15),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Icon(
              Icons.computer,
              size: 48,
              color: AppColors.primary,
            ),
          ),
        ),
        Text(
          'Computers',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
