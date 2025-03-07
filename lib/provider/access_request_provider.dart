import 'package:dashboard/services/access_request_services.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/models/access_request_model.dart';

class AccessRequestProvider with ChangeNotifier {
  final AccessRequestService _service = AccessRequestService();

  List<AccessRequestModel> _requests = [];
  int _count = 0;
  List<AccessRequestModel> get requests => _requests;
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
      _requests = await _service.fetchAllRequests();
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
      final index = _requests.indexWhere((req) => req.id == requestId);

      if (index != -1) {
        _requests[index] = updatedRequest;
        notifyListeners();
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
