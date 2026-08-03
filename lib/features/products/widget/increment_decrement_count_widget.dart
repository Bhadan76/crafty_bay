import 'package:flutter/material.dart';

import 'count_button_widget.dart';

class IncrementDecrementCountWidget extends StatefulWidget {
  const IncrementDecrementCountWidget({super.key, required this.onChanged});
  final Function(int) onChanged ;

  @override
  State<IncrementDecrementCountWidget> createState() => _IncrementDecrementCountWidgetState();
}

class _IncrementDecrementCountWidgetState extends State<IncrementDecrementCountWidget> {
  int count = 1;
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
            },
            child: CountButtonWidget(icon: Icons.remove)),
        Text(count.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
        GestureDetector(
            onTap: (){
              if(count > 20) return;
              setState(() {
                count++;
              });
            },
            child: CountButtonWidget(icon: Icons.add)),
      ],
    );
  }
}

