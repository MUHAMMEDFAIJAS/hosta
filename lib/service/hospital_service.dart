import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/hospital_model.dart';

const String _baseUrl =
    'https://hospital-mangement-backend.vercel.app/api/hospitals';

class HospitalService {
  static Future<List<Hospital>> fetchHospitals() async {
    final url = Uri.parse(_baseUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List hospitalsJson = responseData['data'];

        return hospitalsJson.map((e) => Hospital.fromJson(e)).toList();
      } else {
        print('Failed to load hospitals: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching hospitals: $e');
      return [];
    }
  }

  static Future<List<Specialty>> fetchSpecialties() async {
  final url = Uri.parse('$_baseUrl');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List hospitalsJson = responseData['data'];

      // Flatten all specialties from all hospitals into a single list
      List<Specialty> allSpecialties = [];
      for (var hospital in hospitalsJson) {
        final specialties = hospital['specialties'];
        for (var specialty in specialties) {
          allSpecialties.add(Specialty.fromJson(specialty));
        }
      }

      return allSpecialties;
    } else {
      print('Failed to load specialties: ${response.body}');
      return [];
    }
  } catch (e) {
    print('Error fetching specialties: $e');
    return [];
  }
}

}

  // static Future<List<Hospital>> fetchHospitalsByType(String type) async {
  //   final url = Uri.parse('$_baseUrl?type=$type');

  //   try {
  //     final response = await http.get(url);

  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);
  //       final List hospitalsJson = responseData['data'];
  //       return hospitalsJson.map((e) => Hospital.fromJson(e)).toList();
  //     } else {
  //       print('Failed to load hospitals by type: ${response.body}');
  //       return [];
  //     }
  //   } catch (e) {
  //     print('Error fetching hospitals by type: $e');
  //     return [];
  //   }
  // }
