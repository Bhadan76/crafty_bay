import 'package:flutter/material.dart';

class SelectionHeader extends StatelessWidget {
  const SelectionHeader({
    super.key, required this.name, required this.onPressed,
  });
  final String name;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(name,style: TextTheme.of(context).bodyLarge!.copyWith(fontSize: 24),),
        TextButton(onPressed: onPressed, child: Text('See All',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),))
      ],
    );
  }
}
