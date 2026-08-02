import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/extensions/localization_extension.dart';
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
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body:_buildForm(textTheme),
    );
  }

 Widget _buildForm(TextTheme textTheme) {
    return Form(
      key: _formKey,
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
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _lastNameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: context.localization.last_name,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: context.localization.email,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: context.localization.phone,
                  ),
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
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _addressController,
                  textInputAction: TextInputAction.next,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: context.localization.delivery_address,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _onTapSignUpButton,
                  child: Text(context.localization.sign_up),
                ),
                const SizedBox(height: 16,),
                RichText(text: TextSpan(
                    text: context.localization.already_have_an_account,
                    style: TextStyle(fontWeight: FontWeight.w600,color: Colors.grey,),
                    children:[
                      TextSpan(
                          text: context.localization.sign_in,
                          style: TextStyle(fontWeight: FontWeight.w600,color: AppColors.primary),
                          recognizer: TapGestureRecognizer()..onTap = _onTapSignInButton
                      ),
                    ]
                )),

              ],
            ),
          ),
        ),
    );
  }

  void _onTapSignInButton (){
    Get.back();
  }
  void _onTapSignUpButton(){
    Get.offAllNamed(OtpVerifyScreen.name);
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
