import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_colors.dart';
import '../../core/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinish;
  final VoidCallback? onFoundSession;

  const SplashScreen({super.key, required this.onFinish, this.onFoundSession});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Simulate minimum splash duration
    await Future.delayed(const Duration(seconds: 2));

    // Check login state
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (isLoggedIn && widget.onFoundSession != null) {
      widget.onFoundSession!();
    } else {
      widget.onFinish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  height: 100.h,
                  width: 100.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.pink.withOpacity(0.1),
                        blurRadius: 30.r,
                        spreadRadius: 10.r,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/splash_pencil.png',
                      height: 150.h,
                      width: 150.h,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                // Title
                RichText(
                  text: TextSpan(
                    style: AppTheme.serifTitleStyle.copyWith(fontSize: 42.sp),
                    children: const [
                      TextSpan(
                        text: 'My',
                        style: TextStyle(color: AppColors.darkText),
                      ),
                      TextSpan(
                        text: 'Diary',
                        style: TextStyle(color: AppColors.pink),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Capture your peace',
                  style: AppTheme.serifTitleStyle.copyWith(
                    fontStyle: FontStyle.italic,
                    color: AppColors.greyText,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
          ),
          // Bottom Loader
          Positioned(
            bottom: 60.h,
            left: 50.w,
            right: 50.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'INITIALIZING\nSANCTUARY',
                      style: TextStyle(
                        letterSpacing: 1.5,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6B6B80),
                      ),
                    ),
                    Text(
                      '30%',
                      style: TextStyle(
                        color: AppColors.pink,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: 0.3,
                    backgroundColor: Colors.grey.shade200,
                    color: AppColors.pink,
                    minHeight: 2.h,
                  ),
                ),
                SizedBox(height: 30.h),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [_dot(false), _dot(true), _dot(false)],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: 6.w,
      height: 6.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AppColors.pink : Colors.grey.shade300,
      ),
    );
  }
}
