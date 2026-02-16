import 'package:flutter/material.dart';
import '../splash/splash_screen.dart';
import '../auth/login_screen.dart';
import '../auth/otp_screen.dart';
import '../profile/profile_setup_screen.dart';
import '../home/home_screen.dart';

class MainNavigationController extends StatefulWidget {
  const MainNavigationController({super.key});

  @override
  State<MainNavigationController> createState() =>
      _MainNavigationControllerState();
}

class _MainNavigationControllerState extends State<MainNavigationController> {
  int _currentIndex = 0;

  void _nextScreen() {
    setState(() {
      if (_currentIndex < 4) _currentIndex++;
    });
  }

  void _goToHome() {
    setState(() {
      _currentIndex = 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    // We map the index to the specific screen widget
    switch (_currentIndex) {
      case 0:
        return SplashScreen(onFinish: _nextScreen);
      case 1:
        return LoginScreen(onLogin: _nextScreen);
      case 2:
        return OTPScreen(onVerify: _nextScreen);
      case 3:
        return ProfileSetupScreen(onComplete: _goToHome);
      case 4:
        return const HomeScreen();
      default:
        return const HomeScreen();
    }
  }
}
