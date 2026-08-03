import 'package:crafty_bay/app/app_colors.dart';
import 'package:flutter/material.dart';

class ColorPickerWidget extends StatefulWidget {
  const ColorPickerWidget({super.key, required this.colors, required this.onColorSelected});
  final List<String> colors;
  final Function(String) onColorSelected;


  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  String? selectedColor;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text('Color',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.colors.length,
              itemBuilder: (context,index){
              String color = widget.colors[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColor = color;
                  });
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  margin: EdgeInsets.only(right: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                    color: selectedColor == color ? AppColors.primary : null,
                  ),
                  child: Text(color,style: TextStyle(
                    color: selectedColor == color ? Colors.white : null,
                  ),),
                ),
              );
          }),
        )
      ],
    );
  }
}
