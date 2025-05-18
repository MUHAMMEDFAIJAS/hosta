import 'package:flutter/material.dart';
import 'package:hosta/model/blood_bank_model.dart';
import 'package:hosta/service/blood_bank_service.dart';

class BloodDonorProvider with ChangeNotifier {
  List<BloodDonor> _allDonors = [];
  List<BloodDonor> _filteredDonors = [];
  String _searchQuery = '';
  String _selectedBloodGroup = 'ALL';
  bool _isLoading = true;

  List<BloodDonor> get filteredDonors => _filteredDonors;
  bool get isLoading => _isLoading;
  String get selectedBloodGroup => _selectedBloodGroup;

  BloodDonorProvider() {
    fetchDonors();
  }

  Future<void> fetchDonors() async {
    try {
      _isLoading = true;
      notifyListeners();

      _allDonors = await BloodDonorService.fetchDonors();
      _applyFilters();
    } catch (e) {
      _filteredDonors = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void updateBloodGroup(String group) {
    _selectedBloodGroup = group;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredDonors = _allDonors.where((donor) {
      final matchesQuery = donor.name.toLowerCase().contains(_searchQuery) ||
          donor.bloodGroup.toLowerCase().contains(_searchQuery) ||
          donor.address.place.toLowerCase().contains(_searchQuery);

      final matchesBloodGroup = _selectedBloodGroup == 'ALL' ||
          donor.bloodGroup == _selectedBloodGroup;

      return matchesQuery && matchesBloodGroup;
    }).toList();

    notifyListeners();
  }

// In your BloodDonorProvider class, add these methods:

  Future<bool> addDonor(BloodDonor newDonor) async {
    try {
      _allDonors.insert(0, newDonor); // Add to beginning of list
      _applyFilters();
      return true;
    } catch (e) {
      return false;
    }
  }

  void removeDonor(String donorId) {
    _allDonors.removeWhere((donor) => donor.id == donorId);
    _applyFilters();
  }
}
