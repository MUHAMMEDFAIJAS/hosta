import 'package:flutter/material.dart';

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
              Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade700, // Slightly darker green button
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                child: IconButton(
                  icon: Icon(Icons.chevron_left),
                  color: Colors.white,
                  onPressed: () {
                    // Your action here
                    print('Button Pressed');
                  },
                ),
              ),
              const Text(
                'HOSPITAL TYPES',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
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

          // Search bar and Settings icon
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

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          HostaHeader(),
          const SizedBox(height: 10),
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
          width: double.infinity,
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
