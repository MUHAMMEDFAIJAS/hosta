import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hosta/model/hospital_model.dart';

class DoctorService {
  static const String apiUrl =
      'https://hospital-mangement-backend.vercel.app/api/hospitals';

  static Future<List<Doctor>> fetchDoctors() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<Doctor> allDoctors = [];
      final jsonData = json.decode(response.body);

      if (jsonData['data'] != null) {
        for (var hospital in jsonData['data']) {
          if (hospital['specialties'] != null) {
            for (var specialty in hospital['specialties']) {
              if (specialty['doctors'] != null) {
                for (var doc in specialty['doctors']) {
                  allDoctors.add(Doctor.fromJson(doc));
                }
              }
            }
          }
        }
      }

      return allDoctors;
    } else {
      throw Exception('Failed to load doctors');
    }
  }
}
