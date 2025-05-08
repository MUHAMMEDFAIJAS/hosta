class Address {
  final String place;
  final int pincode;

  Address({required this.place, required this.pincode});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      place: json['place'],
      pincode: json['pincode'],
    );
  }
}

class BloodDonor {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int age;
  final String bloodGroup;
  final DateTime lastDonationDate;
  final Address address;

  BloodDonor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.bloodGroup,
    required this.lastDonationDate,
    required this.address,
  });

  factory BloodDonor.fromJson(Map<String, dynamic> json) {
    return BloodDonor(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      age: json['age'],
      bloodGroup: json['bloodGroup'],
      lastDonationDate: DateTime.parse(json['lastDonationDate']),
      address: Address.fromJson(json['address']),
    );
  }
}
