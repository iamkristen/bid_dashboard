import 'package:dashboard/models/registered_user_model.dart';
import 'package:dashboard/services/registered_user_service.dart';
import 'package:flutter/material.dart';

class RegisteredUserProvider with ChangeNotifier {
  final RegisteredUserService _service = RegisteredUserService();
  List<RegisteredUserData> _userData = [];
  bool _isLoading = false;
  String? _error;

  List<RegisteredUserData> get userData => _userData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAllRequests() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _userData = await _service.fetchAllRequests();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
