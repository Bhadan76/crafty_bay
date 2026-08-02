
import 'package:crafty_bay/features/auth/ui/screens/sign_up_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../app/app_colors.dart';
import '../../../../core/extensions/localization_extension.dart';
import '../widget/app_logo_widget.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key});

  static const String name = '/otp-verify';

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                app_logo_widget(),
                const SizedBox(height: 24),
                Text(
                  context.localization.enter_otp_code,
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  context.localization.a_4_digit_code_has_been_sent,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),

                MaterialPinField(
                  length: 4,
                  onCompleted: (pin) => debugPrint('PIN: $pin'),
                  onChanged: (value) => debugPrint('Changed: $value'),
                  theme: MaterialPinTheme(
                    shape: MaterialPinShape.outlined,
                    cellSize: Size(56, 64),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    // FirebaseCrashlytics.instance.log('Entered sign in button');
                    // throw Exception('Something went wrong');
                  },
                  child: Text(context.localization.next),
                ),
                const SizedBox(height: 24),
                RichText(
                  text: TextSpan(
                    text: context.localization.this_code_will_expire_in,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                    children: [
                      TextSpan(
                        text: '120 ${context.localization.s}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),

                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(onPressed: () {}, child: Text('Resend Code')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignUp() {
    Get.offNamed(SignUpScreen.name);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
