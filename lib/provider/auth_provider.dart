// ignore: avoid_web_libraries_in_flutter
import 'dart:typed_data';
import 'package:dashboard/helper/exception_helper.dart';
import 'package:dashboard/helper/secure_storage.dart';
import 'package:dashboard/helper/storage_constant.dart';
import 'package:dashboard/models/access_request_model.dart';
import 'package:dashboard/provider/access_request_provider.dart';
import 'package:dashboard/services/access_request_services.dart';
import 'package:dashboard/services/auth_services.dart';
import 'package:dashboard/services/email_sender.dart';
import 'package:dashboard/services/upload_services.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthProvider extends ChangeNotifier {
  AuthService authService = AuthService();

  AccessRequestService accessRequestService = AccessRequestService();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clear() {
    emailController.clear();
    passwordController.clear();
  }

  Future<String> login() async {
    try {
      setLoading(true);
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        setLoading(false);
        throw Exception("Please fill all the fields.");
      }
      final data = await authService.login(
          emailController.text.trim().toLowerCase(),
          passwordController.text.trim());
      final AccessRequestProvider accessRequestProvider =
          AccessRequestProvider();

      await SecureStorage.save(StorageConstant.token, data["token"]);
      final tokenData = JwtDecoder.decode(data["token"]);
      await accessRequestProvider.fetchRequestByEmail(tokenData["email"]);
      await SecureStorage.save(StorageConstant.role, tokenData["role"]);
      await SecureStorage.save(StorageConstant.userId, tokenData["id"]);
      await SecureStorage.save(StorageConstant.email, tokenData["email"]);
      await SecureStorage.save(
          StorageConstant.orgName, accessRequestProvider.request!.name);
      clear();
      return data["token"];
    } catch (e) {
      setLoading(false);
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> signup(String email) async {
    try {
      setLoading(true);
      if (email.isEmpty) {
        setLoading(false);
        throw Exception("Please fill all the fields.");
      }
      await authService.signup({"email": email.toLowerCase(), "role": "org"});
      setLoading(false);
      return true;
    } catch (e) {
      setLoading(false);
      rethrow;
    }
  }

  Future<void> changePassword({
    required String id,
    required String current,
    required String newPass,
  }) async {
    try {
      setLoading(true);
      if (current.isEmpty || newPass.isEmpty) {
        setLoading(false);
        throw Exception("Please fill all the fields.");
      }
      await authService.changePassword(id, current, newPass);
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }
}
