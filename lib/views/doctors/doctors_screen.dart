import 'package:flutter/material.dart';
import 'package:hosta/helper.dart';
import 'package:hosta/model/hospital_model.dart';
import 'package:hosta/service/doctor_service.dart';
import 'package:hosta/service/hospital_service.dart';

import '../hospitals/hospital_details_screen.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Doctor> _allDoctors = [];
  List<Doctor> _filteredDoctors = [];
  bool _isLoading = true;
  String _error = '';
  Map<String, Hospital> _doctorHospitalMap = {};

  @override
  void initState() {
    super.initState();
    _loadDoctors();
    _searchController.addListener(_filterDoctors);
  }

  Future<void> _loadDoctors() async {
    try {
      final hospitals = await HospitalService.fetchHospitals();
      final doctors = <Doctor>[];
      final doctorHospitalMap = <String, Hospital>{};

      for (var hospital in hospitals) {
        for (var specialty in hospital.specialties) {
          for (var doctor in specialty.doctors) {
            doctors.add(doctor);
            doctorHospitalMap[doctor.name] = hospital;
          }
        }
      }

      setState(() {
        _allDoctors = doctors;
        _filteredDoctors = doctors;
        _doctorHospitalMap = doctorHospitalMap;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterDoctors() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDoctors = _allDoctors.where((doc) {
        return doc.name.toLowerCase().contains(query) ||
            doc.qualification.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          CustomHeader(
            title: 'DOCTORS',
            searchHint: 'Search by name or qualification...',
            searchController: _searchController,
            onChanged: (_) {}, // now handled by controller listener
            onBack: () => Navigator.of(context).pop(),
            onMenuPressed: () {},
            onSettingsPressed: () {},
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error.isNotEmpty
                    ? Center(
                        child: Text(_error,
                            style: TextStyle(fontFamily: 'Poppins')))
                    : _filteredDoctors.isEmpty
                        ? const Center(
                            child: Text('No doctors found.',
                                style: TextStyle(fontFamily: 'Poppins')))
                        : ListView.builder(
                            padding: const EdgeInsets.all(10),
                            itemCount: _filteredDoctors.length,
                            itemBuilder: (context, index) {
                              final doc = _filteredDoctors[index];
                              final hosp = _doctorHospitalMap[doc.name];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    final hospital =
                                        _doctorHospitalMap[doc.name];
                                  

                                    if (hospital != null) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => HospitalDetailsScreen(
                                            id: hospital.id,
                                            name: hospital.name,
                                            address: hospital.address,
                                            phone: hospital.phone,
                                            email: hospital.email,
                                            imageUrl: hospital.image?.imageUrl,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: DoctorTile(
                                    name: doc.name,
                                    specialization: doc.qualification,
                                    hospitalname: hosp?.name ?? '',
                                    availability: doc.consulting.map((c) {
                                      return {
                                        'day': c.day,
                                        'name': hosp?.name ?? '',
                                        'time':
                                            '${c.startTime} to ${c.endTime}',
                                      };
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

class DoctorTile extends StatelessWidget {
  final String name;
  final String specialization;
  final List<Map<String, String>> availability;
  final String hospitalname;

  const DoctorTile({
    super.key,
    required this.name,
    required this.specialization,
    required this.availability,
    required this.hospitalname,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          fontFamily: 'Poppins',
        ),
      ),
      subtitle: Text(
        specialization,
        style: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Poppins',
        ),
      ),
      children: availability.map((item) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['day'] ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['time'] ?? '',
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                  Flexible(
                    child: Text(
                      hospitalname,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign:
                          TextAlign.end, // optional: align to right if needed
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
