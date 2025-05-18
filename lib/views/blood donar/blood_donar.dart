import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hosta/model/blood_bank_model.dart';
import 'package:hosta/service/blood_bank_service.dart';
import 'package:hosta/views/blood%20donar/add_blood_donor.dart';

class HostaHeader extends StatelessWidget {
  final TextEditingController searchController;
  final List<String> bloodGroups;
  final String selectedBloodGroup;
  final Function(String?) onBloodGroupChanged;

  const HostaHeader({
    super.key,
    required this.searchController,
    required this.bloodGroups,
    required this.selectedBloodGroup,
    required this.onBloodGroupChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.red[800],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.chevron_left),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const Text(
                'BLOOD BANK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[600],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.menu, color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          cursorColor: Colors.white,
                          controller: searchController,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                          decoration: const InputDecoration(
                            hintText:
                                'Search for Hospitals, Ambulance, Doctors...',
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(10),
              SizedBox(
                width: 60,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedBloodGroup,
                    dropdownColor: Colors.red[300],
                    style: const TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.white,
                    items: bloodGroups
                        .map((bg) => DropdownMenuItem(
                              value: bg,
                              child: Text(bg,
                                  style: const TextStyle(color: Colors.white)),
                            ))
                        .toList(),
                    onChanged: onBloodGroupChanged,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BloodDonorScreen extends StatefulWidget {
  const BloodDonorScreen({super.key});

  @override
  State<BloodDonorScreen> createState() => _BloodDonorScreenState();
}

class _BloodDonorScreenState extends State<BloodDonorScreen> {
  late Future<List<BloodDonor>> donorsFuture;
  List<BloodDonor> allDonors = [];
  List<BloodDonor> filteredDonors = [];
  final TextEditingController _searchController = TextEditingController();
  final List<String> _bloodGroups = [
    "ALL",
    "O+",
    "O-",
    "AB+",
    "AB-",
    "A+",
    "A-",
    "B+",
    "B-"
  ];

  Widget _buildBloodGroupDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: DropdownButtonFormField<String>(
        value: _selectedBloodGroup,
        items: _bloodGroups
            .map((bg) => DropdownMenuItem(value: bg, child: Text(bg)))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _selectedBloodGroup = value;
              _onSearchChanged(); // re-filter donors
            });
          }
        },
        decoration: const InputDecoration(
          labelText: 'Filter by Blood Group',
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  String _selectedBloodGroup = "ALL";

  @override
  void initState() {
    super.initState();
    donorsFuture = BloodDonorService.fetchDonors();
    donorsFuture.then((donors) {
      setState(() {
        allDonors = donors;
        filteredDonors = donors;
      });
    });

    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredDonors = allDonors.where((donor) {
        final matchesQuery = donor.name.toLowerCase().contains(query) ||
            donor.bloodGroup.toLowerCase().contains(query) ||
            donor.address.place.toLowerCase().contains(query);

        final matchesBloodGroup = _selectedBloodGroup == "ALL" ||
            donor.bloodGroup == _selectedBloodGroup;

        return matchesQuery && matchesBloodGroup;
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
      body: Column(
        children: [
          HostaHeader(
            searchController: _searchController,
            bloodGroups: _bloodGroups,
            selectedBloodGroup: _selectedBloodGroup,
            onBloodGroupChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedBloodGroup = value;
                  _onSearchChanged();
                });
              }
            },
          ),
          Expanded(
            child: allDonors.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : filteredDonors.isEmpty
                    ? const Center(child: Text('No donors found.'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: filteredDonors.length,
                        itemBuilder: (context, index) {
                          final donor = filteredDonors[index];
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.red[300],
                                child: Text(donor.bloodGroup,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                              title: Text(donor.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '📍 ${donor.address.place}, ${donor.address.pincode}'),
                                  Text('📞 ${donor.phone}'),
                                  Text(
                                    '🩸 Last donated: ${donor.lastDonationDate.toLocal().toString().split(' ')[0]}',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: Colors.red[700],
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddBloodDonor()),
          );
        },
        child: const Icon(Icons.add,color: Colors.white, size: 30),
      ),
    );
  }
}
