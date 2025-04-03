import 'package:dashboard/models/aid_distribution_model.dart';
import 'package:dashboard/models/response_helper.dart';
import 'package:dashboard/services/dio_clients.dart';
import 'package:dio/dio.dart';

class AidDistributionService {
  final Dio _dio = DioClient().dio;

  Future<List<AidDistributionModel>> fetchAllAidDistributions() async {
    try {
      final data = await _dio.get("/aids/getAll");
      final res = ResponseHelper.fromJson(data.data);
      if (!res.success) {
        throw Exception(res.message);
      }

      final List<AidDistributionModel> aidList = (res.data as List)
          .map((e) => AidDistributionModel.fromJson(e))
          .toList();
      return aidList;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      rethrow;
    }
  }

  // Get distribution by ID
  Future<AidDistributionModel> fetchAidById(String aidId) async {
    try {
      final data = await _dio.get("/aids/$aidId");
      final res = ResponseHelper.fromJson(data.data);
      if (!res.success) {
        throw Exception(res.message);
      }
      return AidDistributionModel.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      rethrow;
    }
  }

  // Get aid by Beneficiary ID
  Future<List<AidDistributionModel>> fetchAidByBeneficiary(
      String beneficiaryId) async {
    try {
      final data = await _dio.get("/aids/beneficiary/$beneficiaryId");
      final res = ResponseHelper.fromJson(data.data);
      if (!res.success) {
        throw Exception(res.message);
      }

      final List<AidDistributionModel> aidList = (res.data as List)
          .map((e) => AidDistributionModel.fromJson(e))
          .toList();
      return aidList;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      rethrow;
    }
  }

  // get all aids count
  Future<int> getAllAidsCount() async {
    try {
      final data = await _dio.get("/aids/count/all");
      final res = ResponseHelper.fromJson(data.data);
      if (!res.success) {
        throw Exception(res.message);
      }
      return res.data;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      rethrow;
    }
  }

  // get all aids count by beneficiary
  Future<int> getAidsCountByBeneficiary(String beneficiaryId) async {
    try {
      final data = await _dio.get("/aids/count/$beneficiaryId");
      final res = ResponseHelper.fromJson(data.data);
      if (!res.success) {
        throw Exception(res.message);
      }
      return res.data;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      rethrow;
    }
  }

  // Create new aid distribution record
  Future<AidDistributionModel> createAidDistribution(
      Map<String, dynamic> aidData) async {
    try {
      final data = await _dio.post("/aids/create", data: aidData);
      final res = ResponseHelper.fromJson(data.data);
      if (!res.success) {
        throw Exception(res.message);
      }
      return AidDistributionModel.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      rethrow;
    }
  }

  // Update existing aid distribution record
  Future<AidDistributionModel> updateAidDistribution(
      String aidId, Map<String, dynamic> updatedData) async {
    try {
      final data = await _dio.put("/aids/update/$aidId", data: updatedData);
      final res = ResponseHelper.fromJson(data.data);
      if (!res.success) {
        throw Exception(res.message);
      }
      return AidDistributionModel.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      rethrow;
    }
  }

  // Delete aid distribution record
  Future<AidDistributionModel> deleteAidDistribution(String aidId) async {
    try {
      final data = await _dio.delete("/aids/delete/$aidId");
      final res = ResponseHelper.fromJson(data.data);
      if (!res.success) {
        throw Exception(res.message);
      }
      return AidDistributionModel.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
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
