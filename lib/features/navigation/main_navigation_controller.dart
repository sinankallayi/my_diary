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
  String? _loginInput;

  void _nextScreen([String? input]) {
    setState(() {
      if (input != null) {
        _loginInput = input;
      }
      if (_currentIndex < 4) _currentIndex++;
    });
  }

  void _goToHome() {
    setState(() {
      _currentIndex = 4;
    });
  }

  void _previousScreen() {
    setState(() {
      if (_currentIndex > 0) _currentIndex--;
    });
  }

  @override
  Widget build(BuildContext context) {
    // We map the index to the specific screen widget
    switch (_currentIndex) {
      case 0:
        return SplashScreen(onFinish: () => _nextScreen());
      case 1:
        return LoginScreen(onLogin: (input) => _nextScreen(input));
      case 2:
        return OTPScreen(
          onVerify: () => _nextScreen(),
          onBack: _previousScreen,
          contactInfo: _loginInput ?? "",
        );
      case 3:
        return ProfileSetupScreen(onComplete: _goToHome);
      case 4:
        return const HomeScreen();
      default:
        return const HomeScreen();
    }
  }
}
