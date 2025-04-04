import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dashboard/helper/secure_storage.dart';
import 'package:dashboard/helper/storage_constant.dart';
import 'package:dashboard/models/event_models.dart';
import 'package:dashboard/services/upload_services.dart';
import 'package:dashboard/services/event_service.dart';
import 'dart:html' as html;

class EventProvider with ChangeNotifier {
  final EventService _eventService = EventService();
  final UploadServices uploadServices = UploadServices();

  List<EventModel> _events = [];
  EventModel? _selectedEvent;

  bool _isLoading = false;
  String? _error;
  int _eventCount = 0;

  late String fileName;
  late String mimeType;
  Uint8List? bannerbytes;

  String _selectedFilter = 'All';

  // Form State Controllers
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? startTime;
  DateTime? endTime;
  bool isActive = true;

  List<EventModel> get events => _events;
  EventModel? get selectedEvent => _selectedEvent;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedFilter => _selectedFilter;
  int get eventCount => _eventCount;

  List<EventModel> get filteredEvents {
    if (_selectedFilter == 'All') return _events;
    if (_selectedFilter == 'Active') {
      return _events.where((e) => e.active == true).toList();
    }
    if (_selectedFilter == 'Inactive') {
      return _events.where((e) => e.active == false).toList();
    }
    if (_selectedFilter == 'Upcoming') {
      return _events
          .where((e) => DateTime.parse(e.startTime).isAfter(DateTime.now()))
          .toList();
    }
    if (_selectedFilter == 'Expired') {
      return _events
          .where((e) => DateTime.parse(e.endTime).isBefore(DateTime.now()))
          .toList();
    }
    return _events;
  }

  void resetFormData({EventModel? event}) {
    titleController.text = event?.title ?? '';
    locationController.text = event?.location ?? '';
    descriptionController.text = event?.description ?? '';
    startTime = event != null ? DateTime.parse(event.startTime) : null;
    endTime = event != null ? DateTime.parse(event.endTime) : null;
    isActive = event?.active ?? true;
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> createEventFromState() async {
    setLoading(true);
    _error = null;

    try {
      if (bannerbytes == null) {
        throw Exception('Please upload a banner for the event');
      }

      final email = await SecureStorage.read(StorageConstant.email);
      final organization = await SecureStorage.read(StorageConstant.orgName);
      final banner = await uploadServices.uploadSingleFile(
        fileName,
        bannerbytes!,
        mimeType,
      );

      final eventData = {
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'location': locationController.text.trim(),
        'startTime': startTime!.toIso8601String(),
        'endTime': endTime!.toIso8601String(),
        'active': isActive,
        'hostID': email ?? "",
        'organization': organization,
        'banner': banner['url'],
      };
      print('Event data: $eventData');
      final createdEvent = await _eventService.createEvent(eventData);
      _events.add(createdEvent);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      throw Exception(_error);
    } finally {
      setLoading(false);
    }
  }

  void updateEventActiveStatus(String eventId, bool activeStatus) {
    final index = _events.indexWhere((event) => event.id == eventId);
    if (index != -1) {
      _events[index].active = activeStatus;
      notifyListeners();
    }
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
        bannerbytes = reader.result as Uint8List?;
        notifyListeners();
      });
    });
  }

  Future<void> fetchAllEvents() async {
    setLoading(true);
    _error = null;

    try {
      final role = await SecureStorage.read(StorageConstant.role);
      final email = await SecureStorage.read(StorageConstant.email);
      if (role == 'admin') {
        _events = await _eventService.fetchAllEventsForAdmin();
      }
      if (role == 'org' && email != null) {
        _events = await _eventService.fetchAllEventsForOrg(email);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setLoading(false);
    }
  }

  Future<void> getEventsCount() async {
    setLoading(true);
    _error = null;

    try {
      final role = await SecureStorage.read(StorageConstant.role);
      final email = await SecureStorage.read(StorageConstant.email);
      if (role == 'admin') {
        _eventCount = await _eventService.fetchAllEventsCountForAdmin();
      }
      if (role == 'org' && email != null) {
        _eventCount = await _eventService.fetchAllEventsCountForOrg(email);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchEventById(String id) async {
    setLoading(true);
    _error = null;

    try {
      _selectedEvent = await _eventService.fetchEventById(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      setLoading(false);
    }
  }

  Future<void> createEvent(Map<String, dynamic> eventData) async {
    setLoading(true);
    _error = null;

    try {
      if (bannerbytes == null) {
        throw Exception('Please upload a banner for the event');
      }
      final banner = await uploadServices.uploadSingleFile(
        fileName,
        bannerbytes!,
        mimeType,
      );
      eventData['banner'] = banner['url'];
      final createdEvent = await _eventService.createEvent(eventData);
      _events.add(createdEvent);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      throw Exception(_error);
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateEvent(String id, Map<String, dynamic> updatedData) async {
    setLoading(true);
    _error = null;

    try {
      final updatedEvent = await _eventService.updateEvent(id, updatedData);
      final index = _events.indexWhere((e) => e.id == id);
      if (index != -1) {
        _events[index] = updatedEvent;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteEvent(String id) async {
    setLoading(true);
    _error = null;

    try {
      await _eventService.deleteEvent(id);
      _events.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      setLoading(false);
    }
  }
}
