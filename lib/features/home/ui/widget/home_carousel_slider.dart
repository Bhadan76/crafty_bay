import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';

class HomeCarouselSlider_widget extends StatefulWidget {
  const HomeCarouselSlider_widget({
    super.key,
  });

  @override
  State<HomeCarouselSlider_widget> createState() => _HomeCarouselSlider_widgetState();
}

class _HomeCarouselSlider_widgetState extends State<HomeCarouselSlider_widget> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(height: 200.0,viewportFraction: .9,onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          }),
          items: [1,2,3,4,5].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: AppColors.primary
                    ),
                    child: Center(child: Text('text $i', style: TextStyle(fontSize: 16.0),))
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Row(
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
        )
      ],
    );

  }
}
