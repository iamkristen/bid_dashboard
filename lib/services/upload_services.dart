import 'dart:typed_data';
import 'package:dashboard/services/dio_clients.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class UploadServices {
  final Dio _dio = DioClient().dio;

  // Upload Method for Uint8List File
  Future<Map<String, dynamic>> uploadSingleFile(
      String fileName, Uint8List fileData, String mimeType) async {
    try {
      // Create a MultipartFile from Uint8List
      final file = MultipartFile.fromBytes(
        fileData,
        filename: fileName,
        contentType: MediaType.parse(mimeType),
      );

      // Create FormData to send with the request
      final formData = FormData.fromMap({
        "file": file,
      });

      // Perform the upload request
      final response = await _dio.post(
        "/upload/single",
        data: formData,
      );

      if (response.data["status"] == "error") {
        throw Exception(response.data["message"]);
      }
      return response.data["data"];
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Something went wrong. Please try again later.");
    }
  }

  // Upload multiple documents
  Future<Map<String, dynamic>?> uploadMultipleFiles(
      List<Map<String, dynamic>> files) async {
    if (files.isEmpty) return null;

    try {
      final List<MultipartFile> multiFiles = files.map((file) {
        return MultipartFile.fromBytes(
          file["fileData"],
          filename: file["fileName"],
          contentType: MediaType.parse(file["mimeType"]),
        );
      }).toList();

      final formData = FormData.fromMap({
        "files": multiFiles,
      });

      final response = await _dio.post(
        "/upload/multiple",
        data: formData,
      );

      if (response.data["status"] == "error") {
        throw Exception(response.data["message"]);
      }
      return response.data["data"];
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      print(e);
      throw Exception("Something went wrong. Please try again later.");
    }
  }

  // Error Handling
  String _handleDioError(DioException error) {
    if (error.response != null) {
      return "Error: ${error.response?.data['error'] ?? error.response?.statusMessage}";
    } else {
      return "Error: ${error.message}";
    }
  }
}
