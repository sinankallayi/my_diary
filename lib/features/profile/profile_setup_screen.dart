import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../../shared/widgets/primary_button.dart';

class ProfileSetupScreen extends StatelessWidget {
  final VoidCallback onComplete;
  const ProfileSetupScreen({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back, color: AppColors.pink),
        title: Text(
          "Profile Setup",
          style: TextStyle(
            color: AppColors.darkText,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50.r,
                  backgroundColor: const Color(
                    0xFFFFCCBC,
                  ), // Light orange/skin tone
                  child: Icon(
                    Icons.person,
                    size: 60.sp,
                    color: Colors.brown,
                  ), // Fallback for image
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: const BoxDecoration(
                      color: AppColors.pink,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.edit, size: 16.sp, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Text(
              "Begin Your Journey",
              style: AppTheme.serifTitleStyle.copyWith(fontSize: 28.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              "Tell us about yourself to start your storytelling habit.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.greyText, fontSize: 15.sp),
            ),
            SizedBox(height: 40.h),

            const CustomTextField(
              label: "Full Name",
              hint: "How should we address you?",
              icon: Icons.person_outline,
            ),

            SizedBox(height: 32.h),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Daily Reminder",
                style: AppTheme.serifTitleStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Choose a time that works best for your daily reflection. Consistency is the key to memory.",
              style: TextStyle(color: AppColors.greyText, fontSize: 13.sp),
            ),
            SizedBox(height: 20.h),

            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade100,
                    blurRadius: 10.r,
                    offset: Offset(0, 5.h),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F6),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Icon(
                      Icons.notifications_active,
                      color: AppColors.pink,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "REMINDER TIME",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "09:00 PM",
                        style: AppTheme.serifTitleStyle.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.access_time, size: 18.sp),
                  SizedBox(width: 16.w),
                  Text(
                    "Daily",
                    style: TextStyle(
                      color: AppColors.pink,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Switch(
                    value: true,
                    onChanged: (v) {},
                    activeColor: AppColors.pink,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F6),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.pink.withOpacity(0.3),
                  style: BorderStyle.solid,
                ), // Dashed border simulated
              ),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: AppColors.pink, size: 20.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      "90% of journalers find that evening reflection improves sleep quality and clarity of thought.",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12.sp,
                        color: const Color(0xFF555555),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            PrimaryButton(text: "Complete Setup", onTap: onComplete),
            SizedBox(height: 16.h),
            Text(
              "You can always change these settings later.",
              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
