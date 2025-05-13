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
      day: json['day'],
      startTime: json['start_time'],
      endTime: json['end_time'],
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
      name: json['name'],
      qualification: json['qualification'],
      consulting: (json['consulting'] as List)
          .map((item) => Consulting.fromJson(item))
          .toList(),
    );
  }
}
