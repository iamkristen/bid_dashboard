import 'package:dashboard/models/access_request_model.dart';
import 'package:dashboard/models/response_helper.dart';
import 'package:dashboard/services/dio_clients.dart';
import 'package:dio/dio.dart';

class AccessRequestService {
  final Dio _dio = DioClient().dio;

  Future<List<AccessRequestModel>> fetchAllRequests() async {
    try {
      final response = await _dio.get("/profile/getAll");
      final data = ResponseHelper.fromJson(response.data);
      if (!data.success) {
        throw Exception(data.message);
      }
      return (data.data as List)
          .map((e) => AccessRequestModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      rethrow;
    }
  }

  Future<AccessRequestModel> fetchRequestById(String requestId) async {
    try {
      final response = await _dio.get("/profile/getProfileByID/$requestId");
      final data = ResponseHelper.fromJson(response.data);
      if (!data.success) {
        throw Exception(data.message);
      }
      return AccessRequestModel.fromJson(data.data);
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
      final res = ResponseHelper.fromJson(response.data);
      if (!res.success) {
        throw Exception(res.message);
      }
      return AccessRequestModel.fromJson(res.data);
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Something went wrong. Please try again later.");
    }
  }

  /// Get the count of access requests
  Future<int> getRequestCount() async {
    try {
      final response = await _dio.get("/profile/getProfileCount");
      final res = ResponseHelper.fromJson(response.data);
      if (!res.success) {
        throw Exception(res.message);
      }
      return res.data;
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
      print(requestId);
      final response = await _dio.put(
        "/profile/update/$requestId",
        data: updatedData,
      );
      final res = ResponseHelper.fromJson(response.data);
      if (!res.success) {
        throw Exception(res.message);
      }
      return AccessRequestModel.fromJson(res.data);
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Something went wrong. Please try again later.");
    }
  }

  /// Delete a specific access request
  Future<bool> deleteRequest(String requestId) async {
    try {
      final response = await _dio.delete("/profile/delete/$requestId");
      final res = ResponseHelper.fromJson(response.data);
      if (!res.success) {
        throw Exception(res.message);
      }
      return res.success;
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
