import 'package:flutter/material.dart';
import 'package:hosta/model/hospital_model.dart';
import 'package:hosta/service/hospital_service.dart';
import 'package:hosta/helper.dart'; // assuming CustomHeader is here

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

  Future<void> _loadSpecialties() async {
    final fetchedSpecialties = await HospitalService.fetchSpecialties();
    setState(() {
      specialties = fetchedSpecialties;
      filteredSpecialties = fetchedSpecialties;
      isLoading = false;
    });
  }

  void _filterSpecialties() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredSpecialties = specialties.where((specialty) {
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
                  child: filteredSpecialties.isEmpty
                      ? const Center(child: Text('No results found'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filteredSpecialties.length,
                          itemBuilder: (context, index) {
                            return _buildSpecialtyCard(
                                index, filteredSpecialties);
                          },
                        ),
                ),
        ],
      ),
    );
  }

  Widget _buildSpecialtyCard(int index, List<Specialty> sourceList) {
    final specialty = sourceList[index];
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  specialty.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(color: Colors.green),
                const SizedBox(height: 10),
                Text(
                  specialty.description.isNotEmpty
                      ? specialty.description
                      : 'No description available.',
                  style: const TextStyle(fontSize: 14),
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
                    child: Text('• ${doctor.name}'),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
