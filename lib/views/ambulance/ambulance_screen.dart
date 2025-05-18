import 'package:flutter/material.dart';
import 'package:hosta/helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/ambulance_model.dart';
import '../../service/ambulance_service.dart';

class AmbulanceScreen extends StatefulWidget {
  const AmbulanceScreen({super.key});

  @override
  State<AmbulanceScreen> createState() => _AmbulanceScreenState();
}

class _AmbulanceScreenState extends State<AmbulanceScreen> {
  late Future<List<Ambulance>> ambulanceFuture;
  List<Ambulance> allAmbulances = [];
  List<Ambulance> filteredAmbulances = [];

  final TextEditingController _searchController = TextEditingController();
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
    ambulanceFuture = AmbulanceService.fetchAmbulances();

    // After fetching ambulances, save to allAmbulances and filteredAmbulances
    ambulanceFuture.then((ambulances) {
      setState(() {
        allAmbulances = ambulances;
        filteredAmbulances = ambulances;
      });
    });

    // Add listener to search controller to filter results
    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        filteredAmbulances = allAmbulances.where((ambulance) {
          return ambulance.serviceName.toLowerCase().contains(query) ||
              ambulance.address.toLowerCase().contains(query);
        }).toList();
      });
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
          CustomHeader(
            title: 'AMBULANCES',
            searchHint: 'Search by ambulnces...',
            searchController: _searchController,
            onChanged: (_) {}, // search handled by controller listener
            onBack: () => Navigator.of(context).pop(),
            onMenuPressed: () {},
            onSettingsPressed: () {},
          ),
          const SizedBox(height: 10),
          Expanded(
            child: allAmbulances.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : filteredAmbulances.isEmpty
                    ? const Center(child: Text('No ambulance services found.'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: filteredAmbulances.length,
                        itemBuilder: (context, index) {
                          final ambulance = filteredAmbulances[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.shade100,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/amulance.jpeg',
                                  width: 150,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  ambulance.serviceName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text('📝 ${ambulance.address}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () => _callNumber(ambulance.phone),
                                  child: Text(
                                    '📞 ${ambulance.phone}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      // decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
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
