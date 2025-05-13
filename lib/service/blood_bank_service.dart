import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hosta/model/blood_bank_model.dart'; // if needed for modeling

const String _baseUrl = 'https://hosta-server.vercel.app/api/donors';

class BloodDonorService {
  // Existing fetch function
  static Future<List<BloodDonor>> fetchDonors() async {
    final url = Uri.parse(_baseUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List donors = data['donors'];
      return donors.map((json) => BloodDonor.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load donors');
    }
  }

  // New create/post function
  static Future<bool> createDonor({
    required String name,
    required String email,
    required String phone,
    required int age,
    required String bloodGroup,
    required String place,
    required int pincode,
    required String lastDonationDate, // e.g. "2024-04-16"
  }) async {
    final url = Uri.parse(_baseUrl);

    final Map<String, dynamic> body = {
      "newDonor": {
        "name": name,
        "email": email,
        "phone": phone,
        "age": age,
        "bloodGroup": bloodGroup,
        "address": {
          "place": place,
          "pincode": pincode,
        },
        "lastDonationDate": lastDonationDate,
      }
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return false;
    }
  }
}
