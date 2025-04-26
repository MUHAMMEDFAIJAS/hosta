// import 'package:flutter/material.dart';
// import 'package:hosta/views/home_screen.dart';

// class HospitalsScreen extends StatelessWidget {
//   const HospitalsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(20),
//             height: 235,
//             decoration: BoxDecoration(
//               color: Colors.green[800],
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20),
//               ),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.of(context).push(MaterialPageRoute(
//                           builder: (context) => HomeScreen(),
//                         ));
//                       },
//                       child: Icon(
//                         Icons.arrow_back,
//                         size: 40,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Text(
//                       'HOSPITAL TYPES',
//                       style: TextStyle(color: Colors.white, fontSize: 22),
//                     ),
//                     Icon(
//                       Icons.menu,
//                       size: 40,
//                       color: Colors.white,
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 25),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       height: 40,
//                       width: 300,
//                       color: Colors.white,
//                     ),
//                     Icon(
//                       Icons.search,
//                       size: 40,
//                       color: Colors.white,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:hosta/views/hospitals/home_screen.dart';
import 'package:hosta/views/hospitals/hospital_details_screen.dart';

class HospitalsScreen extends StatelessWidget {
  const HospitalsScreen({super.key});

  // Sample hospital data with image and title
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

          // GridView starts here
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: hospitalTypes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final hospital = hospitalTypes[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HospitaldetailsScreen(),
                      ));
                    },
                    child: Container(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            child: Image.network(
                              hospital['image']!,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            hospital['title']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
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
