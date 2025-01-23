import 'package:dashboard/models/identity_request_model.dart';
import 'package:dashboard/services/dio_clients.dart';
import 'package:dio/dio.dart';

class IdentityRequestService {
  final Dio _dio = DioClient().dio;

  Future<List<IdentityRequest>> fetchAllRequests() async {
    try {
      final response = await _dio.get("/identityRequest/getAll");
      if (response.data is Map<String, dynamic>) {
        final dataList = response.data['data'] as List;
        return dataList.map((json) => IdentityRequest.fromJson(json)).toList();
      } else if (response.data is List) {
        return (response.data as List)
            .map((json) => IdentityRequest.fromJson(json))
            .toList();
      } else {
        throw Exception("Unexpected response format: ${response.data}");
      }
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      rethrow;
    }
  }

  Future<IdentityRequest> updateRequest(
      String requestId, Map<String, dynamic> updatedData) async {
    try {
      final response = await _dio.put(
          "/identityRequest/update/${requestId.toString()}",
          data: updatedData);
      if (response.data["status"] == "error") {
        throw Exception(response.data["message"]);
      }
      return IdentityRequest.fromJson(response.data['data']);
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      print(e);
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
