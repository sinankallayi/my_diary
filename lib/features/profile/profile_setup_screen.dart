import 'package:flutter/material.dart';
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
        title: const Text(
          "Profile Setup",
          style: TextStyle(
            color: AppColors.darkText,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFFFCCBC), // Light orange/skin tone
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.brown,
                  ), // Fallback for image
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.pink,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              "Begin Your Journey",
              style: AppTheme.serifTitleStyle.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 8),
            const Text(
              "Tell us about yourself to start your storytelling habit.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.greyText, fontSize: 15),
            ),
            const SizedBox(height: 40),

            const CustomTextField(
              label: "Full Name",
              hint: "How should we address you?",
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 32),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Daily Reminder",
                style: AppTheme.serifTitleStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Choose a time that works best for your daily reflection. Consistency is the key to memory.",
              style: TextStyle(color: AppColors.greyText, fontSize: 13),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade100,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.notifications_active,
                      color: AppColors.pink,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "REMINDER TIME",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "09:00 PM",
                        style: AppTheme.serifTitleStyle.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.access_time, size: 18),
                  const SizedBox(width: 16),
                  const Text(
                    "Daily",
                    style: TextStyle(
                      color: AppColors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: true,
                    onChanged: (v) {},
                    activeColor: AppColors.pink,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.pink.withOpacity(0.3),
                  style: BorderStyle.solid,
                ), // Dashed border simulated
              ),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome, color: AppColors.pink, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "90% of journalers find that evening reflection improves sleep quality and clarity of thought.",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            PrimaryButton(text: "Complete Setup", onTap: onComplete),
            const SizedBox(height: 16),
            const Text(
              "You can always change these settings later.",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
