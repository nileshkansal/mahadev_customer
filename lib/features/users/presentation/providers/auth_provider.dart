import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahadev_customer/core/network/api_service.dart';
import 'package:mahadev_customer/core/storage/storage_service.dart';
import 'package:mahadev_customer/features/users/data/models/login_response.dart';
import 'package:mahadev_customer/features/users/data/models/register_response.dart';
import 'package:mahadev_customer/features/users/domain/repositories/auth_repository.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final LoginResponse? loginData;
  final RegisterResponse? registerData;
  final String? error;

  AuthState({this.status = AuthStatus.initial, this.loginData, this.registerData, this.error});

  AuthState copyWith({AuthStatus? status, LoginResponse? loginData, RegisterResponse? registerData, String? error}) {
    return AuthState(status: status ?? this.status, loginData: loginData ?? this.loginData, registerData: registerData ?? this.registerData, error: error ?? this.error);
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState());

  /// LOGIN METHOD
  Future<void> login({required String number, required String pin, required String latitude, required String longitude, required String fcmToken, required String deviceInfo}) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    try {
      final response = await _repository.loginUser(number: number, pin: pin, latitude: latitude, longitude: longitude, fcmToken: fcmToken, deviceInfo: deviceInfo);

      await StorageService().saveToken(response.token);

      state = state.copyWith(loginData: response, status: AuthStatus.success);
    } catch (e) {
      state = state.copyWith(error: e.toString(), status: AuthStatus.error);
    }
  }

  /// REGISTER METHOD
  Future<void> register({required String firstName, required String lastName, required String number, required String email}) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    try {
      final response = await _repository.registerUser(firstName: firstName, lastName: lastName, number: number, email: email);

      state = state.copyWith(registerData: response, status: AuthStatus.success);
    } catch (e) {
      state = state.copyWith(error: e.toString(), status: AuthStatus.error);
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = AuthRepository(ref.read(apiServiceProvider));
  return AuthNotifier(repository);
});
