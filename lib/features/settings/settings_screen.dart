import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../features/navigation/main_navigation_controller.dart';
import '../../services/supabase_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    // Show confirmation dialog
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      if (context.mounted) {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );

        try {
          // Clear local session data
          final prefs = await SharedPreferences.getInstance();
          // Clear specific keys to reset user session
          await prefs.remove('is_logged_in');
          await prefs.remove('user_name');
          await prefs.remove('profile_avatar_url');
          await prefs.remove('daily_reminder_time');
          await prefs.remove('is_reminder_enabled');

          await SupabaseService().client.auth.signOut();

          if (context.mounted) {
            // Remove loading indicator
            Navigator.pop(context); // Pop loading dialog

            // Navigate to MainNavigationController (Reset app flow)
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const MainNavigationController(),
              ),
              (route) => false,
            );
          }
        } catch (e) {
          if (context.mounted) {
            // Remove loading indicator
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error logging out: ${e.toString()}')),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTheme.serifTitleStyle.copyWith(fontSize: 20.sp),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: EdgeInsets.all(20.w),
        children: [
          // _buildSectionHeader('Account'),
          // _buildSettingsContainer(
          //   children: [
          //     _buildSettingsTile(
          //       icon: Icons.person_outline,
          //       title: 'Edit Profile',
          //       onTap: () {
          //         // Navigate to Profile Setup or Edit
          //       },
          //     ),
          //     const Divider(height: 1),
          //     _buildSettingsTile(
          //       icon: Icons.notifications_outlined,
          //       title: 'Notifications',
          //       onTap: () {},
          //     ),
          //   ],
          // ),
          // SizedBox(height: 24.h),
          // _buildSectionHeader('General'),
          // _buildSettingsContainer(
          //   children: [
          //     _buildSettingsTile(
          //       icon: Icons.security,
          //       title: 'Security',
          //       onTap: () {},
          //     ),
          //     const Divider(height: 1),
          //     _buildSettingsTile(
          //       icon: Icons.help_outline,
          //       title: 'Help & Support',
          //       onTap: () {},
          //     ),
          //   ],
          // ),
          SizedBox(height: 24.h),
          _buildSettingsContainer(
            children: [
              _buildSettingsTile(
                icon: Icons.logout,
                title: 'Logout',
                textColor: Colors.red,
                iconColor: Colors.red,
                showArrow: false,
                onTap: () => _handleLogout(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.greyText,
        ),
      ),
    );
  }

  Widget _buildSettingsContainer({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
    bool showArrow = true,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.pink).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: iconColor ?? AppColors.pink, size: 20.sp),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: textColor ?? AppColors.darkText,
        ),
      ),
      trailing: showArrow
          ? Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: AppColors.greyText,
            )
          : null,
      onTap: onTap,
    );
  }
}
