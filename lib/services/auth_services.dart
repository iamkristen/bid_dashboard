import 'package:dashboard/services/dio_clients.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  // Login Method
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        "/auth/login",
        data: {
          "email": email,
          "password": password,
        },
      );
      if (response.data["status"] == "error") {
        throw Exception(response.data["error"]);
      }
      return response.data;
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Something went wrong. Please try again later.");
    }
  }

  // Signup Method
  Future<Map<String, dynamic>> signup(Map<String, dynamic> email) async {
    try {
      final response = await _dio.post(
        "/auth/signup",
        data: email,
      );
      if (response.data["status"] == "error") {
        throw Exception(response.data["message"]);
      }
      return response.data;
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Something went wrong. Please try again later.");
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

  // Error Handling
  String _handleDioError(DioException error) {
    if (error.response != null) {
      return "Error: ${error.response?.data['error'] ?? error.response?.statusMessage}";
    } else {
      return "Error: ${error.message}";
    }
  }
}
