class LoginResponse {
  final bool status;
  final int code;
  final String message;
  final String token;
  final User user;

  LoginResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      token: json['data']?['token'] ?? '',
      user: User.fromJson(json['data']?['user'] ?? {}),
    );
  }
}

class User {
  final int id;
  final String? email;
  final String? phone;
  final String? fName;
  final String? lName;

  User({
    required this.id,
    this.email,
    this.phone,
    this.fName,
    this.lName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'],
      phone: json['phone'],
      fName: json['f_name'],
      lName: json['l_name'],
    );
  }
}
