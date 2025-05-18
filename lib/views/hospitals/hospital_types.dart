import 'package:flutter/material.dart';
import 'package:hosta/controller/hospital_controller.dart';
import 'package:hosta/helper.dart';
import 'package:hosta/views/hospitals/hospital_category_screen.dart';
import 'package:provider/provider.dart';

class HospitalTypesScreen extends StatefulWidget {
  const HospitalTypesScreen({super.key});

  @override
  State<HospitalTypesScreen> createState() => _HospitalTypesScreenState();
}

class _HospitalTypesScreenState extends State<HospitalTypesScreen> {
  late TextEditingController searchController;
  String searchKeyword = '';

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<hospitalsProvider>(context, listen: false).fetchHospitals();
    });

    searchController.addListener(() {
      setState(() {
        searchKeyword = searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }


  String getImageForType(String type) {
    final lowerType = type.toLowerCase();
    if (lowerType.contains('allopathy')) {
      return 'assets/images/Rectangle 1142 (1).png';
    } else if (lowerType.contains('ayurveda')) {
      return 'assets/images/Rectangle 1144.png';
    } else if (lowerType.contains('homeopathy')) {
      return 'assets/images/Rectangle 1143.png';
    } else if (lowerType.contains('acupuncture')) {
      return 'assets/images/image.png';
    } else if (lowerType.contains('unani')) {
      return 'assets/images/Rectangle 1145.png';
    }
    // Default image if none match
    return 'assets/images/Rectangle 1145.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomHeader(
            title: 'HOSPITAL TYPES',
            searchHint: 'Search for Hospitals, Ambulance, Doctors...',
            onBack: () => Navigator.of(context).pop(),
            onMenuPressed: () {},
            onSettingsPressed: () {},
            searchController: searchController,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<hospitalsProvider>(
                builder: (context, provider, child) {
                  if (provider.hospitals.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Get unique types and filter by search keyword
                  final types = provider.hospitals
                      .map((hospital) => hospital.type)
                      .toSet()
                      .where(
                          (type) => type.toLowerCase().contains(searchKeyword))
                      .toList();

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200, // Max width for each grid item
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.9, // Adjust height-to-width ratio
                    ),
                    itemCount: types.length,
                    itemBuilder: (context, index) {
                      final type = types[index];
                      return HospitalTypeCard(
                        type: type,
                        imagePath: getImageForType(type),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HospitalcategoryScreen(selectedType: type),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HospitalTypeCard extends StatelessWidget {
  final String type;
  final String imagePath;
  final VoidCallback onTap;

  const HospitalTypeCard({
    super.key,
    required this.type,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(12), // margin outside card
        child: Container(
          width: 180,
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.asset(
                  imagePath,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  type,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
