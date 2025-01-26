import 'package:dashboard/services/access_request_services.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/models/access_request_model.dart';

class AccessRequestProvider with ChangeNotifier {
  final AccessRequestService _service = AccessRequestService();

  List<AccessRequestModel> _requests = [];
  List<AccessRequestModel> get requests => _requests;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Fetch all access requests
  Future<String> fetchAllRequests() async {
    try {
      setLoading(true);
      _requests = await _service.fetchAllRequests();
      if (requests.isEmpty) {
        setLoading(false);
        return "No requests found";
      }
      setLoading(false);
      return "Success";
    } catch (e) {
      setLoading(false);
      return e.toString();
    }
  }

  /// Update a specific access request
  Future<String> updateRequest(
      String requestId, Map<String, dynamic> updatedData) async {
    try {
      final updatedRequest =
          await _service.updateRequest(requestId, updatedData);
      final index = _requests.indexWhere((req) => req.id == requestId);

      if (index != -1) {
        _requests[index] = updatedRequest;
        notifyListeners();
      }
      return "Success";
    } catch (e) {
      return e.toString();
    }
  }
}
