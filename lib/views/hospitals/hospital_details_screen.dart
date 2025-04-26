import 'package:flutter/material.dart';
import 'package:hosta/views/hospitals/home_screen.dart';

class HospitaldetailsScreen extends StatelessWidget {
  const HospitaldetailsScreen({super.key});

  final List<Map<String, String>> hospitalTypes = const [
    {'title': 'General Hospital', 'image': 'https://via.placeholder.com/150'},
    {'title': 'Eye Hospital', 'image': 'https://via.placeholder.com/150'},
    {'title': 'Dental Clinic', 'image': 'https://via.placeholder.com/150'},
    {'title': 'Cardiology', 'image': 'https://via.placeholder.com/150'},
    {'title': 'Orthopedic', 'image': 'https://via.placeholder.com/150'},
    {'title': 'ENT', 'image': 'https://via.placeholder.com/150'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            height: 235,
            decoration: BoxDecoration(
              color: Colors.green[800],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ));
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'HOSPITAL TYPES',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    const Icon(
                      Icons.menu,
                      size: 40,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40,
                      width: 300,
                      color: Colors.white,
                    ),
                    const Icon(
                      Icons.search,
                      size: 40,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ListView starts here
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: hospitalTypes.length,
              itemBuilder: (context, index) {
                final hospital = hospitalTypes[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
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
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        child: Image.network(
                          hospital['image']!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          hospital['title']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
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
