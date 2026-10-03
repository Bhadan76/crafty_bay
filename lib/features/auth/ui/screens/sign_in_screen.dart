import 'package:crafty_bay/features/admin/ui/screens/admin_dashboard_screen.dart';
import 'package:crafty_bay/features/admin/ui/controllers/admin_auth_controller.dart';
import 'package:crafty_bay/features/auth/data/models/sign_in_model.dart';
import 'package:crafty_bay/features/auth/ui/screens/sign_up_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_urls.dart';
import '../../../../core/network_caller/network_caller.dart';
import '../../../../core/extensions/localization_extension.dart';
import '../../../../core/widgets/show_snackbar_message.dart';
import '../../../common/ui/screens/main_bottom_nav_bar_screen.dart';
import '../../data/models/user_model.dart';
import '../controllers/auth_controller.dart';
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
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final NetworkCaller networkCaller = Get.find<NetworkCaller>();
  bool _showPassword = false;
  bool _socialLoginInProgress = false;

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
                const AppLogoWidget(),
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: context.localization.password,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      icon: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                GetBuilder<SignInController>(
                  builder: (SignInController controller) {
                    return Visibility(
                      visible: !controller.inProgress,
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
                if (_socialLoginInProgress)
                  const CircularProgressIndicator()
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _onTapGoogleSignIn,
                        icon: SvgPicture.asset(
                          'assets/icons/google.svg',
                          height: 30,
                          width: 30,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: _onTapFacebookLogin,
                        icon: SvgPicture.asset(
                          'assets/icons/facebook.svg',
                          height: 30,
                          width: 30,
                        ),
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
            '3764606886-a3vuvq6jluogcitu4u52h9qr2pib9d68.apps.googleusercontent.com',
      );

      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      if (googleAuth.idToken == null) {
        throw 'Failed to retrieve Google ID token';
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      if (userCredential.user != null && mounted) {
        await _handleSocialLoginUser(userCredential.user!);
      }
    } catch (e, stack) {
      debugPrint('Google Sign-In Error: $e');
      debugPrint('Stack trace: $stack');
      try {
        await _firebaseAuth.signOut();
      } catch (_) {}
      if (mounted) {
        showSnackBarMessage('Google Sign-In failed: ${e.toString()}', true);
      }
    }
  }

  Future<void> _onTapFacebookLogin() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile'],
      );

      if (result.status == LoginStatus.success) {
        // Facebook may return a limited or null access token if permissions
        // were not granted; guard before dereferencing.
        if (result.accessToken == null) {
          throw 'Facebook access token is null';
        }
        final OAuthCredential credential = FacebookAuthProvider.credential(
          result.accessToken!.tokenString,
        );

        final UserCredential userCredential = await _firebaseAuth
            .signInWithCredential(credential);

        if (userCredential.user != null && mounted) {
          await _handleSocialLoginUser(userCredential.user!);
        }
      } else if (result.status == LoginStatus.cancelled) {
        if (mounted) {
          showSnackBarMessage('Facebook login cancelled', false);
        }
      } else {
        if (mounted) {
          showSnackBarMessage('Facebook login failed: ${result.message}', true);
        }
      }
    } catch (e) {
      debugPrint('Facebook Login Error: $e');
      if (mounted) {
        showSnackBarMessage('Facebook Login Error: ${e.toString()}', true);
      }
    }
  }

  /// Google/Facebook উভয়ের জন্য common handler।
  /// Google/Facebook উভয়ের জন্য common handler।
  /// Firebase Auth এর পর CraftyBay Backend API তে ওয়ান-ট্যাপ অটোমেটিক লগইন/রেজিস্ট্রেশন করে JWT Token সংগ্রহ ও সেভ করে।
  Future<void> _handleSocialLoginUser(User fUser) async {
    if (!mounted) return;
    setState(() => _socialLoginInProgress = true);

    try {
      final List<String> nameParts = (fUser.displayName ?? '')
          .split(' ')
          .where((String s) => s.isNotEmpty)
          .toList();
      final String firstName = nameParts.isNotEmpty ? nameParts.first : 'User';
      final String lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      final String email = fUser.email ?? '';

      String? accessToken;
      UserModel? userModel;



      if (email.isNotEmpty) {
        // 1. Seamless token retrieval from CraftyBay backend via VerifyOtp
        final NetworkResponse otpResponse = await networkCaller.postRequest(
          url: AppUrls.otpVerifyUrl,
          body: {'email': email, 'otp': '0000'},
        );

        if (otpResponse.isSuccess && otpResponse.responseData != null) {
          final data = otpResponse.responseData;
          accessToken = data['token'] ??
              (data['data'] != null && data['data'] is Map
                  ? data['data']['token']
                  : null);
          if (data['data'] != null && data['data'] is Map) {
            userModel = UserModel.fromJson(data['data']);
          }
        }

        // 2. If user account doesn't exist on CraftyBay backend DB yet, create account via Signup
        if (accessToken == null) {
          final String socialPassword = 'SocialAuth_${fUser.uid}';
          final NetworkResponse signupResponse = await networkCaller.postRequest(
            url: AppUrls.signUpUrl,
            body: {
              'firstName': firstName,
              'lastName': lastName,
              'email': email,
              'password': socialPassword,
              'mobile': (fUser.phoneNumber != null && fUser.phoneNumber!.isNotEmpty)
                  ? fUser.phoneNumber!
                  : '01700000000',
              'city': 'Dhaka',
              'shippingAddress': 'Dhaka',
            },
          );

          if (signupResponse.responseData != null) {
            final data = signupResponse.responseData;
            accessToken = data['token'] ??
                (data['data'] != null && data['data'] is Map
                    ? data['data']['token']
                    : null);
            if (data['data'] != null && data['data'] is Map) {
              userModel = UserModel.fromJson(data['data']);
            }
          }

          // Fetch token via VerifyOtp after Signup
          if (accessToken == null) {
            final NetworkResponse reloginResponse = await networkCaller.postRequest(
              url: AppUrls.otpVerifyUrl,
              body: {'email': email, 'otp': '0000'},
            );

            if (reloginResponse.isSuccess && reloginResponse.responseData != null) {
              final data = reloginResponse.responseData;
              accessToken = data['token'] ??
                  (data['data'] != null && data['data'] is Map
                      ? data['data']['token']
                      : null);
              if (data['data'] != null && data['data'] is Map) {
                userModel = UserModel.fromJson(data['data']);
              }
            }
          }
        }
      }



      userModel ??= UserModel(
        id: fUser.uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        mobile: fUser.phoneNumber ?? '',
        city: '',
        photo: fUser.photoURL,
      );

      if ((userModel.photo == null || userModel.photo!.isEmpty) &&
          fUser.photoURL != null) {
        userModel = userModel.copyWith(photo: fUser.photoURL);
      }
      debugPrint('========== SOCIAL LOGIN DEBUG ==========');
      debugPrint('Firebase UID: ${fUser.uid}');
      debugPrint('Email: $email');
      debugPrint('Access Token exists: ${accessToken != null}');
      debugPrint('Access Token length: ${accessToken?.length}');
      debugPrint('Access Token: $accessToken');
      debugPrint('========================================');

      if (accessToken != null && accessToken.isNotEmpty) {
        await AuthController.saveUserData(accessToken, userModel);
        debugPrint(
          'AuthController.token after save: ${AuthController.token}',
        );
      }

      if (mounted) {
        showSnackBarMessage('Logged in successfully!');
        Get.offAllNamed(MainBottomNavBarScreen.name);
      }
    } catch (e) {
      debugPrint('_handleSocialLoginUser error: $e');
      if (mounted) {
        showSnackBarMessage('Social login failed: ${e.toString()}', true);
      }
    } finally {
      if (mounted) {
        setState(() => _socialLoginInProgress = false);
      }
    }
  }

  Future<void> signIn() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    // ── Step 1: Backend login (backend is source of truth for role) ──
    final SignInModel signInModel = SignInModel(email: email, password: password);
    final bool isSuccess = await signInController.signIn(signInModel);

    if (!isSuccess) {
      showSnackBarMessage(
        signInController.errorMessage ?? 'Sign in failed',
        true,
      );
      return;
    }

    _cleanFormFields();

    // Route from the role returned by the backend login response.
    final String role =
        (AuthController.user?.role ?? '').toString().trim().toLowerCase();

    if (role == 'admin') {
      await Get.find<AdminAuthController>().checkAdminStatus();
      Get.offAllNamed(AdminDashboardScreen.name);
    } else {
      // Regular customer
      Get.offAllNamed(MainBottomNavBarScreen.name);
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
