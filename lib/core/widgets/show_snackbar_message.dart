import 'package:flutter/Material.dart';
import 'package:get/get.dart';

void ShowSnackBarMessage(String message ,[bool isError = false]){
  Get.snackbar(message,'', backgroundColor: isError ? Colors.red : null,snackPosition: SnackPosition.BOTTOM, );

}