import 'package:flutter/material.dart';
import 'package:hosta/model/hospital_model.dart';
import 'package:hosta/service/hospital_service.dart';

class hospitalsProvider with ChangeNotifier {
  List<Hospital> hospitals = [];

  void setHospitals(List<Hospital> hospitalss) {
    hospitals = hospitalss;
    notifyListeners();
  }

  Future<void> fetchHospitals() async {
    try {
      final hospitals = await HospitalService.fetchHospitals();
      setHospitals(hospitals);
    } catch (e) {
      print('Error fetching hospitals: $e');
    }
  }

  // Future<void> fetchHospitalsByType(String type) async {
  //   notifyListeners();

  //   try {
  //     final hospitals = await HospitalService.fetchHospitalsByType(type);
  //     setHospitals(hospitals);
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     notifyListeners();
  //   }
  // }
}
