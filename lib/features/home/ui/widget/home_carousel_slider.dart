import 'package:carousel_slider/carousel_slider.dart';
import 'package:crafty_bay/core/widgets/center_circular_progress_indicator.dart';
import 'package:crafty_bay/features/common/controllers/slider_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

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
    return GetBuilder<SliderController>(
      builder: (SliderController) {
        return Visibility(
          visible:  SliderController.inProgress == false,
          replacement: SizedBox(
            height: 200,
              child: CenterCircularProgressIndicator()
          ),
          child: Visibility(
            visible: SliderController.sliderList.isNotEmpty,
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(height: 200.0,
                      autoPlay: true,
                      viewportFraction: .9,onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
                  items: SliderController.sliderList.map((slider) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: AppColors.primary,
                                image: DecorationImage(
                                    image: NetworkImage(slider.image ?? ''),
                                    fit: BoxFit.cover),
                              ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(slider.description, style: TextStyle(fontSize: 16.0,color: Colors.white),),
                            )
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for(int i=0;i<SliderController.sliderList.length;i++)
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
            ),
          ),
        );
      }
    );

  }
}
