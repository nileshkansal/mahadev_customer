import 'package:dio/dio.dart';
import 'package:mahadev_customer/core/network/api_service.dart';
import 'package:mahadev_customer/features/users/data/models/login_response.dart';
import 'package:mahadev_customer/features/users/data/models/register_response.dart';
import 'package:mahadev_customer/core/utils/app_strings.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<RegisterResponse> registerUser({required String firstName, required String lastName, required String number, required String email}) async {
    try {
      final formData = FormData.fromMap({'f_name': firstName, 'l_name': lastName, 'number': number, 'email': email});

      final response = await _apiService.dio.post(AppStrings.register, data: formData);

      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? "Something went wrong";
      throw Exception(message);
    }
  }

  Future<LoginResponse> loginUser({required String number, required String pin, required String latitude, required String longitude, required String fcmToken, required String deviceInfo}) async {
    try {
      final formData = FormData.fromMap({"number": number, "pin": pin, "latitude": latitude, "longitude": longitude, "fcm_token": fcmToken, "device_info": deviceInfo});

      final response = await _apiService.dio.post(AppStrings.login, data: formData);

      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? "Something went wrong";
      throw Exception(message);
    }
  }
}
