import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hosta/home_screen.dart';
import 'package:hosta/model/user_model.dart';
import 'package:hosta/service/google_signinapi.dart';
import 'package:hosta/views/signup/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl =
      'https://hospital-mangement-backend.vercel.app/api/users';

  // 🔥 Login User
  static Future<AppUser?> loginUser(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(responseData);
        final user = loginResponse.user;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('loginType', 'email');
        await prefs.setString('userId', user.id);
        await prefs.setString('userName', user.name);
        await prefs.setString('userEmail', user.email);
        await prefs.setString('userPhone', user.phone);

        return AppUser(
          displayName: user.name,
          email: user.email,
          photoUrl: null,
        );
      } else {
        print('Login failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  static Future<bool> registerUser(UserRegistration user) async {
    final url = Uri.parse('$_baseUrl/registeration');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Registration Successful');
        return true;
      } else {
        print('Registration Failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  Future<void> signIN(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSigninApi.login();

      if (googleUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Sign-In cancelled or failed')),
        );
        return;
      }

      final AppUser appUser = AppUser(
        displayName: googleUser.displayName ?? 'Google User',
        email: googleUser.email,
        photoUrl: googleUser.photoUrl,
      );

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('loginType', 'google');
      await prefs.setString('userName', appUser.displayName ?? '');
      await prefs.setString('userEmail', appUser.email);
      await prefs.setString('userPhoto', appUser.photoUrl ?? '');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: appUser),
        ),
      );
    } catch (e) {
      print("Google Sign-In error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong during login')),
      );
    }
  }

  Future<void> signOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loginType');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userPhoto');

    await GoogleSigninApi.logout();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }
}
