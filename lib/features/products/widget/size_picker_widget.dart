import 'package:crafty_bay/app/app_colors.dart';
import 'package:flutter/material.dart';

class SizePickerWidget extends StatefulWidget {
  const SizePickerWidget({super.key, required this.sizes, required this.onSizeSelected});
  final List<String> sizes;
  final Function(String) onSizeSelected;


  @override
  State<SizePickerWidget> createState() => _SizePickerWidgetState();
}

class _SizePickerWidgetState extends State<SizePickerWidget> {
  String? selectedSize;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text('Size',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.sizes.length,
              itemBuilder: (context,index){
              String color = widget.sizes[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedSize = color;
                  });
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  margin: EdgeInsets.only(right: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                    color: selectedSize == color ? AppColors.primary : null,
                  ),
                  child: Text(color,style: TextStyle(
                    color: selectedSize == color ? Colors.white : null,
                  ),),
                ),
              );
          }),
        )
      ],
    );
  }
}
