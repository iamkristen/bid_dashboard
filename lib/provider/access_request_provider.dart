import 'package:dashboard/services/access_request_services.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/models/access_request_model.dart';

class AccessRequestProvider with ChangeNotifier {
  final AccessRequestService _service = AccessRequestService();

  List<AccessRequestModel> _allRequests = [];
  AccessRequestModel? _request;
  int _count = 0;
  List<AccessRequestModel> get allRequests => _allRequests;
  AccessRequestModel? get request => _request;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int get count => _count;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Fetch all access requests
  Future<String> fetchAllRequests() async {
    try {
      setLoading(true);
      _allRequests = await _service.fetchAllRequests();
      setLoading(false);
      return "Success";
    } catch (e) {
      setLoading(false);
      return e.toString();
    }
  }

  /// Fetch a specific access request
  Future<String> fetchRequestById(String requestId) async {
    try {
      setLoading(true);
      _request = await _service.fetchRequestById(requestId);
      setLoading(false);
      return "Success";
    } catch (e) {
      setLoading(false);
      return e.toString();
    }
  }

  /// Get the count of access requests
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

  /// Update a specific access request
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
