import 'package:dashboard/models/event_models.dart';
import 'package:dashboard/models/response_helper.dart';
import 'package:dashboard/services/dio_clients.dart';
import 'package:dio/dio.dart';

class EventService {
  final Dio _dio = DioClient().dio;

  // Fetch all events
  Future<List<EventModel>> fetchAllEventsForAdmin() async {
    try {
      final data = await _dio.get("/event/getAll");
      final res = ResponseHelper.fromJson(data.data);
      if (!res.success) {
        throw Exception(res.message);
      }

      final List<EventModel> events =
          (res.data as List).map((e) => EventModel.fromJson(e)).toList();
      return events;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      rethrow;
    }
  }

  Future<EventModel> fetchEventById(String eventId) async {
    try {
      final data = await _dio.get("/event/$eventId");
      final res = ResponseHelper.fromJson(data.data);
      if (!res.success) {
        throw Exception(res.message);
      }
      return EventModel.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      rethrow;
    }
  }

  Future<List<EventModel>> fetchAllEventsForOrg(String hostId) async {
    try {
      final data = await _dio.get("/event/hostID/$hostId");
      final res = ResponseHelper.fromJson(data.data);
      if (!res.success) {
        throw Exception(res.message);
      }

      final List<EventModel> events =
          (res.data as List).map((e) => EventModel.fromJson(e)).toList();
      return events;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      rethrow;
    }
  }

  Future<int> fetchAllEventsCountForOrg(String hostId) async {
    try {
      final data = await _dio.get("/event/count/$hostId");
      final res = ResponseHelper.fromJson(data.data);
      if (!res.success) {
        return 0;
      }
      return res.data;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      rethrow;
    }
  }

  Future<int> fetchAllEventsCountForAdmin() async {
    try {
      final data = await _dio.get("/event/count/all");
      final res = ResponseHelper.fromJson(data.data);
      if (!res.success) {
        return 0;
      }
      return res.data;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      rethrow;
    }
  }

  Future<EventModel> createEvent(Map<String, dynamic> eventData) async {
    try {
      final data = await _dio.post("/event/create", data: eventData);
      final res = ResponseHelper.fromJson(data.data);
      if (!res.success) {
        throw Exception(res.message);
      }
      return EventModel.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      rethrow;
    }
  }

  Future<EventModel> updateEvent(
      String eventId, Map<String, dynamic> updatedData) async {
    try {
      final data = await _dio.put("/event/update/$eventId", data: updatedData);
      final res = ResponseHelper.fromJson(data.data);
      if (!res.success) {
        throw Exception(res.message);
      }
      return EventModel.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      rethrow;
    }
  }

  Future<EventModel> deleteEvent(String eventId) async {
    try {
      final data = await _dio.delete("/event/delete/$eventId");
      final res = ResponseHelper.fromJson(data.data);
      if (!res.success) {
        throw Exception(res.message);
      }
      return EventModel.fromJson(res.data);
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
