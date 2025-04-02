import 'dart:typed_data';
import 'dart:html' as html;
import 'package:dashboard/services/access_request_services.dart';
import 'package:dashboard/services/email_sender.dart';
import 'package:dashboard/services/upload_services.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/models/access_request_model.dart';

class AccessRequestProvider with ChangeNotifier {
  final AccessRequestService _service = AccessRequestService();
  UploadServices uploadServices = UploadServices();
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
  List<AccessRequestModel> _allRequests = [];
  AccessRequestModel? _request;
  int _count = 0;
  int _availablePages = 0;
  int _currentPage = 1;
  List<AccessRequestModel> get allRequests => _allRequests;
  AccessRequestModel? get request => _request;
  int get availablePages => _availablePages;
  int get currentPage => _currentPage;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int get count => _count;

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
      throw Exception("Please upload atleast one documents and logo");
    }
    if (organizationNameController.text.isEmpty ||
        crnNumberController.text.isEmpty ||
        emailController.text.isEmpty ||
        reasonController.text.isEmpty) {
      throw Exception("Please fill all the fields");
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

      final avatar = await uploadServices.uploadSingleFile(
        fileName,
        avatarBytes!,
        mimeType,
      );

      final documents =
          await uploadServices.uploadMultipleFiles(supportingDocuments);

      if (documents == null || documents.isEmpty) {
        setLoading(false);
        throw Exception(
            "Failed to upload supporting documents. Please try again.");
      }

      final List<String> urls =
          (documents["urls"] as List<dynamic>).cast<String>();

      final profile = AccessRequestModel(
        logo: avatar["url"],
        name: organizationNameController.text.trim(),
        crnNumber: crnNumberController.text.trim(),
        email: emailController.text.trim(),
        reason: reasonController.text.trim(),
        supportingDocuments: urls,
      );

      final AccessRequestModel res =
          await _service.createRequest(profile.toJson(forUpdate: false));
      clear();
      return res;
    } catch (e) {
      setLoading(false);
      rethrow;
    }
  }

  Future<AccessRequestModel> submitProfileUpdate(String requestId) async {
    try {
      setLoading(true);

      final avatar = avatarBytes != null
          ? await uploadServices.uploadSingleFile(
              fileName, avatarBytes!, mimeType)
          : {"url": _request?.logo};

      final updatedDocs = supportingDocuments.isNotEmpty
          ? await uploadServices.uploadMultipleFiles(supportingDocuments)
          : {"urls": _request?.supportingDocuments ?? []};

      final List<String> urls =
          (updatedDocs!["urls"] as List<dynamic>).cast<String>();

      final updatedData = {
        "logo": avatar["url"],
        "name": organizationNameController.text.trim(),
        "crnNumber": crnNumberController.text.trim(),
        "email": emailController.text.trim(),
        "reason": reasonController.text.trim(),
        "supportingDocuments": urls,
      };

      await updateRequest(requestId, updatedData);
      return _request!;
    } catch (e) {
      setLoading(false);
      rethrow;
    } finally {
      setLoading(false);
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

  Future<String> fetchAllRequests({int page = 1}) async {
    try {
      setLoading(true);
      ProfileResponse res = await _service.fetchAllRequests(page: page);
      _availablePages = res.totalPages;
      _currentPage = res.currentPage;
      _allRequests = res.data;
      setLoading(false);
      return "Success";
    } catch (e) {
      print(e);
      setLoading(false);
      return e.toString();
    }
  }

  Future<String> fetchRequestById(String requestId) async {
    try {
      setLoading(true);
      _request = await _service.fetchRequestById(requestId);

      return "Success";
    } catch (e) {
      return e.toString();
    } finally {
      setLoading(false);
    }
  }

  Future<String> fetchRequestByEmail(String email) async {
    try {
      setLoading(true);
      _request = await _service.fetchRequestByEmail(email);
      if (_request != null) {
        emailController.text = _request!.email;
        organizationNameController.text = _request!.name;
        crnNumberController.text = _request!.crnNumber;
        reasonController.text = _request!.reason;
      }

      setLoading(false);
      return "Success";
    } catch (e) {
      return e.toString();
    } finally {
      setLoading(false);
    }
  }

  Future<void> getRequestCount() async {
    try {
      setLoading(true);
      _count = await _service.getRequestCount();
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> updateRequest(
      String requestId, Map<String, dynamic> updatedData) async {
    try {
      final updatedRequest =
          await _service.updateRequest(requestId, updatedData);
      final index = _allRequests.indexWhere((req) => req.id == requestId);

      if (index != -1) {
        _allRequests[index] = updatedRequest;
        notifyListeners();
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
