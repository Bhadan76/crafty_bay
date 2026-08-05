import 'package:crafty_bay/core/widgets/center_circular_progress_indicator.dart';
import 'package:crafty_bay/features/auth/data/models/sign_up_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/extensions/localization_extension.dart';
import '../../../../core/widgets/show_snackbar_message.dart';
import '../controllers/sign_up_controller.dart';
import '../widget/app_logo_widget.dart';
import 'otpVerify_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String name = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  SignUpController signUpController = Get.find<SignUpController>();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme
        .of(context)
        .textTheme;
    return Scaffold(
      body: _buildForm(textTheme),
    );
  }

  Widget _buildForm(TextTheme textTheme) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 64),
              app_logo_widget(),
              const SizedBox(height: 24),
              Text(
                context.localization.register_your_account,
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                context.localization.get_started_with_your_details,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _firstNameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: context.localization.first_name,
                ),
                validator: (String? value) {
                  if (value
                      ?.trim()
                      .isEmpty ?? true) {
                    return 'Enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lastNameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: context.localization.last_name,
                ),
                validator: (String? value) {
                  if (value
                      ?.trim()
                      .isEmpty ?? true) {
                    return 'Enter your last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: context.localization.email,
                ),
                validator: (String? value) {
                  String email = value ?? '';
                  if (!EmailValidator.validate(email)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: context.localization.phone,
                ),
                validator: (String? value) {
                  String phone = value ?? '';
                  final RegExp bdPhoneRegex = RegExp(
                      r'^(?:\+88|88)?01[3-9]\d{8}$');
                  if (!bdPhoneRegex.hasMatch(phone)) {
                    return 'Enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                textInputAction: TextInputAction.next,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: context.localization.password,
                  suffixIcon: Icon(Icons.remove_red_eye_outlined),
                ),
                validator: (String? value) {
                  if (value?.isEmpty ?? 0 <= 6) {
                    return 'Enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                minLines: 4,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: context.localization.delivery_address,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                ),
                validator: (String? value) {
                  if (value
                      ?.trim()
                      .isEmpty ?? true) {
                    return 'Enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              GetBuilder<SignUpController>(
                builder: (controller) {
                  return Visibility(
                    visible: controller.inProgress == false,
                    replacement: CenterCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapSignUpButton,
                      child: Text(context.localization.sign_up),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16,),
              RichText(text: TextSpan(
                  text: context.localization.already_have_an_account,
                  style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.grey,),
                  children: [
                    TextSpan(
                        text: context.localization.sign_in,
                        style: TextStyle(fontWeight: FontWeight.w600,
                            color: AppColors.primary),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _onTapSignInButton
                    ),
                  ]
              )),

            ],
          ),
        ),
      ),
    );
  }

  void _onTapSignUpButton() {
    if (_formKey.currentState!.validate()) {
      signUp();
    }
  }

  Future<void> signUp() async {
    SignUpModel signUpModel = SignUpModel(firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        address: _addressController.text.trim()
    );
    final bool isSuccess = await signUpController.signUp(signUpModel);
    if(isSuccess){
      _cleanFormFields();
      Get.offAllNamed(OtpVerifyScreen.name);
    }else{
      ShowSnackBarMessage(signUpController.errorMessage!,true);
     }
  }

  void _onTapSignInButton() {
    Get.back();
  }
  void _cleanFormFields() {
    _emailController.clear();
    _passwordController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _phoneController.clear();
    _addressController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
  }
}
