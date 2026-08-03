import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';

class ProductDetailsCarouselSlider extends StatefulWidget {
  const ProductDetailsCarouselSlider({super.key});

  @override
  State<ProductDetailsCarouselSlider> createState() =>
      _ProductDetailsCarouselSliderState();
}

class _ProductDetailsCarouselSliderState
    extends State<ProductDetailsCarouselSlider> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 220.0,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              items: [1, 2, 3, 4, 5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey,
                      child: Center(
                        child: Text(
                          'image $i',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for(int i=0;i<5;i++)
                Container(
                  height: 16,
                  width: 16,
                  margin: EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      shape: BoxShape.circle,
                      color: _current == i ? AppColors.primary : Colors.white
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
