import 'package:dashboard/models/access_request_model.dart';
import 'package:dashboard/services/dio_clients.dart';
import 'package:dio/dio.dart';

class AccessRequestService {
  final Dio _dio = DioClient().dio;

  /// Fetch all access requests
  Future<List<AccessRequestModel>> fetchAllRequests() async {
    try {
      final response = await _dio.get("/profile/getAll");
      final AccessResponseModel accessResponseModel =
          AccessResponseModel.fromJson(response.data);

      if (accessResponseModel.status == "error") {
        throw Exception(accessResponseModel.message);
      }

      return accessResponseModel.data;
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      rethrow;
    }
  }

  /// create access request
  Future<AccessRequestModel> createRequest(
      Map<String, dynamic> requestData) async {
    try {
      final response = await _dio.post(
        "/profile/create",
        data: requestData,
      );
      if (response.data["status"] == "error") {
        throw Exception(response.data["message"]);
      }
      return AccessRequestModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Something went wrong. Please try again later.");
    }
  }

  /// Update a specific access request
  Future<AccessRequestModel> updateRequest(
      String requestId, Map<String, dynamic> updatedData) async {
    try {
      final response = await _dio.put(
        "/accessRequest/update/$requestId",
        data: updatedData,
      );
      if (response.data["status"] == "error") {
        throw Exception(response.data["message"]);
      }
      return AccessRequestModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Something went wrong. Please try again later.");
    }
  }

  /// Error handling for DioExceptions
  String _handleDioError(DioException error) {
    if (error.response != null) {
      return "Error: ${error.response?.data['error'] ?? error.response?.statusMessage}";
    } else {
      return "Error: ${error.message}";
    }
  }
}
