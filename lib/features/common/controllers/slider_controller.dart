import 'package:crafty_bay/app/app_urls.dart';
import 'package:crafty_bay/core/network_caller/network_caller.dart';
import 'package:crafty_bay/features/common/data/model/slider_model.dart';
import 'package:get/get.dart';


import 'package:logger/logger.dart';

class SliderController extends GetxController{
  final Logger _logger = Logger();
  bool _inProgress = false;
  bool get inProgress => _inProgress;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<SliderModel> _sliderList = [];
  List<SliderModel> get sliderList => _sliderList;

  Future<bool> getSlider() async{
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await Get.find<NetworkCaller>().getRequest(url: AppUrls.sliderUrl);
    _logger.i('Slider API Response Status: ${response.responseCode}');
    if(response.isSuccess){
      List<SliderModel> list = [];
      final data = response.responseData;
      if (data != null && data['data'] != null) {
        for(Map<String, dynamic> item in data['data']){
          list.add(SliderModel.formJson(item));
        }
      }
      _sliderList = list;
      isSuccess = true;
      _errorMessage = null;
    }else{
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;

  }
}