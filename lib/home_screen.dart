import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:hosta/views/ambulance/ambulance_screen.dart';
import 'package:hosta/views/blood%20donar/blood_donar.dart';
import 'package:hosta/views/doctors/doctors_screen.dart';

import 'package:hosta/views/hospitals/hospital_types.dart';
import 'package:hosta/views/specialities/speaciaalities_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HostaHeader extends StatelessWidget {
  const HostaHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.green[800],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'HOSTA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[600],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.menu, color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              // Search Bar
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.green[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.search, color: Colors.white),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 14, color: Colors.white),
                          decoration: InputDecoration(
                            hintText:
                                'Search for Hospitals, Ambulance, Doctors...',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Settings Button
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[600],
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    const Icon(Icons.settings, color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();

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
  }

  @override
  void dispose() {
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
                const HostaHeader(),
                const SizedBox(height: 20),

                // Show carousel only if ad loaded
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
                      children: [
                        _ServiceItem(
                          icon: Icons.local_hospital,
                          label: 'Hospitals',
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HospitalTypesScreen(),
                            ));
                          },
                        ),
                        _ServiceItem(
                          icon: Icons.person_2_rounded,
                          label: 'Doctors',
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const DoctorsScreen(),
                            ));
                          },
                        ),
                        _ServiceItem(
                          icon: Icons.local_hospital,
                          label: 'Specialities',
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SpecialtiesScreen(),
                            ));
                          },
                        ),
                        _ServiceItem(
                          icon: Icons.medical_information,
                          label: 'Ambulance',
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AmbulanceScreen(),
                            ));
                          },
                        ),
                        _ServiceItem(
                          icon: Icons.water_drop,
                          label: 'Blood Bank',
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const BloodDonorScreen(),
                            ));
                          },
                        ),
                      ],
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
            Text(label, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
