import 'dart:io';

import 'package:crafty_bay/app/app_colors.dart';
import 'package:crafty_bay/features/auth/data/models/user_model.dart';
import 'package:crafty_bay/features/auth/ui/controllers/auth_controller.dart';
import 'package:crafty_bay/features/auth/ui/screens/sign_in_screen.dart';
import 'package:crafty_bay/features/cart/ui/controller/cart_item_controller.dart';
import 'package:crafty_bay/features/common/controllers/main_bottom_nav_bar_controller.dart';
import 'package:crafty_bay/features/wish_list/ui/controller/wish_list_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String name = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImageFile;
  static const String _profileImageKey = 'profile_image_path';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    await AuthController.getUserData();
    await _loadSavedProfileImage();
    if (AuthController.token != null) {
      if (Get.isRegistered<WishListController>()) {
        Get.find<WishListController>().getWishList();
      }
      if (Get.isRegistered<CartItemController>()) {
        Get.find<CartItemController>().getCartList();
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadSavedProfileImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? imagePath = prefs.getString(_profileImageKey);
    if (imagePath != null && File(imagePath).existsSync()) {
      if (mounted) {
        setState(() {
          _profileImageFile = File(imagePath);
        });
      }
    }
  }

  bool get _isLoggedIn {
    return AuthController.token != null ||
        AuthController.user != null ||
        FirebaseAuth.instance.currentUser != null;
  }

  UserModel? get _user => AuthController.user;
  User? get _firebaseUser => FirebaseAuth.instance.currentUser;

  String get _fullName {
    if (_user != null) {
      final name = '${_user!.firstName} ${_user!.lastName}'.trim();
      if (name.isNotEmpty) return name;
    }
    if (_firebaseUser?.displayName != null &&
        _firebaseUser!.displayName!.isNotEmpty) {
      return _firebaseUser!.displayName!;
    }
    if (_email.isNotEmpty && _email.contains('@')) {
      return _email.split('@')[0];
    }
    return 'CraftyBay User';
  }

  String get _email {
    if (_user?.email != null && _user!.email.isNotEmpty) {
      return _user!.email;
    }
    if (_firebaseUser?.email != null && _firebaseUser!.email!.isNotEmpty) {
      return _firebaseUser!.email!;
    }
    return 'Not provided';
  }

  String get _mobile {
    if (_user?.mobile != null && _user!.mobile.isNotEmpty) {
      return _user!.mobile;
    }
    if (_firebaseUser?.phoneNumber != null &&
        _firebaseUser!.phoneNumber!.isNotEmpty) {
      return _firebaseUser!.phoneNumber!;
    }
    return 'Not provided';
  }

  String get _city {
    if (_user?.city != null && _user!.city.isNotEmpty) {
      return _user!.city;
    }
    return 'Not specified';
  }

  String get _userId {
    if (_user?.id != null && _user!.id.isNotEmpty) {
      return _user!.id;
    }
    if (_firebaseUser?.uid != null) {
      return _firebaseUser!.uid;
    }
    return 'N/A';
  }

  String get _avatarInitials {
    final name = _fullName.trim();
    if (name.isEmpty) return 'U';
    final parts = name.split(' ');
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Future<void> _pickProfileImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (image != null) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(_profileImageKey, image.path);
        if (mounted) {
          setState(() {
            _profileImageFile = File(image.path);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  Future<void> _removeProfileImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileImageKey);
    if (mounted) {
      setState(() {
        _profileImageFile = null;
      });
    }
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose Profile Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xffE8F8F8),
                    child: Icon(Icons.photo_library, color: AppColors.primary),
                  ),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickProfileImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xffE8F8F8),
                    child: Icon(Icons.camera_alt, color: AppColors.primary),
                  ),
                  title: const Text('Take a Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickProfileImage(ImageSource.camera);
                  },
                ),
                if (_profileImageFile != null)
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xffFFEBEE),
                      child: Icon(Icons.delete_outline, color: Colors.red),
                    ),
                    title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                    onTap: () {
                      Navigator.pop(context);
                      _removeProfileImage();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 40),
                _buildUserInfo(),
                const SizedBox(height: 16),
                if (_isLoggedIn) ...[
                  _buildStatsRow(),
                  const SizedBox(height: 20),
                  _buildPersonalDetailCard(),
                  const SizedBox(height: 20),
                ],
                _buildMenuSection(),
                const SizedBox(height: 24),
                _buildSignOutButton(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                Color(0xff05C1C2),
                Color(0xff03D6D7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -30,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Transform.translate(
                  offset: const Offset(0, -1),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: _showImagePickerBottomSheet,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: const Color(0xffE8F8F8),
                            backgroundImage: _profileImageFile != null
                                ? FileImage(_profileImageFile!)
                                : (_firebaseUser?.photoURL != null
                                    ? NetworkImage(_firebaseUser!.photoURL!)
                                    : null) as ImageProvider<Object>?,
                            child: (_profileImageFile == null &&
                                    _firebaseUser?.photoURL == null)
                                ? Text(
                                    _isLoggedIn ? _avatarInitials : '?',
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _showImagePickerBottomSheet,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      title: const Text(
        'My Profile',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.white),
          onPressed: _showEditProfileBottomSheet,
          tooltip: 'Edit Profile',
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            _isLoggedIn ? _fullName : 'Guest User',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xff1A1A2E),
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.email_outlined,
                size: 15,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                _isLoggedIn ? _email : 'Sign in to access full features',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: _isLoggedIn
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isLoggedIn ? Icons.verified : Icons.account_circle_outlined,
                  size: 14,
                  color: _isLoggedIn ? AppColors.primary : Colors.orange,
                ),
                const SizedBox(width: 4),
                Text(
                  _isLoggedIn ? 'Verified Member' : 'Guest Account',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isLoggedIn ? AppColors.primary : Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            GetBuilder<CartItemController>(
              builder: (controller) => _buildStatItem(
                'Cart Items',
                '${controller.cartList.length}',
                Icons.shopping_bag_outlined,
                onTap: () {
                  if (Get.isRegistered<MainBottomNavBarController>()) {
                    Get.find<MainBottomNavBarController>().changeIndex(2);
                    Get.back();
                  }
                },
              ),
            ),
            _buildStatDivider(),
            GetBuilder<WishListController>(
              builder: (controller) => _buildStatItem(
                'Wishlist',
                '${controller.wishList.length}',
                Icons.favorite_border,
                onTap: () {
                  if (Get.isRegistered<MainBottomNavBarController>()) {
                    Get.find<MainBottomNavBarController>().changeIndex(3);
                    Get.back();
                  }
                },
              ),
            ),
            _buildStatDivider(),
            _buildStatItem(
              'Location',
              _city,
              Icons.location_on_outlined,
              onTap: _showDeliveryAddressBottomSheet,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff1A1A2E),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(width: 1, height: 45, color: Colors.grey.shade200);
  }

  Widget _buildPersonalDetailCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.person_pin, color: AppColors.primary, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Personal Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1A1A2E),
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: _showEditProfileBottomSheet,
                  icon: const Icon(Icons.edit, size: 14),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildDetailRow(
              icon: Icons.person_outline,
              label: 'Full Name',
              value: _fullName,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.email_outlined,
              label: 'Email',
              value: _email,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.phone_android_outlined,
              label: 'Mobile',
              value: _mobile,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.location_city_outlined,
              label: 'City / Region',
              value: _city,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.fingerprint,
              label: 'User ID',
              value: _userId,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff1A1A2E),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildMenuItem(
              icon: Icons.person_outline,
              label: 'Personal Information',
              subtitle: 'Full name, email, phone, city',
              color: const Color(0xff6C63FF),
              onTap: _isLoggedIn
                  ? _showPersonalInfoBottomSheet
                  : _promptSignIn,
              isFirst: true,
            ),
            _buildMenuDivider(),
            _buildMenuItem(
              icon: Icons.location_on_outlined,
              label: 'Delivery Address',
              subtitle: _city != 'Not specified'
                  ? 'Default city: $_city'
                  : 'Saved addresses',
              color: const Color(0xffFF6584),
              onTap: _isLoggedIn
                  ? _showDeliveryAddressBottomSheet
                  : _promptSignIn,
            ),
            _buildMenuDivider(),
            _buildMenuItem(
              icon: Icons.shopping_bag_outlined,
              label: 'My Orders',
              subtitle: 'Track active orders & history',
              color: const Color(0xffFFA500),
              onTap: () {
                if (_isLoggedIn) {
                  if (Get.isRegistered<MainBottomNavBarController>()) {
                    Get.find<MainBottomNavBarController>().changeIndex(2);
                    Get.back();
                  }
                } else {
                  _promptSignIn();
                }
              },
            ),
            _buildMenuDivider(),
            _buildMenuItem(
              icon: Icons.favorite_border,
              label: 'My Wishlist',
              subtitle: 'Saved favorite items',
              color: const Color(0xffE91E63),
              onTap: () {
                if (_isLoggedIn) {
                  if (Get.isRegistered<MainBottomNavBarController>()) {
                    Get.find<MainBottomNavBarController>().changeIndex(3);
                    Get.back();
                  }
                } else {
                  _promptSignIn();
                }
              },
            ),
            _buildMenuDivider(),
            _buildMenuItem(
              icon: Icons.notifications_outlined,
              label: 'Notifications',
              subtitle: 'Alerts, updates',
              color: const Color(0xff29B6F6),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications active')),
                );
              },
            ),
            _buildMenuDivider(),
            _buildMenuItem(
              icon: Icons.lock_outline,
              label: 'Privacy & Security',
              subtitle: 'Password, data',
              color: const Color(0xffEF5350),
              onTap: _showPrivacyDialog,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(20) : Radius.zero,
          bottom: isLast ? const Radius.circular(20) : Radius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuDivider() {
    return Divider(
      height: 1,
      indent: 76,
      endIndent: 16,
      color: Colors.grey.shade100,
    );
  }

  Widget _buildSignOutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: _isLoggedIn
            ? OutlinedButton.icon(
                onPressed: _showSignOutConfirmation,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade400,
                  side: BorderSide(color: Colors.red.shade300, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: Icon(Icons.logout, size: 20, color: Colors.red.shade400),
                label: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade400,
                  ),
                ),
              )
            : ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(SignInScreen.name);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.login, size: 20, color: Colors.white),
                label: const Text(
                  'Sign In / Register',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }

  void _showEditProfileBottomSheet() {
    final firstNameTEController = TextEditingController(
      text: _user?.firstName ??
          (_fullName.contains(' ') ? _fullName.split(' ')[0] : _fullName),
    );
    final lastNameTEController = TextEditingController(
      text: _user?.lastName ??
          (_fullName.contains(' ') ? _fullName.split(' ').sublist(1).join(' ') : ''),
    );
    final emailTEController = TextEditingController(
      text: _email != 'Not provided' ? _email : '',
    );
    final mobileTEController = TextEditingController(
      text: _mobile != 'Not provided' ? _mobile : '',
    );
    final cityTEController = TextEditingController(
      text: _city != 'Not specified' ? _city : '',
    );

    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Edit Profile Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1A1A2E),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: firstNameTEController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Enter first name' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: lastNameTEController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Enter email address' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: mobileTEController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Number',
                      prefixIcon: Icon(Icons.phone_android),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: cityTEController,
                    decoration: const InputDecoration(
                      labelText: 'City / Region',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final updatedUser = UserModel(
                            id: _userId,
                            firstName: firstNameTEController.text.trim(),
                            lastName: lastNameTEController.text.trim(),
                            email: emailTEController.text.trim(),
                            mobile: mobileTEController.text.trim(),
                            city: cityTEController.text.trim(),
                          );
                          await AuthController.updateUserData(updatedUser);
                          if (modalContext.mounted) {
                            Navigator.pop(modalContext);
                            setState(() {});
                            ScaffoldMessenger.of(modalContext).showSnackBar(
                              const SnackBar(
                                content: Text('Profile updated successfully!'),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        'Save Profile Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPersonalInfoBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Full Personal Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.primary),
                    onPressed: () {
                      Navigator.pop(context);
                      _showEditProfileBottomSheet();
                    },
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),
              _buildDetailRow(
                icon: Icons.person,
                label: 'First Name',
                value: _user?.firstName ??
                    (_fullName.contains(' ') ? _fullName.split(' ')[0] : _fullName),
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                icon: Icons.person_outline,
                label: 'Last Name',
                value: _user?.lastName ??
                    (_fullName.contains(' ') ? _fullName.split(' ').sublist(1).join(' ') : 'N/A'),
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                icon: Icons.email,
                label: 'Email Address',
                value: _email,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                icon: Icons.phone,
                label: 'Mobile',
                value: _mobile,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                icon: Icons.location_on,
                label: 'City',
                value: _city,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                icon: Icons.badge,
                label: 'User ID',
                value: _userId,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showDeliveryAddressBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Delivery Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Color(0xffE8F8F8),
                  child: Icon(Icons.home, color: AppColors.primary),
                ),
                title: const Text('Default Delivery City'),
                subtitle: Text(_city != 'Not specified' ? _city : 'No city set yet'),
                trailing: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showEditProfileBottomSheet();
                  },
                  child: const Text('Change'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy & Security'),
        content: const Text(
          'Your personal information is securely encrypted. CraftyBay protects your data privacy in accordance with standard data privacy policies.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _promptSignIn() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign In Required'),
        content: const Text(
          'Please sign in to access your personal profile details and orders.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Get.toNamed(SignInScreen.name);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Sign In', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSignOutConfirmation() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out from your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(dialogContext);
              await AuthController.clearUserData();
              if (!mounted) return;
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully')),
              );
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
