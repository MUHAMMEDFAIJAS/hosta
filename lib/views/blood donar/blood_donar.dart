import 'package:flutter/material.dart';
import 'package:hosta/model/blood_bank_model.dart';
import 'package:hosta/service/blood_bank_service.dart';
import 'package:hosta/views/blood%20donar/add_blood_donor.dart';

class HostaHeader extends StatelessWidget {
  final TextEditingController searchController;

  const HostaHeader({super.key, required this.searchController});

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
              // const SizedBox(width: 10),
              // Container(
              //   padding: const EdgeInsets.all(8),
              //   decoration: BoxDecoration(
              //     color: Colors.red[600],
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child:
              //       const Icon(Icons.settings, color: Colors.white, size: 20),
              // ),
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
        final nameLower = donor.name.toLowerCase();
        final bloodGroupLower = donor.bloodGroup.toLowerCase();
        final placeLower = donor.address.place.toLowerCase();
        return nameLower.contains(query) ||
            bloodGroupLower.contains(query) ||
            placeLower.contains(query);
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
          HostaHeader(searchController: _searchController),
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
    );
  }
}
