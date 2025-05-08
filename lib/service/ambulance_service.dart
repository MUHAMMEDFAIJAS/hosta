import 'dart:convert';
import 'package:hosta/model/ambulance_model.dart';
import 'package:http/http.dart' as http;

const String _baseUrl =
    'https://hospital-mangement-backend.vercel.app/api/ambulances';

class AmbulanceService {
  static Future<List<Ambulance>> fetchAmbulances() async {
    final url = Uri.parse(_baseUrl); // Replace with your actual URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<dynamic> data = jsonBody['data'];

      return data.map((json) => Ambulance.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load ambulance data');
    }
  }
}
