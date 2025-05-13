class Specialty {
  final String name;
  final String description;
  final List<Doctor> doctors;

  Specialty({
    required this.name,
    required this.description,
    required this.doctors,
  });

  factory Specialty.fromJson(Map<String, dynamic> json) {
    var doctorList = (json['doctors'] as List)
        .map((doctorJson) => Doctor.fromJson(doctorJson))
        .toList();

    return Specialty(
      name: json['name'],
      description: json['description'],
      doctors: doctorList,
    );
  }
}

class Doctor {
  final String name;
  final String qualification;
  final List<ConsultingTime> consulting;

  Doctor({
    required this.name,
    required this.qualification,
    required this.consulting,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    var consultingList = (json['consulting'] as List)
        .map((consultingJson) => ConsultingTime.fromJson(consultingJson))
        .toList();

    return Doctor(
      name: json['name'],
      qualification: json['qualification'],
      consulting: consultingList,
    );
  }
}

class ConsultingTime {
  final String day;
  final String startTime;
  final String endTime;

  ConsultingTime({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory ConsultingTime.fromJson(Map<String, dynamic> json) {
    return ConsultingTime(
      day: json['day'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }
}
