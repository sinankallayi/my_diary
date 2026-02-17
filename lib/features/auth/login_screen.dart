import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../../shared/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  final Function(String) onLogin;
  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 40.h),
                // Icon
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.pink.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: AppColors.pink,
                    size: 32.sp,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "My Diary",
                  style: AppTheme.serifTitleStyle.copyWith(fontSize: 32.sp),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Welcome back to your private space.",
                  textAlign: TextAlign.center,
                  style: AppTheme.serifTitleStyle.copyWith(
                    color: AppColors.greyText,
                    fontSize: 16.sp,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 48.h),

                CustomTextField(
                  label: "Email or Phone Number",
                  hint: "e.g. hello@diary.com",
                  controller: _controller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email or phone number";
                    }
                    // Simple regex for email or phone
                    bool isEmail = RegExp(
                      r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value);
                    bool isPhone = RegExp(r"^[0-9]{10,}$").hasMatch(value);

                    if (!isEmail && !isPhone) {
                      return "Enter a valid email or phone number";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32.h),

                PrimaryButton(
                  text: "Get OTP",
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();

                      // Save login state
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('is_logged_in', true);
                      await prefs.setString('user_name', _controller.text);

                      await Future.delayed(const Duration(milliseconds: 300));
                      widget.onLogin(_controller.text);
                    }
                  },
                ),

                SizedBox(height: 40.h),
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        "OR CONTINUE WITH",
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),
                SizedBox(height: 32.h),
                Row(
                  children: [
                    Expanded(
                      child: _socialBtn(
                        "Google",
                        Image.asset(
                          "assets/images/google_logo.png",
                          width: 24.w,
                          height: 24.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _socialBtn(
                        "Apple",
                        Icon(Icons.apple, color: Colors.black, size: 24.sp),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock, size: 14.sp, color: Colors.grey),
                      SizedBox(width: 8.w),
                      Text(
                        "END-TO-END ENCRYPTED",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  "Your thoughts are for your eyes only. No one, not even us, can read your diary entries.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialBtn(String text, Widget icon) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
