import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    // Base options for all requests
    _dio.options = BaseOptions(
      baseUrl: "http://localhost:3000/api",
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
          // print("Request: ${options.method} ${options.uri}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // print("Response: ${response.statusCode} ${response.data}");
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          // print("Error: ${error.message}");
          return handler.next(error);
        },
      ),
    );
  }

  // Expose Dio instance
  Dio get dio => _dio;
}
