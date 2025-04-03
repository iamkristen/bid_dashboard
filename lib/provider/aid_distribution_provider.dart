import 'package:dashboard/helper/secure_storage.dart';
import 'package:dashboard/helper/storage_constant.dart';
import 'package:dashboard/models/aid_distribution_model.dart';
import 'package:dashboard/services/aids_distribution_services.dart';
import 'package:flutter/material.dart';

class AidDistributionProvider with ChangeNotifier {
  final AidDistributionService _aidService = AidDistributionService();

  List<AidDistributionModel> _aidList = [];
  AidDistributionModel? _selectedAid;
  int _aidCount = 0;
  int get aidCount => _aidCount;

  bool _isLoading = false;
  String? _error;

  List<AidDistributionModel> get aidList => _aidList;
  AidDistributionModel? get selectedAid => _selectedAid;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchAllAidDistributions() async {
    setLoading(true);
    _error = null;

    try {
      final role = await SecureStorage.read(StorageConstant.role);
      final email = await SecureStorage.read(StorageConstant.email);
      if (role == 'admin') {
        _aidList = await _aidService.fetchAllAidDistributions();
      }
      if (role == 'org' && email != null) {
        _aidList = await _aidService.fetchAidByBeneficiary(email);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchAidById(String id) async {
    setLoading(true);
    _error = null;

    try {
      _selectedAid = await _aidService.fetchAidById(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchAidByBeneficiary(String beneficiaryId) async {
    setLoading(true);
    _error = null;

    try {
      _aidList = await _aidService.fetchAidByBeneficiary(beneficiaryId);
    } catch (e) {
      _error = e.toString();
    } finally {
      setLoading(false);
    }
  }

// get all aid count
  Future<void> getAllAidsCount() async {
    setLoading(true);
    _error = null;
    try {
      final role = await SecureStorage.read(StorageConstant.role);
      final email = await SecureStorage.read(StorageConstant.email);
      if (role == 'admin') {
        _aidCount = await _aidService.getAllAidsCount();
      }
      if (role == 'org' && email != null) {
        _aidCount = await _aidService.getAidsCountByBeneficiary(email);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setLoading(false);
    }
  }

  Future<void> createAidDistribution(Map<String, dynamic> aidData) async {
    setLoading(true);
    _error = null;

    try {
      final createdAid = await _aidService.createAidDistribution(aidData);
      _aidList.add(createdAid);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      print(_error);
      throw Exception(_error);
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateAidDistribution(
      String id, Map<String, dynamic> updatedData) async {
    setLoading(true);
    _error = null;

    try {
      final updatedAid =
          await _aidService.updateAidDistribution(id, updatedData);
      final index = _aidList.indexWhere((a) => a.id == id);
      if (index != -1) {
        _aidList[index] = updatedAid;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteAidDistribution(String id) async {
    setLoading(true);
    _error = null;

    try {
      await _aidService.deleteAidDistribution(id);
      _aidList.removeWhere((a) => a.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      setLoading(false);
    }
  }
}
