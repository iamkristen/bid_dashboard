import 'package:dashboard/models/identity_request_model.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/services/identity_request_service.dart';

class IdentityRequestProvider with ChangeNotifier {
  final IdentityRequestService _service = IdentityRequestService();

  List<UserData> _allRequests = [];
  List<UserData> _filteredRequests = [];
  String _currentFilter = 'Pending';

  UserData? _request;
  int _count = 0;
  int _currentPage = 1;
  int _totalPages = 0;
  bool _isLoading = false;
  String? _error;
  List<UserData> get filteredRequests => _filteredRequests;

  List<UserData> get allRequests => _allRequests;
  UserData? get request => _request;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get count => _count;
  int get currentPage => _currentPage;
  int get availablePages => _totalPages;

  Future<void> fetchAllRequests({int page = 1}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      UserIdentityResponse res = await _service.fetchAllRequests(page: page);
      _currentPage = res.currentPage;
      _totalPages = res.totalPages;
      _allRequests = res.data;
      _filteredRequests = res.data;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _applyFilter(String filter) {
    _currentFilter = filter;
    if (filter == "All") {
      _filteredRequests = _allRequests;
    } else if (filter == "Pending") {
      _filteredRequests =
          _allRequests.where((request) => request.status == "Pending").toList();
    } else if (filter == "Approved") {
      _filteredRequests = _allRequests
          .where((request) => request.status == "Approved")
          .toList();
    } else if (filter == "Rejected") {
      _filteredRequests = _allRequests
          .where((request) => request.status == "Rejected")
          .toList();
    } else {
      _filteredRequests = _allRequests;
    }
    notifyListeners();
  }

  void setFilterRequests(String filter) {
    _applyFilter(filter);
  }

  Future<void> fetchRequestById(String requestId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _request = await _service.fetchRequestById(requestId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getRequestCount() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _count = await _service.getRequestCount();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRequest(
      String requestId, Map<String, dynamic> updatedData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedRequest =
          await _service.updateRequest(requestId, updatedData);
      final index = _allRequests.indexWhere((req) => req.id == requestId);

      if (index != -1) {
        _allRequests[index] = updatedRequest;
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
