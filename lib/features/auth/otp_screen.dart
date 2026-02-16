import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../shared/widgets/primary_button.dart';

class OTPScreen extends StatelessWidget {
  final VoidCallback onVerify;
  const OTPScreen({super.key, required this.onVerify});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F6),
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: const Icon(Icons.arrow_back, color: AppColors.pink),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Verify Identity",
              style: AppTheme.serifTitleStyle.copyWith(fontSize: 32.sp),
            ),
            SizedBox(height: 16.h),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: AppColors.greyText,
                  fontSize: 16.sp,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text:
                        "We've sent a 6-digit verification code to your registered mobile number ",
                  ),
                  TextSpan(
                    text: "+1 ••• ••• 88",
                    style: TextStyle(
                      color: AppColors.darkText,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp, // Explicit font size to match parent
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) => _otpDigit()),
            ),
            SizedBox(height: 40.h),
            PrimaryButton(
              text: "Verify Code",
              onTap: onVerify,
              showArrow: true,
            ),
            SizedBox(height: 32.h),
            const Center(
              child: Text(
                "Didn't receive the code?",
                style: TextStyle(color: AppColors.greyText),
              ),
            ),
            SizedBox(height: 8.h),
            Center(
              child: Text(
                "Resend New Code",
                style: TextStyle(
                  color: AppColors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time, size: 14.sp, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Text(
                    "Resend available in 0:45",
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpDigit() {
    return Container(
      width: 45.w,
      height: 55.h,
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(
          12.r,
        ), // Not fully circle based on screenshot
      ),
      child: Center(
        child: CircleAvatar(backgroundColor: AppColors.darkText, radius: 3.r),
      ),
    );
  }
}
