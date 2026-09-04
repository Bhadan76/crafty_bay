import 'package:crafty_bay/features/auth/data/models/sign_in_model.dart';
import 'package:crafty_bay/features/auth/ui/screens/sign_up_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/extensions/localization_extension.dart';
import '../../../../core/widgets/show_snackbar_message.dart';
import '../../../common/ui/screens/main_bottom_nav_bar_screen.dart';
import '../controllers/sign_in_controller.dart';
import '../widget/app_logo_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const String name = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  SignInController signInController = Get.find<SignInController>();

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
              children: <Widget>[
                const SizedBox(height: 100),
                app_logo_widget(),
                const SizedBox(height: 24),
                Text(
                  context.localization.welcome_back,
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  context.localization.enter_your_email_and_password,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
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
                  controller: _passwordController,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: context.localization.password,
                    suffixIcon: Icon(Icons.remove_red_eye_outlined),
                  ),
                  validator: (String? value) {
                    if ((value?.length ?? 0) < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                GetBuilder<SignInController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.inProgress == false,
                      replacement: CircularProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: _onTapSignInButton,
                        child: Text(context.localization.sign_in),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                RichText(
                  text: TextSpan(
                    text: context.localization.dont_have_an_account,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                    children: [
                      TextSpan(
                        text: context.localization.sign_up,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _onTapSignUp,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: .center,
                  children: [
                    IconButton(
                      onPressed: _onTapGoogleSignIn,
                      icon: SvgPicture.asset('assets/icons/google.svg', height: 30, width: 30),
                    ),
                    const SizedBox(width: 10,),
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset('assets/icons/facebook.svg',height: 30,width: 30),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _onTapSignInButton() {
    if (_formKey.currentState!.validate()) {
      signIn();
    }
  }

  Future<void> _onTapGoogleSignIn() async {
    try {
      await GoogleSignIn.instance.initialize(
        serverClientId:
            '876119500188-01vghj87abg2re1cqrokmupgn6h0mvnj.apps.googleusercontent.com',
      );
      final googleUser = await GoogleSignIn.instance.authenticate();
      if (googleUser == null) {
        return;
      }
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null && mounted) {
        Get.offAllNamed(MainBottomNavBarScreen.name);
      }
    } catch (e, stack) {
      debugPrint('Google Sign-In Error: $e');
      debugPrint('Stack trace: $stack');
      if (mounted) {
        ShowSnackBarMessage('Google Sign-In failed: ${e.toString()}', true);
      }
    }
  }

  Future<void> signIn() async {
    SignInModel signInModel = SignInModel(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    final bool isSuccess = await signInController.signIn(signInModel);
    if (isSuccess) {
      _cleanFormFields();
      Get.offAllNamed(MainBottomNavBarScreen.name);
    } else {
      ShowSnackBarMessage(
        signInController.errorMessage ?? 'Sign in failed',
        true,
      );
    }
  }

  void _onTapSignUp() {
    Get.toNamed(SignUpScreen.name);
  }

  void _cleanFormFields() {
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
