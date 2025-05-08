class UserRegistration {
  final String name;
  final String email;
  final String password;
  final String phone;

  UserRegistration({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    };
  }
}


class UserData {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String createdAt;
  final String updatedAt;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class LoginResponse {
  final String status;
  final String token;
  final UserData user;
  final String message;

  LoginResponse({
    required this.status,
    required this.token,
    required this.user,
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      token: json['token'],
      user: UserData.fromJson(json['data']),
      message: json['message'],
    );
  }
}
