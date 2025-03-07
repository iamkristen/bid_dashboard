import 'package:dashboard/models/identity_request_model.dart';
import 'package:dashboard/models/response_helper.dart';
import 'package:dashboard/services/dio_clients.dart';
import 'package:dio/dio.dart';

class IdentityRequestService {
  final Dio _dio = DioClient().dio;

  Future<List<UserData>> fetchAllRequests() async {
    try {
      final data = await _dio.get("/identityRequest/getAll");
      final res = ResponseHelper.fromJson(data.data);
      if (!res.success) {
        throw Exception(res.message);
      }
      return res.data.map<UserData>((e) => UserData.fromJson(e)).toList();
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserData> fetchRequestById(String requestId) async {
    try {
      final data = await _dio.get("/identityRequest/getById/$requestId");
      final res = ResponseHelper.fromJson(data.data);
      if (!res.success) {
        throw Exception(res.message);
      }
      return UserData.fromJson(res.data);
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getRequestCount() async {
    try {
      final data = await _dio.get("/identityRequest/getUserIdentityCount");

      final res = ResponseHelper.fromJson(data.data);
      if (!res.success) {
        throw Exception(res.message);
      }
      return res.data;
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserData> updateRequest(
      String requestId, Map<String, dynamic> updatedData) async {
    try {
      final data = await _dio.put(
          "/identityRequest/update/${requestId.toString()}",
          data: updatedData);
      final response = ResponseHelper.fromJson(data.data);
      if (!response.success) {
        throw Exception(response.message);
      }
      return UserData.fromJson(response.data);
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
