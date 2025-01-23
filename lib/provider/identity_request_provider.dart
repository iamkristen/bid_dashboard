import 'package:dashboard/models/identity_request_model.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/services/identity_request_service.dart';

class IdentityRequestProvider with ChangeNotifier {
  final IdentityRequestService _service = IdentityRequestService();

  List<IdentityRequest> _requests = [];
  bool _isLoading = false;
  String? _error;

  List<IdentityRequest> get requests => _requests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAllRequests() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _requests = await _service.fetchAllRequests();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update a request
  Future<void> updateRequest(
      String requestId, Map<String, dynamic> updatedData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedRequest =
          await _service.updateRequest(requestId, updatedData);
      final index = _requests.indexWhere((req) => req.id == requestId);

      if (index != -1) {
        _requests[index] = updatedRequest;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
