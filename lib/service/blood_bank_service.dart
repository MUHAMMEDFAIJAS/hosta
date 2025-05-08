import 'dart:convert';
import 'package:hosta/model/blood_bank_model.dart';
import 'package:http/http.dart' as http;

const String _baseUrl = 'https://hosta-server.vercel.app/api/donors';

class BloodDonorService {
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
}
