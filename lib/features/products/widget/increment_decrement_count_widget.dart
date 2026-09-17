import 'package:crafty_bay/features/products/ui/controller/product_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'count_button_widget.dart';

class IncrementDecrementCountWidget extends StatefulWidget {
  const IncrementDecrementCountWidget({super.key, required this.onChanged, this.initialValue = 1});
  final Function(int) onChanged ;
  final int initialValue;

  @override
  State<IncrementDecrementCountWidget> createState() => _IncrementDecrementCountWidgetState();
}

class _IncrementDecrementCountWidgetState extends State<IncrementDecrementCountWidget> {
  late int count;

  @override
  void initState() {
    super.initState();

    count = widget.initialValue;

  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      children: [
        GestureDetector(
            onTap: (){
              if(count <= 1) return;
              setState(() {
                count--;
              });
              widget.onChanged(count);
            },
            child: CountButtonWidget(icon: Icons.remove)),
        Text(count.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
        GestureDetector(
            onTap: (){
              if(count >= Get.find<ProductDetailsController>().product.stock) return;
              setState(() {
                count++;
              });
              widget.onChanged(count);
            },
            child: CountButtonWidget(icon: Icons.add)),
      ],
    );
  }
}

