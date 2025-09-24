import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mahadev_customer/core/utils/app_strings.dart';
import '../storage/storage_service.dart';

class ApiService {
  late Dio dio;

  ApiService() {
    dio = Dio(BaseOptions(baseUrl: AppStrings.baseUrl, connectTimeout: const Duration(seconds: 15), receiveTimeout: const Duration(seconds: 15), headers: {"Accept": "application/json"}));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await StorageService().getToken();
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            await StorageService().clearSession();
            _onUnauthorizedCallback?.call();
          }
          return handler.next(e);
        },
      ),
    );
  }

  static VoidCallback? _onUnauthorizedCallback;

  static void setUnauthorizedCallback(VoidCallback callback) {
    _onUnauthorizedCallback = callback;
  }

}

// class ApiService {
//   final Dio _dio;
//
//   ApiService(this._dio) {
//     _dio.options = BaseOptions(
//       baseUrl: AppStrings.serverUrl,
//       connectTimeout: const Duration(seconds: 15),
//       receiveTimeout: const Duration(seconds: 15),
//       headers: {
//         'Accept': 'application/json',
//       },
//     );
//
//     // Add global interceptor
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onError: (DioException e, ErrorInterceptorHandler handler) async {
//           if (e.response?.statusCode == 401) {
//             // If we get 401 => Logout user
//             await StorageService().clearSession();
//
//             // Redirect user to login page
//             _onUnauthorizedCallback?.call();
//           }
//           return handler.next(e);
//         },
//       ),
//     );
//   }
//
//   static VoidCallback? _onUnauthorizedCallback;
//
//   static void setUnauthorizedCallback(VoidCallback callback) {
//     _onUnauthorizedCallback = callback;
//   }
//
//   Dio get dio => _dio;
// }
