import 'dart:convert';
import 'package:hosta/model/user_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl =
      'https://hospital-mangement-backend.vercel.app/api/users';

  // 🔥 Login User
  static Future<LoginResponse?> loginUser(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return LoginResponse.fromJson(responseData);
      } else {
        print('Login failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  // ✨ Register (Signup) User
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
}
