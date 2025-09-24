class RegisterResponse {
  final bool status;
  final int code;
  final int pin;
  final String message;
  final RegisterData? data;

  RegisterResponse({
    required this.status,
    required this.code,
    required this.pin,
    required this.message,
    this.data,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      pin: json['pin'] ?? 0,
      message: json['message'] ?? "",
      data: json['data'] != null ? RegisterData.fromJson(json['data']) : null,
    );
  }
}

class RegisterData {
  final String fName;
  final String lName;
  final String phone;
  final String email;
  final String updatedAt;
  final String createdAt;
  final int id;

  RegisterData({
    required this.fName,
    required this.lName,
    required this.phone,
    required this.email,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      fName: json['f_name'] ?? "",
      lName: json['l_name'] ?? "",
      phone: json['phone'] ?? "",
      email: json['email'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      createdAt: json['created_at'] ?? "",
      id: json['id'] ?? 0,
    );
  }
}
