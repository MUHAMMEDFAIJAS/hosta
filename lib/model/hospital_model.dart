class Hospital {
  final String id;
  final String name;
  final String address;
  final String email;
  final String phone;
  final String type;
  final String? emergencyContact;
  final double latitude;
  final double longitude;
  final HospitalImage? image;
  final List<WorkingHour> workingHours;
  final List<Specialty> specialties; 

  Hospital({
    required this.id,
    required this.name,
    required this.address,
    required this.email,
    required this.phone,
    required this.type,
    this.emergencyContact,
    required this.latitude,
    required this.longitude,
    this.image,
    required this.workingHours,
    required this.specialties,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      type: json['type'] ?? '',
      emergencyContact: json['emergencyContact'],
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      image:
          json['image'] != null ? HospitalImage.fromJson(json['image']) : null,
      workingHours: (json['working_hours'] as List? ?? [])
          .map((e) => WorkingHour.fromJson(e))
          .toList(),
      specialties: (json['specialties'] as List? ?? []) // ✅ Add this
          .map((e) => Specialty.fromJson(e))
          .toList(),
    );
  }
}

class HospitalImage {
  final String imageUrl;
  final String publicId;

  HospitalImage({
    required this.imageUrl,
    required this.publicId,
  });

  factory HospitalImage.fromJson(Map<String, dynamic> json) {
    return HospitalImage(
      imageUrl: json['imageUrl'] ?? '',
      publicId: json['public_id'] ?? '',
    );
  }
}

class WorkingHour {
  final String day;
  final String? openingTime;
  final String? closingTime;
  final bool isHoliday;

  WorkingHour({
    required this.day,
    this.openingTime,
    this.closingTime,
    required this.isHoliday,
  });

  factory WorkingHour.fromJson(Map<String, dynamic> json) {
    return WorkingHour(
      day: json['day'] ?? '',
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
      isHoliday: json['is_holiday'] ?? false,
    );
  }
}

class Specialty {
  final String name;
  final String description;
  final String departmentInfo;
  final String phone;
  final List<Doctor> doctors;

  Specialty({
    required this.name,
    required this.description,
    required this.departmentInfo,
    required this.phone,
    required this.doctors,
  });

  factory Specialty.fromJson(Map<String, dynamic> json) {
    return Specialty(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      departmentInfo: json['department_info'] ?? '',
      phone: json['phone'] ?? '',
      doctors: (json['doctors'] as List<dynamic>?)
              ?.map((doctor) => Doctor.fromJson(doctor))
              .toList() ??
          [],
    );
  }
}

class Doctor {
  final String name;
  final String qualification;
  final List<Consulting> consulting;

  Doctor({
    required this.name,
    required this.qualification,
    required this.consulting,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      name: json['name'] ?? '',
      qualification: json['qualification'] ?? '',
      consulting: (json['consulting'] as List<dynamic>?)
              ?.map((consult) => Consulting.fromJson(consult))
              .toList() ??
          [],
    );
  }
}

class Consulting {
  final String day;
  final String startTime;
  final String endTime;

  Consulting({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory Consulting.fromJson(Map<String, dynamic> json) {
    return Consulting(
      day: json['day'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
    );
  }
}
