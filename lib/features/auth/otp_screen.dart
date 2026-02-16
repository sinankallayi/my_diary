import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../shared/widgets/primary_button.dart';

class OTPScreen extends StatefulWidget {
  final VoidCallback onVerify;
  final VoidCallback onBack;
  final String contactInfo;
  const OTPScreen({
    super.key,
    required this.onVerify,
    required this.onBack,
    required this.contactInfo,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(6, (index) => FocusNode());
    _controllers = List.generate(6, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var node in _focusNodes) node.dispose();
    for (var controller in _controllers) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEmail = widget.contactInfo.contains('@');
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: widget.onBack,
          child: Container(
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F6),
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.pink),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
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
                      TextSpan(
                        text: isEmail
                            ? "We've sent a 6-digit verification code to your registered email "
                            : "We've sent a 6-digit verification code to your registered mobile number ",
                      ),
                      TextSpan(
                        text: widget.contactInfo,
                        style: TextStyle(
                          color: AppColors.darkText,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      const TextSpan(text: "."),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) => _otpField(index)),
                ),
                SizedBox(height: 40.h),
                PrimaryButton(
                  text: "Verify Code",
                  onTap: widget.onVerify,
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
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _otpField(int index) {
    return Container(
      width: 45.w,
      height: 55.h,
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: TextFormField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
          ),
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (index < 5) {
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              } else {
                FocusScope.of(context).unfocus();
              }
            } else {
              if (index > 0) {
                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
              }
            }
          },
        ),
      ),
    );
  }
}
