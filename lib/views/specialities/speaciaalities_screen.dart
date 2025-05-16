import 'package:flutter/material.dart';
import 'package:hosta/model/hospital_model.dart';
import 'package:hosta/service/hospital_service.dart';

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
                'SPECIALITIES',
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

class SpecialtiesScreen extends StatefulWidget {
  const SpecialtiesScreen({super.key});

  @override
  State<SpecialtiesScreen> createState() => _SpecialtiesScreenState();
}

class _SpecialtiesScreenState extends State<SpecialtiesScreen> {
  List<Specialty> specialties = [];
  bool isLoading = true;
  int? expandedIndex; // 👈 Track the currently expanded specialty

  @override
  void initState() {
    super.initState();
    _loadSpecialties();
  }

  Future<void> _loadSpecialties() async {
    final fetchedSpecialties = await HospitalService.fetchSpecialties();
    setState(() {
      specialties = fetchedSpecialties;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const HostaHeader(),
          const SizedBox(height: 20),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: specialties.length,
                    itemBuilder: (context, index) {
                      return _buildSpecialtyCard(index);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildSpecialtyCard(int index) {
    final specialty = specialties[index];
    final isExpanded = expandedIndex == index;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              expandedIndex = isExpanded ? null : index;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  specialty.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),

        // 👇 Expanded content
        if (isExpanded)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(color: Colors.green),
                const SizedBox(height: 10),
                Text(
                  specialty.description.isNotEmpty
                      ? specialty.description
                      : 'No description available.',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Doctors:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                ...specialty.doctors.map(
                  (doctor) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('• ${doctor.name}'),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
