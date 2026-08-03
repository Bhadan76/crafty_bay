import 'package:flutter/material.dart';

import '../../../app/app_colors.dart';

class CountButtonWidget extends StatelessWidget {
  const CountButtonWidget({
    super.key, required this.icon,
  });
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(2),
      ),

      child: Icon(icon,color: Colors.white,),
    );
  }
}
