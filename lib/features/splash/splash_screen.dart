import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinish;
  const SplashScreen({super.key, required this.onFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate loading delay
    Timer(const Duration(seconds: 3), widget.onFinish);
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
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.pink.withOpacity(0.1),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/splash_pencil.png',
                      height: 150,
                      width: 150,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Title
                RichText(
                  text: TextSpan(
                    style: AppTheme.serifTitleStyle.copyWith(fontSize: 42),
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
                const SizedBox(height: 10),
                Text(
                  'Capture your peace',
                  style: AppTheme.serifTitleStyle.copyWith(
                    fontStyle: FontStyle.italic,
                    color: AppColors.greyText,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          // Bottom Loader
          Positioned(
            bottom: 60,
            left: 50,
            right: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'INITIALIZING\nSANCTUARY',
                      style: TextStyle(
                        letterSpacing: 1.5,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B6B80),
                      ),
                    ),
                    Text(
                      '30%',
                      style: TextStyle(
                        color: AppColors.pink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.3,
                    backgroundColor: Colors.grey.shade200,
                    color: AppColors.pink,
                    minHeight: 2,
                  ),
                ),
                const SizedBox(height: 30),
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
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AppColors.pink : Colors.grey.shade300,
      ),
    );
  }
}
