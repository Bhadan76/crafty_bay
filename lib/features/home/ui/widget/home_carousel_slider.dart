import 'package:carousel_slider/carousel_slider.dart';
import 'package:crafty_bay/core/widgets/center_circular_progress_indicator.dart';
import 'package:crafty_bay/features/common/controllers/slider_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../../app/app_colors.dart';

class HomeCarouselSliderWidget extends StatefulWidget {
  const HomeCarouselSliderWidget({
    super.key,
  });

  @override
  State<HomeCarouselSliderWidget> createState() => _HomeCarouselSliderWidgetState();
}

class _HomeCarouselSliderWidgetState extends State<HomeCarouselSliderWidget> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SliderController>(
      builder: (sliderController) {
        return Visibility(
          visible: sliderController.inProgress == false,
          replacement: const SizedBox(
            height: 200,
            child: CenterCircularProgressIndicator(),
          ),
          child: Visibility(
            visible: sliderController.sliderList.isNotEmpty,
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    autoPlay: true,
                    viewportFraction: .9,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
                  items: sliderController.sliderList.map((slider) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: AppColors.primary,
                            image: DecorationImage(
                              image: NetworkImage(slider.image ?? ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              slider.description,
                              style: const TextStyle(fontSize: 16.0, color: Colors.white),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < sliderController.sliderList.length; i++)
                      Container(
                        height: 16,
                        width: 16,
                        margin: const EdgeInsets.only(left: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          shape: BoxShape.circle,
                          color: _current == i ? AppColors.primary : Colors.white,
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
