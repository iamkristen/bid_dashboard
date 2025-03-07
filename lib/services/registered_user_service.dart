import 'package:dashboard/models/identity_request_model.dart';
import 'package:dashboard/models/registered_user_model.dart';
import 'package:dashboard/models/response_helper.dart';
import 'package:dashboard/services/dio_clients.dart';
import 'package:dio/dio.dart';

class RegisteredUserService {
  final Dio _dio = DioClient().dio;

  Future<List<RegisteredUserData>> fetchAllRequests() async {
    try {
      final data = await _dio.get("/web3/users/allUsers");
      final res = ResponseHelper.fromJson(data.data);
      if (!res.success) {
        throw Exception(res.message);
      }
      return res.data
          .map<RegisteredUserData>((e) => RegisteredUserData.fromMap(e))
          .toList();
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
