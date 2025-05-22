import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hosta/model/user_model.dart';
import 'package:hosta/service/auth_service.dart';
import 'package:hosta/service/google_signinapi.dart';
import 'package:hosta/views/privacy%20policy/privacypolicy_screen.dart';

import 'package:hosta/views/ambulance/ambulance_screen.dart';
import 'package:hosta/views/blood%20donar/blood_donar.dart';
import 'package:hosta/views/doctors/doctors_screen.dart';

import 'package:hosta/views/hospitals/hospital_types.dart';
import 'package:hosta/views/signup/login_screen.dart';
import 'package:hosta/views/specialities/speaciaalities_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hosta/helper.dart' as helper;
import 'package:location/location.dart';

class ServiceItem {
  final IconData? icon;
  final ImageProvider? image;
  final String label;
  final VoidCallback onTap;

  ServiceItem({
    this.icon,
    this.image,
    required this.label,
    required this.onTap,
  }) : assert(icon != null || image != null,
            'Either icon or image must be provided');
}

class HomeScreen extends StatefulWidget {
  final AppUser user; 
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        image: AssetImage('assets/images/solar_hospital-linear.png'),
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
        image: AssetImage('assets/images/amblnce.png'),
        label: 'Ambulance',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const AmbulanceScreen(),
        )),
      ),
      ServiceItem(
        icon: Icons.water_drop,
        label: 'Blood Bank',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => BloodDonorScreen(),
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

  void _logout() async {
    try {
      // Optional: Check if Google user is signed in
      if (await GoogleSignIn().isSignedIn()) {
        await GoogleSigninApi.logout();
      }

      // TODO: If you're storing email/password login info via SharedPreferences, clear them here

      // Navigate to login screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      print("Logout failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed')),
      );
    }
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
      key: _scaffoldKey,
      endDrawerEnableOpenDragGesture: false,
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 250,
              child: DrawerHeader(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.green[800],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: widget.user.photoUrl != null
                          ? NetworkImage(widget.user.photoUrl!)
                          : const AssetImage('assets/images/profile.png')
                              as ImageProvider,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.user.displayName ?? 'User Name',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      widget.user.email,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const PrivacyPolicyScreen(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                _logout();
                AuthService().signOut(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                helper.HostaHeader(
                  controller: _searchController,
                  onMenuTap: () {
                    _scaffoldKey.currentState
                        ?.openEndDrawer(); // ✅ Opens right drawer
                  },
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
                      padding: const EdgeInsets.only(bottom: 40),
                      children: filteredServices
                          .map((item) => _ServiceItem(
                                icon: item.icon,
                                image: item.image,
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
  final IconData? icon;
  final ImageProvider? image;
  final String label;
  final VoidCallback? onTap;

  const _ServiceItem({
    this.icon,
    this.image,
    required this.label,
    this.onTap,
  }) : assert(icon != null || image != null,
            'Either icon or image must be provided');

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
            if (icon != null)
              Icon(icon, size: 60, color: Colors.green)
            else if (image != null)
              Image(
                image: image!,
                height: 60,
                width: 60,
                fit: BoxFit.contain,
              ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
