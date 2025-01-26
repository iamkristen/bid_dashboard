import 'package:dashboard/models/identity_request_model.dart';
import 'package:dashboard/services/dio_clients.dart';
import 'package:dio/dio.dart';

class IdentityRequestService {
  final Dio _dio = DioClient().dio;

  Future<List<IdentityRequestModel>> fetchAllRequests() async {
    try {
      final response = await _dio.get("/identityRequest/getAll");
      final IdentityResponseModel identityResponseModel =
          IdentityResponseModel.fromJson(response.data);

      return identityResponseModel.data;
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      rethrow;
    }
  }

  Future<IdentityRequestModel> updateRequest(
      String requestId, Map<String, dynamic> updatedData) async {
    try {
      final response = await _dio.put(
          "/identityRequest/update/${requestId.toString()}",
          data: updatedData);
      if (response.data["status"] == "error") {
        throw Exception(response.data["message"]);
      }
      return IdentityRequestModel.fromJson(response.data['data']);
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
