import 'package:dashboard/models/response_helper.dart';
import 'package:dashboard/services/dio_clients.dart';
import 'package:dio/dio.dart';

class EmailSenderServices {
  final Dio _dio = DioClient().dio;

  Future<bool> rejectionEmail(String to, String name) async {
    try {
      final data = await _dio.post("/mail/rejection", data: {
        "email": to,
        "name": name,
      });
      final response = ResponseHelper.fromJson(data.data);
      if (!response.success) {
        throw Exception(response.message);
      }
      return response.success;
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      rethrow;
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
