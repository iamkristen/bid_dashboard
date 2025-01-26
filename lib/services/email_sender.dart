import 'package:dashboard/services/dio_clients.dart';
import 'package:dio/dio.dart';

class EmailSenderServices {
  final Dio _dio = DioClient().dio;

  Future<String> rejectionEmail(String to, String name) async {
    try {
      final response = await _dio.post("/mail/rejection", data: {
        "to": to,
        "name": name,
      });
      if (response.data["status"] == "error") {
        throw Exception(response.data["error"]);
      }
      return response.data['status'];
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Something went wrong. Please try again later.");
    }
  }

  String _handleDioError(DioException error) {
    if (error.response != null) {
      return "Error: ${error.response?.data['error'] ?? error.response?.statusMessage}";
    } else {
      return "Error: ${error.message}";
    }
  }
}
