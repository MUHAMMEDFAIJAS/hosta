// lib/widgets/hosta_header.dart

import 'package:flutter/material.dart';

class HostaHeader extends StatelessWidget {
  final TextEditingController controller;

  const HostaHeader({super.key, required this.controller});

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
          const SizedBox(height: 50),
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
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.green[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
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
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class CustomHeader extends StatelessWidget {
  final String title;
  final String searchHint;
  final VoidCallback? onBack;
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onMenuPressed;
  final TextEditingController? searchController; // Added searchController here
  final ValueChanged<String>? onChanged; // To handle text changes

  const CustomHeader({
    super.key,
    required this.title,
    this.searchHint = 'Search...',
    this.onBack,
    this.onSettingsPressed,
    this.onMenuPressed,
    this.searchController, // Add this to constructor
    this.onChanged, // Add this to constructor for callback on text change
  });

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
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.chevron_left),
                  color: Colors.white,
                  onPressed: onBack ?? () => Navigator.of(context).pop(),
                ),
              ),

              // Title
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Menu Button
              GestureDetector(
                onTap: onMenuPressed,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.menu, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search Bar + Settings Icon
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.green[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          cursorColor: Colors.white,

                          controller: searchController, // Use controller here
                          onChanged: onChanged, // Handle text changes
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                          decoration: InputDecoration(
                            hintText: searchHint,
                            hintStyle: const TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
             
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
