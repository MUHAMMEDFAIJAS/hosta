import 'package:flutter/material.dart';
import 'package:hosta/controller/donor_controllor.dart';
import 'package:hosta/helper.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import 'package:hosta/model/blood_bank_model.dart';
import 'package:hosta/views/blood%20donar/add_blood_donor.dart';
import 'package:url_launcher/url_launcher.dart';

class HostaHeader extends StatefulWidget {
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
  State<HostaHeader> createState() => _HostaHeaderState();
}

class _HostaHeaderState extends State<HostaHeader> {
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
                          controller: widget.searchController,
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
              const Gap(10),
              CustomDropdown(
                items: [
                  'ALL',
                  'O+',
                  'O-',
                  'A+',
                  'A-',
                  'B+',
                  'B-',
                  'AB+',
                  'AB-'
                ],
                selectedItem: widget.selectedBloodGroup,
                onChanged: (value) {
                  widget.onBloodGroupChanged(value);
                },
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
  void _callNumber(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch phone app')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BloodDonorProvider>(context, listen: false);
    provider.fetchDonors();

    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final provider = Provider.of<BloodDonorProvider>(context, listen: false);
    provider.updateSearchQuery(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BloodDonorProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              HostaHeader(
                searchController: _searchController,
                bloodGroups: _bloodGroups,
                selectedBloodGroup: provider.selectedBloodGroup,
                onBloodGroupChanged: (value) {
                  if (value != null) {
                    provider.updateBloodGroup(value);
                  }
                },
              ),
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.filteredDonors.isEmpty
                        ? const Center(child: Text('No donors found.'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: provider.filteredDonors.length,
                            itemBuilder: (context, index) {
                              final donor = provider.filteredDonors[index];
                              return Card(
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.red[300],
                                    child: Text(donor.bloodGroup,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ),
                                  title: Text(donor.name),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '📍 ${donor.address.place}, ${donor.address.pincode}'),
                                      GestureDetector(
                                        onTap: () => _callNumber(donor.phone),
                                        child: Text(
                                          '📞 ${donor.phone}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: Colors.red[700],
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddBloodDonor()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
