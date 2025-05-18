import 'package:flutter/material.dart';
import 'package:hosta/controller/hospital_controller.dart';
import 'package:hosta/helper.dart';
import 'package:hosta/service/location_service.dart';
import 'package:hosta/views/hospitals/hospital_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalcategoryScreen extends StatefulWidget {
  final String selectedType;
  const HospitalcategoryScreen({super.key, required this.selectedType});

  @override
  State<HospitalcategoryScreen> createState() => _HospitalcategoryScreenState();
}

class _HospitalcategoryScreenState extends State<HospitalcategoryScreen> {
  late TextEditingController searchController;
  String searchKeyword = '';

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {
        searchKeyword = searchController.text.toLowerCase();
      });
    });

    // Fetch hospitals if not fetched yet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<hospitalsProvider>(context, listen: false);
      if (provider.hospitals.isEmpty) {
        provider.fetchHospitals();
      }
    });
  }

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
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomHeader(
            title: 'HOSPITALS',
            searchHint: 'Search for Hospitals, Ambulance, Doctors...',
            searchController: searchController,
            onChanged: (value) {}, // Optional, using controller listener
            onBack: () => Navigator.of(context).pop(),
            onMenuPressed: () {},
            onSettingsPressed: () {},
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Consumer<hospitalsProvider>(
                  builder: (context, provider, child) {
                    if (provider.hospitals.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return FutureBuilder(
                      future: getCurrentLocation(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final userLocation = snapshot.data!;
                        final userLat = userLocation.latitude!;
                        final userLon = userLocation.longitude!;

                        final filteredHospitals =
                            provider.hospitals.where((hospital) {
                          final matchesType = hospital.type.toLowerCase() ==
                              widget.selectedType.toLowerCase();
                          final matchesSearch = hospital.name
                              .toLowerCase()
                              .contains(searchKeyword.toLowerCase());

                          // Ensure hospital has valid coordinates
                          if (hospital.latitude == 0 || hospital.longitude == 0)
                            return false;

                          final distance = calculateDistance(
                            userLat,
                            userLon,
                            hospital.latitude,
                            hospital.longitude,
                          );

                          return matchesType && matchesSearch && distance <= 20;
                        }).toList();

                        if (filteredHospitals.isEmpty) {
                          return const Center(
                              child: Text("No hospitals found within 20 km."));
                        }

                        return GridView.builder(
                          itemCount: filteredHospitals.length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.9,
                          ),
                          itemBuilder: (context, index) {
                            final hospital = filteredHospitals[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => HospitalDetailsScreen(
                                    id: hospital.id,
                                    name: hospital.name,
                                    imageUrl: hospital.image?.imageUrl,
                                    phone: hospital.phone,
                                    address: hospital.address,
                                    email: hospital.email,
                                  ),
                                ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey[200],
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      blurRadius: 4,
                                      offset: const Offset(2, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        hospital.image?.imageUrl ??
                                            'https://via.placeholder.com/150',
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          height: 100,
                                          width: double.infinity,
                                          color: Colors.grey,
                                          child: const Icon(Icons.broken_image),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Column(
                                        children: [
                                          Text(
                                            hospital.name,
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.lock_clock,
                                                  color: Colors.green),
                                              SizedBox(width: 4),
                                              Text(
                                                'Open now',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.green,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.phone,
                                                  color: Colors.green),
                                              const SizedBox(width: 4),
                                              GestureDetector(
                                                onTap: () =>
                                                    _callNumber(hospital.phone),
                                                child: Text(
                                                  hospital.phone,
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.green,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
