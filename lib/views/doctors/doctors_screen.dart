import 'package:flutter/material.dart';

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header
          Container(
            padding:
                const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.green[700],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    const Text(
                      'Doctors',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.menu, color: Colors.white, size: 28),
                  ],
                ),
                const SizedBox(height: 20),

                // Search bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search for Doctors',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // List of Doctors
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                DoctorTile(
                  name: 'Dr. Muhammed Junaid P.P',
                  specialization: 'Generic Practitioner',
                  availability: [
                    {
                      'day': 'Monday 27 March',
                      'location': 'Life Care Clinics',
                      'time': '09:00AM to 05:00PM'
                    },
                    {
                      'day': 'Tuesday 28 March',
                      'location': 'Life Care Clinics',
                      'time': '09:00AM to 05:00PM'
                    },
                    {
                      'day': 'Wednesday 29 March',
                      'location': 'Life Care Clinics',
                      'time': '09:00AM to 05:00PM'
                    },
                  ],
                ),
                const SizedBox(height: 10),
                DoctorTile(
                  name: 'Dr. Rajeev K.S',
                  specialization: 'Generic Practitioner',
                  availability: [
                    {
                      'day': 'Thursday 30 March',
                      'location': 'City Hospital',
                      'time': '10:00AM to 04:00PM'
                    },
                  ],
                ),
                const SizedBox(height: 10),
                DoctorTile(
                  name: 'Dr. Abdul Vaheed K.',
                  specialization: 'Dentist',
                  availability: [
                    {
                      'day': 'Friday 31 March',
                      'location': 'Smile Dental Clinic',
                      'time': '11:00AM to 06:00PM'
                    },
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorTile extends StatelessWidget {
  final String name;
  final String specialization;
  final List<Map<String, String>> availability;

  const DoctorTile({
    super.key,
    required this.name,
    required this.specialization,
    required this.availability,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Text(
        specialization,
        style: const TextStyle(color: Colors.grey),
      ),
      children: availability.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['day']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 5),
              Text(item['location']!),
              Text(item['time']!),
            ],
          ),
        );
      }).toList(),
    );
  }
}
