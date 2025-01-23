import 'package:dashboard/models/identity_request_model.dart';
import 'package:dashboard/services/dio_clients.dart';
import 'package:dio/dio.dart';

class IdentityRequestService {
  final Dio _dio = DioClient().dio;

  Future<List<IdentityRequest>> fetchAllRequests() async {
    try {
      final response = await _dio.get("/identityRequest/getAll");
      print("Response data: ${response.data}");

      // Ensure response.data is a Map and contains a list
      if (response.data is Map<String, dynamic>) {
        final dataList = response.data['data']
            as List; // Adjust this key based on your API response structure
        return dataList.map((json) => IdentityRequest.fromJson(json)).toList();
      } else if (response.data is List) {
        // If response.data is already a list
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
      final response = await _dio.patch("/identityRequest/update/$requestId",
          data: updatedData);
      return IdentityRequest.fromJson(response.data);
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
