import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hosta/model/hospital_model.dart';
import 'package:hosta/service/hospital_service.dart';

class HospitalDetailsScreen extends StatefulWidget {
  final String? id;
  String? name;
  String? imageUrl;
  String? phone;
  String? address;
  String? email;
  //

  HospitalDetailsScreen({
    super.key,
    this.id,
    this.name,
    this.imageUrl,
    this.phone,
    this.address,
    this.email,
  });

  @override
  State<HospitalDetailsScreen> createState() => _HospitalDetailsScreenState();
}

class _HospitalDetailsScreenState extends State<HospitalDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _resolvedAddress;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAddress();
  }

  void _loadAddress() async {
    final hospitals = await HospitalService.fetchHospitals();
    final hospital = hospitals.firstWhere(
      (h) => h.id == widget.id,
      orElse: () => Hospital(
        id: '0',
        name: 'Unknown',
        address: 'Unknown',
        email: 'Unknown',
        phone: 'Unknown',
        type: 'Unknown',
        latitude: 0.0,
        longitude: 0.0,
        workingHours: [],
        specialties: [],
      ),
    );

    try {
      final placemarks =
          await placemarkFromCoordinates(hospital.latitude, hospital.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final address =
            '${p.name}, ${p.locality}, ${p.administrativeArea}, ${p.country}';

        setState(() {
          _resolvedAddress = address;
        });
      }
    } catch (e) {
      setState(() {
        _resolvedAddress = 'Address not available';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FFF5),
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 280,
                width: double.infinity,
                child: Image.network(
                  widget.imageUrl ?? 'https://via.placeholder.com/150',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.grey,
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.green),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),

          // Clinic Name
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.black.withOpacity(0.5),
            child: Text(
              widget.name ?? 'Hospital Name',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // White Card Section
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 0),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tabs
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.black54,
                    indicatorColor: Colors.green,
                    isScrollable: true,
                    tabs: const [
                      Tab(text: 'Information'),
                      Tab(text: 'Specialties'),
                      Tab(text: 'Hours'),
                      Tab(text: 'Location'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Tab Content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildInformationTab(),
                        _buildSpecialtiesTab(),
                        _buildHoursTab(),
                        _buildPlaceholderTab('Location info here'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
              Icons.location_on, _resolvedAddress ?? 'fetch address...'),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.phone, widget.phone ?? '1234567890'),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.email, widget.email ?? 'email'),
          const SizedBox(height: 10),
          _buildInfoRow(
              Icons.star_border, '0 out of 5 stars (based on 0 reviews)'),
          const SizedBox(height: 20),
          const Text(
            'About Us',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialtiesTab() {
    return FutureBuilder<List<Hospital>>(
      future: HospitalService.fetchHospitals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hospitals found'));
        } else {
          // Get the first hospital (or modify to select a specific one)
          final hospital = snapshot.data!.firstWhere(
            (h) => h.id == widget.id,
            orElse: () => Hospital(
              id: '0',
              name: 'Unknown',
              address: 'Unknown',
              email: 'Unknown',
              phone: 'Unknown',
              type: 'Unknown',
              latitude: 0.0,
              longitude: 0.0,
              workingHours: [],
              specialties: [],
            ),
          );

          if (hospital.specialties.isEmpty) {
            return Center(
                child: Text('No specialties found for this hospital'));
          }

          return ListView.separated(
            itemCount: hospital.specialties.length,
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final specialty = hospital.specialties[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  specialty
                      .name, // Now displaying specialty name instead of hospital name
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildHoursTab() {
    return FutureBuilder<List<Hospital>>(
      future: HospitalService.fetchHospitals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hospitals found'));
        } else {
          // Get the specific hospital matching widget.id
          final hospital = snapshot.data!.firstWhere(
            (h) => h.id == widget.id,
            orElse: () => Hospital(
              id: '0',
              name: 'Unknown',
              address: 'Unknown',
              email: 'Unknown',
              phone: 'Unknown',
              type: 'Unknown',
              latitude: 0.0,
              longitude: 0.0,
              workingHours: [],
              specialties: [],
            ),
          );

          if (hospital.workingHours.isEmpty) {
            return Center(child: Text('No working hours available'));
          }

          return ListView.builder(
            itemCount: hospital.workingHours.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final dayInfo = hospital.workingHours[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 20, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        dayInfo.day,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    Text(
                      dayInfo.isHoliday
                          ? 'Holiday'
                          : '${dayInfo.openingTime} - ${dayInfo.closingTime}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: dayInfo.isHoliday ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildPlaceholderTab(String text) {
    return FutureBuilder<List<Hospital>>(
      future: HospitalService.fetchHospitals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hospital data found'));
        } else {
          final hospital = snapshot.data!.firstWhere(
            (h) => h.id == widget.id,
            orElse: () => Hospital(
              id: '0',
              name: 'Unknown',
              address: 'Unknown',
              email: 'Unknown',
              phone: 'Unknown',
              type: 'Unknown',
              latitude: 0.0,
              longitude: 0.0,
              workingHours: [],
              specialties: [],
            ),
          );

          return FutureBuilder<List<Placemark>>(
            future:
                placemarkFromCoordinates(hospital.latitude, hospital.longitude),
            builder: (context, placemarkSnapshot) {
              if (placemarkSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (placemarkSnapshot.hasError) {
                return const Center(child: Text('Failed to get location'));
              } else if (!placemarkSnapshot.hasData ||
                  placemarkSnapshot.data!.isEmpty) {
                return const Center(child: Text('No location found'));
              } else {
                final placemark = placemarkSnapshot.data!.first;
                final address = '${placemark.name}, '
                    '${placemark.locality}, '
                    '${placemark.administrativeArea}, '
                    '${placemark.country}';

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.green, size: 40),
                      const SizedBox(height: 10),
                      Text(
                        address,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}
