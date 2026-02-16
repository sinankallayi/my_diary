import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'features/navigation/main_navigation_controller.dart';

void main() {
  runApp(const MyDiaryApp());
}

class MyDiaryApp extends StatelessWidget {
  const MyDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyDiary',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationController(),
    );
  }
}
