import 'package:flutter/material.dart';
import 'package:hosta/model/user_model.dart';
import 'package:hosta/views/signup/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hosta/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final loginType = prefs.getString('loginType');
    final email = prefs.getString('userEmail');

    if (loginType == 'google' && email != null) {
      // Auto-login with Google user
      final user = AppUser(
        displayName: prefs.getString('userName') ?? 'Google User',
        email: email,
        photoUrl: prefs.getString('userPhoto'),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
      );
    } else if (loginType == 'email' && email != null) {
      // Auto-login with Email user
      final user = AppUser(
        displayName: prefs.getString('userName') ?? '',
        email: email,
        photoUrl: null,
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
      );
    } else {
      // Not logged in, go to login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
