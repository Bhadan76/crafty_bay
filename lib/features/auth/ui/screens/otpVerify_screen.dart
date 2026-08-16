import 'dart:async';

import 'package:crafty_bay/core/widgets/center_circular_progress_indicator.dart';
import 'package:crafty_bay/features/auth/data/models/otp_verify_model.dart';
import 'package:crafty_bay/features/auth/ui/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/extensions/localization_extension.dart';
import '../../../../core/widgets/show_snackbar_message.dart';
import '../../../common/ui/screens/main_bottom_nav_bar_screen.dart';
import '../controllers/otp_verify_controller.dart';
import '../widget/app_logo_widget.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key, required this.email});

  final String email;

  static const String name = '/otp-verify';

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  OtpVerifyController otpVerifyController = Get.find<OtpVerifyController>();
  final RxInt _currentTime = 30.obs;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _currentTime.value = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTime.value == 0) {
        timer.cancel();
      } else {
        _currentTime.value--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 100),
                const app_logo_widget(),
                const SizedBox(height: 24),
                Text(
                  context.localization.enter_otp_code,
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  context.localization.a_4_digit_code_has_been_sent,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                PinCodeTextField(
                  length: 6,
                  appContext: context,
                  keyboardType: TextInputType.number,
                  controller: _otpController,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    activeColor: Theme.of(context).primaryColor,
                    selectedColor: Theme.of(context).primaryColor,
                    inactiveColor: Colors.grey,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  onCompleted: (v) {
                    _onTapVerifyButton();
                  },
                  onChanged: (value) {},
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your OTP';
                    }
                    if (value.length < 6) {
                      return 'Enter 6 digit OTP';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                GetBuilder<OtpVerifyController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.inProgress == false,
                      replacement: const CenterCircularProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: _onTapVerifyButton,
                        child: Text(context.localization.next),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Obx(() {
                  return Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.grey),
                          children: [
                            TextSpan(text: context.localization.this_code_will_expire_in),
                            TextSpan(
                              text: ' ${_currentTime.value}s',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: _currentTime.value == 0
                            ? () {
                                _startTimer();
                                // Add resend OTP API call here if needed
                              }
                            : null,
                        child: Text(
                          'Resend Code',
                          style: TextStyle(
                            color: _currentTime.value == 0
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapVerifyButton() {
    if (_formKey.currentState!.validate()) {
      verifyOTP();
    }
  }

  Future<void> verifyOTP() async {
    OtpVerifyModel otpVerifyModel = OtpVerifyModel(
      email: widget.email,
      otp: _otpController.text.trim(),
    );
    final bool isSuccess = await otpVerifyController.otpVerify(otpVerifyModel);
    if (isSuccess) {
      Get.offAllNamed(MainBottomNavBarScreen.name);
    } else {
      ShowSnackBarMessage(
        otpVerifyController.errorMessage ?? 'OTP verification failed',
        true,
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }
}
