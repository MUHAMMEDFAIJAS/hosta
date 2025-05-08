import 'package:flutter/material.dart';
import 'package:hosta/controller/hospital_controller.dart';
import 'package:hosta/views/hospitals/hospital_category_screen.dart';
import 'package:provider/provider.dart';

class HospitalTypesScreen extends StatefulWidget {
  const HospitalTypesScreen({super.key});

  @override
  State<HospitalTypesScreen> createState() => _HospitalTypesScreenState();
}

class _HospitalTypesScreenState extends State<HospitalTypesScreen> {
  final Map<String, String> typeImages = {
    'Allopathy': 'assets/images/Rectangle 1142 (1).png',
    'Ayurveda': 'assets/images/Rectangle 1144.png',
    'homeopathy': 'assets/images/Rectangle 1143.png',
    'acupuncture': 'assets/images/image.png',
    'unani': 'assets/images/Rectangle 1145.png'
  };

  final Map<String, Color> typeColors = {
    'Allopathy': Colors.blue,
    'Ayurveda': Colors.orange,
    'homeopathy': Colors.green,
    'acupuncture': Colors.brown,
    'unani': Colors.red,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<hospitalsProvider>(context, listen: false).fetchHospitals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HostaHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<hospitalsProvider>(
                builder: (context, provider, child) {
                  if (provider.hospitals.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Get unique hospital types
                  final types = provider.hospitals
                      .map((hospital) => hospital.type)
                      .toSet()
                      .toList();

                  if (types.isEmpty) {
                    return const Center(child: Text('No hospital types found'));
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: types.length,
                    itemBuilder: (context, index) {
                      final type = types[index];
                      return HospitalTypeCard(
                        type: type,
                        imagePath: typeImages[type] ??
                            'assets/images/Rectangle 1145.png',
                        color: typeColors[type] ?? Colors.green,
                        onTap: () {
                          Provider.of<hospitalsProvider>(context, listen: false)
                              .fetchHospitalsByType(type);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HospitalcategoryScreen(
                                type: type,
                              ),
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
  final Color color;
  final VoidCallback onTap;

  const HospitalTypeCard({
    super.key,
    required this.type,
    required this.imagePath,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.2),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                type,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
