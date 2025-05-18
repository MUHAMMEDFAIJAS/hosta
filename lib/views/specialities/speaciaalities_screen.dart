import 'package:flutter/material.dart';
import 'package:hosta/model/hospital_model.dart';
import 'package:hosta/service/hospital_service.dart';
import 'package:hosta/helper.dart';

import '../hospitals/hospital_details_screen.dart'; // assuming CustomHeader is here

class SpecialtiesScreen extends StatefulWidget {
  const SpecialtiesScreen({super.key});

  @override
  State<SpecialtiesScreen> createState() => _SpecialtiesScreenState();
}

class _SpecialtiesScreenState extends State<SpecialtiesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Specialty> specialties = [];
  List<Specialty> filteredSpecialties = [];
  bool isLoading = true;
  int? expandedIndex;

  @override
  void initState() {
    super.initState();
    _loadSpecialties();
    _searchController.addListener(_filterSpecialties);
  }

  List<Hospital> hospitals = [];
  List<_SpecialtyWithHospital> specialtyWithHospitals = [];
  List<_SpecialtyWithHospital> filteredSpecialtyWithHospitals = [];

  Future<void> _loadSpecialties() async {
    final fetchedHospitals =
        await HospitalService.fetchHospitals(); // fetch hospitals
    hospitals = fetchedHospitals;

    specialtyWithHospitals = [];
    for (var hospital in hospitals) {
      for (var specialty in hospital.specialties) {
        specialtyWithHospitals.add(_SpecialtyWithHospital(
          specialty: specialty,
          hospital: hospital,
        ));
      }
    }

    setState(() {
      filteredSpecialtyWithHospitals = List.from(specialtyWithHospitals);
      isLoading = false;
    });
  }

  void _filterSpecialties() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredSpecialtyWithHospitals = specialtyWithHospitals.where((pair) {
        final specialty = pair.specialty;
        final nameMatch = specialty.name.toLowerCase().contains(query);
        final doctorMatch = specialty.doctors.any(
          (doc) => doc.name.toLowerCase().contains(query),
        );
        return nameMatch || doctorMatch;
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomHeader(
            title: 'SPECIALTIES',
            searchHint: 'Search by specialty or doctor...',
            searchController: _searchController,
            onChanged: (_) {}, // already handled by controller listener
            onBack: () => Navigator.of(context).pop(),
            onMenuPressed: () {},
            onSettingsPressed: () {},
          ),
          const SizedBox(height: 20),
          isLoading
              ? const Expanded(
                  child: Center(child: CircularProgressIndicator()))
              : Expanded(
                  child: filteredSpecialtyWithHospitals.isEmpty
                      ? const Center(child: Text('No results found'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filteredSpecialtyWithHospitals.length,
                          itemBuilder: (context, index) {
                            return _buildSpecialtyCard(
                                index, filteredSpecialtyWithHospitals);
                          },
                        ),
                ),
        ],
      ),
    );
  }

  Widget _buildSpecialtyCard(
      int index, List<_SpecialtyWithHospital> sourceList) {
    final pair = sourceList[index];
    final specialty = pair.specialty;
    final hospital = pair.hospital;
    final isExpanded = expandedIndex == index;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              expandedIndex = isExpanded ? null : index;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  specialty.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          GestureDetector(
            onTap: () {
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
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Card(
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(color: Colors.green),
                      const SizedBox(height: 10),
                      Text(
                        hospital.name,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.green[700],
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        specialty.phone.isNotEmpty
                            ? specialty.phone
                            : 'No phone available.',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Doctors:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      ...specialty.doctors.map(
                        (doctor) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text('• ${doctor.name}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SpecialtyWithHospital {
  final Specialty specialty;
  final Hospital hospital;

  _SpecialtyWithHospital({required this.specialty, required this.hospital});
}
