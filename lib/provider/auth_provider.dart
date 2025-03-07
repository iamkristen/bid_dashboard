// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:dashboard/helper/exception_helper.dart';
import 'package:dashboard/models/access_request_model.dart';
import 'package:dashboard/services/access_request_services.dart';
import 'package:dashboard/services/auth_services.dart';
import 'package:dashboard/services/email_sender.dart';
import 'package:dashboard/services/upload_services.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  AuthService authService = AuthService();
  UploadServices uploadServices = UploadServices();
  AccessRequestService accessRequestService = AccessRequestService();
  EmailSenderServices emailSenderServices = EmailSenderServices();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController organizationNameController =
      TextEditingController();
  final TextEditingController crnNumberController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Uint8List? avatarBytes;
  final List<Map<String, dynamic>> supportingDocuments = [];
  late String fileName;
  late String mimeType;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void pickImage() {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files?.isEmpty ?? true) return;
      final file = files?.first;
      fileName = file!.name;
      mimeType = file.type;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);

      reader.onLoadEnd.listen((e) {
        avatarBytes = reader.result as Uint8List?;
        notifyListeners();
      });
    });
  }

  void pickSupportingDocuments() {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement()
          ..accept = 'application/pdf,image/*'
          ..multiple = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        for (var file in files) {
          if (supportingDocuments.length >= 5) break;

          final reader = html.FileReader();
          reader.readAsArrayBuffer(file);
          reader.onLoadEnd.listen((e) {
            final fileBytes = reader.result as Uint8List?;
            final fileData = {
              "fileName": file.name,
              "mimeType": file.type,
              "fileData": fileBytes,
            };
            supportingDocuments.add(fileData);
            if (file == files.last) notifyListeners();
          });
        }
      }
    });
  }

  void removeDocument(Map<String, dynamic> file) {
    supportingDocuments.remove(file);
    notifyListeners();
  }

  void clear() {
    avatarBytes = null;
    supportingDocuments.clear();
    emailController.clear();
    organizationNameController.clear();
    crnNumberController.clear();
    reasonController.clear();
    notifyListeners();
  }

  bool validate() {
    if (avatarBytes == null || supportingDocuments.isEmpty) {
      throw UserFriendlyException(
          "Please upload atleast one documents and logo");
    }
    if (organizationNameController.text.isEmpty ||
        crnNumberController.text.isEmpty ||
        emailController.text.isEmpty ||
        reasonController.text.isEmpty) {
      throw UserFriendlyException("Please fill all the fields");
    }
    return true;
  }

  Future<AccessRequestModel> registerProfile() async {
    try {
      setLoading(true);
      if (avatarBytes == null || supportingDocuments.isEmpty) {
        setLoading(false);
        throw Exception("Please upload atleast one document and logo.");
      }

      if (organizationNameController.text.isEmpty ||
          crnNumberController.text.isEmpty ||
          emailController.text.isEmpty ||
          reasonController.text.isEmpty) {
        setLoading(false);
        throw Exception("Please fill all the fields.");
      }

      // Upload avatar
      final avatar = await uploadServices.uploadSingleFile(
        fileName,
        avatarBytes!,
        mimeType,
      );

      // Upload supporting documents
      final documents =
          await uploadServices.uploadMultipleFiles(supportingDocuments);

      if (documents == null || documents.isEmpty) {
        setLoading(false);
        throw Exception(
            "Failed to upload supporting documents. Please try again.");
      }

      final List<String> urls =
          (documents["urls"] as List<dynamic>).cast<String>();

      // Create the profile
      final profile = AccessRequestModel(
        logo: avatar["url"],
        name: organizationNameController.text.trim(),
        crnNumber: crnNumberController.text.trim(),
        email: emailController.text.trim(),
        reason: reasonController.text.trim(),
        supportingDocuments: urls,
      );

      // Submit the profile
      final AccessRequestModel res = await accessRequestService
          .createRequest(profile.toJson(forUpdate: false));
      clear();
      return res;
    } catch (e) {
      setLoading(false);
      rethrow;
    }
  }

  Future<String> login() async {
    try {
      setLoading(true);
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        setLoading(false);
        throw Exception("Please fill all the fields.");
      }
      final data = await authService.login(
          emailController.text.trim(), passwordController.text.trim());
      setLoading(false);
      clear();
      return data["token"];
    } catch (e) {
      setLoading(false);
      rethrow;
    }
  }

  Future<bool> signup(String email) async {
    try {
      setLoading(true);
      if (email.isEmpty) {
        setLoading(false);
        throw Exception("Please fill all the fields.");
      }
      await authService.signup({"email": email});
      setLoading(false);
      clear();
      return true;
    } catch (e) {
      setLoading(false);
      rethrow;
    }
  }

  Future<bool> sendRejectionEmail({
    required String email,
    required String name,
  }) async {
    try {
      setLoading(true);
      final res = await emailSenderServices.rejectionEmail(email, name);
      setLoading(false);
      return res;
    } catch (e) {
      setLoading(false);
      rethrow;
    }
  }
}
