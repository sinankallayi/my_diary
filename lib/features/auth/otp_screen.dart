import 'package:flutter/material.dart';
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
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F6),
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(Icons.arrow_back, color: AppColors.pink),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Verify Identity",
              style: AppTheme.serifTitleStyle.copyWith(fontSize: 32),
            ),
            const SizedBox(height: 16),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: AppColors.greyText,
                  fontSize: 16,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text:
                        "We've sent a 6-digit verification code to your registered mobile number ",
                  ),
                  TextSpan(
                    text: "+1 ••• ••• 88",
                    style: TextStyle(
                      color: AppColors.darkText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) => _otpDigit()),
            ),
            const SizedBox(height: 40),
            PrimaryButton(
              text: "Verify Code",
              onTap: onVerify,
              showArrow: true,
            ),
            const SizedBox(height: 32),
            const Center(
              child: Text(
                "Didn't receive the code?",
                style: TextStyle(color: AppColors.greyText),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                "Resend New Code",
                style: TextStyle(
                  color: AppColors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    "Resend available in 0:45",
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
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
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(
          12,
        ), // Not fully circle based on screenshot
      ),
      child: const Center(
        child: CircleAvatar(backgroundColor: AppColors.darkText, radius: 3),
      ),
    );
  }
}
