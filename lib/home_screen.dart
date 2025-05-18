import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:hosta/views/ambulance/ambulance_screen.dart';
import 'package:hosta/views/blood%20donar/blood_donar.dart';
import 'package:hosta/views/doctors/doctors_screen.dart';

import 'package:hosta/views/hospitals/hospital_types.dart';
import 'package:hosta/views/specialities/speaciaalities_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hosta/helper.dart' as helper;
import 'package:location/location.dart';

class ServiceItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  ServiceItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;
  TextEditingController _searchController = TextEditingController();
  List<ServiceItem> allServices = [];
  List<ServiceItem> filteredServices = [];
  LocationData? _locationData;

  @override
  void initState() {
    super.initState();
    _getLocationOnStartup();

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad failed to load: $error');
        },
      ),
    );

    _bannerAd.load();

    allServices = [
      ServiceItem(
        icon: Icons.local_hospital,
        label: 'Hospitals',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => HospitalTypesScreen(),
        )),
      ),
      ServiceItem(
        icon: Icons.person_2_rounded,
        label: 'Doctors',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const DoctorsScreen(),
        )),
      ),
      ServiceItem(
        icon: Icons.local_hospital,
        label: 'Specialities',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const SpecialtiesScreen(),
        )),
      ),
      ServiceItem(
        icon: Icons.medical_information,
        label: 'Ambulance',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const AmbulanceScreen(),
        )),
      ),
      ServiceItem(
        icon: Icons.water_drop,
        label: 'Blood Bank',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const BloodDonorScreen(),
        )),
      ),
    ];

    filteredServices = List.from(allServices);

    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredServices = allServices
          .where((item) => item.label.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _getLocationOnStartup() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    LocationData currentLocation = await location.getLocation();
    setState(() {
      _locationData = currentLocation;
    });

    print(
        "Current location: ${_locationData?.latitude}, ${_locationData?.longitude}");
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> carouselItems = [];

    if (_isAdLoaded) {
      carouselItems.add(
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          alignment: Alignment.center,
          child: SizedBox(
            height: _bannerAd.size.height.toDouble(),
            width: _bannerAd.size.width.toDouble(),
            child: AdWidget(ad: _bannerAd),
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                helper.HostaHeader(
                  controller: _searchController,
                ),
                const SizedBox(height: 20),
                if (carouselItems.isNotEmpty)
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 150,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 10),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      pauseAutoPlayOnTouch: true,
                      pauseAutoPlayOnManualNavigate: true,
                      enlargeCenterPage: true,
                    ),
                    items: carouselItems,
                  )
                else
                  const SizedBox(
                    height: 150,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        'Our Services',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      children: filteredServices
                          .map((item) => _ServiceItem(
                                icon: item.icon,
                                label: item.label,
                                onTap: item.onTap,
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Service Item Widget (unchanged)
class _ServiceItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ServiceItem({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(31, 205, 123, 123),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: Colors.green),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight
                    .normal, // Will use Poppins because it's set globally
              ),
            )
          ],
        ),
      ),
    );
  }
}
