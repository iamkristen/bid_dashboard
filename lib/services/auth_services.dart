import 'package:dashboard/models/response_helper.dart';
import 'package:dashboard/services/dio_clients.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  // Login Method
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final data = await _dio.post(
        "/auth/login",
        data: {
          "email": email,
          "password": password,
        },
      );
      final response = ResponseHelper.fromJson(data.data);
      if (!response.success) {
        throw Exception(response.message);
      }
      return response.data;
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      rethrow;
    }
  }

  // Signup Method
  Future<Map<String, dynamic>> signup(Map<String, dynamic> email) async {
    try {
      final data = await _dio.post(
        "/auth/signup",
        data: email,
      );
      final response = ResponseHelper.fromJson(data.data);
      if (!response.success) {
        throw Exception(response.message);
      }
      return response.data;
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      rethrow;
    }
  }

  // Logout Method
  Future<void> logout() async {
    try {
      final response = await _dio.post("/auth/logout");
      if (response.data["status"] == "error") {
        throw Exception(response.data["message"]);
      }
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Something went wrong. Please try again later.");
    }
  }

  Future<void> changePassword(
    String id,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final response = await _dio.post(
        "/auth/change-password/$id",
        data: {
          "old_password": oldPassword,
          "new_password": newPassword,
        },
      );
      if (response.data["status"] == "error") {
        throw Exception(response.data["message"]);
      }
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Something went wrong. Please try again later.");
    }
  }

  // Error Handling
  String _handleDioError(DioException error) {
    if (error.response != null) {
      return "Error: ${error.response?.data['error'] ?? error.response?.statusMessage}";
    } else {
      return "Error: ${error.message}";
    }
  }
}
