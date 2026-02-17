import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'features/navigation/main_navigation_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dlwjdgjpzubpqeahduyp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRsd2pkZ2pwenVicHFlYWhkdXlwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzEyNjM3NTUsImV4cCI6MjA4NjgzOTc1NX0.IROy_ysmiMAp6Q8TiTysXAd0Jm5POJauvX3s6PUYR-Q',
  );

  runApp(const MyDiaryApp());
}

class MyDiaryApp extends StatelessWidget {
  const MyDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Standard mobile design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'MyDiary',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const MainNavigationController(),
        );
      },
    );
  }
}
