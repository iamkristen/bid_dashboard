import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    // Base options for all requests
    _dio.options = BaseOptions(
      baseUrl: "https://bid-z9end.ondigitalocean.app/api",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
      },
    );

    // Add interceptors for logging or custom headers
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  // Expose Dio instance
  Dio get dio => _dio;
}
