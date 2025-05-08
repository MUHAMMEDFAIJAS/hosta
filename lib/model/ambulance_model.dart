class Ambulance {
  final String id;
  final String serviceName;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final String email;
  final String vehicleType;

  Ambulance({
    required this.id,
    required this.serviceName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.email,
    required this.vehicleType,
  });

  factory Ambulance.fromJson(Map<String, dynamic> json) {
    return Ambulance(
      id: json['_id'],
      serviceName: json['serviceName'],
      address: json['address'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      phone: json['phone'],
      email: json['email'],
      vehicleType: json['vehicleType'],
    );
  }
}
