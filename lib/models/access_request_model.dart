class AccessResponseModel {
  final List<AccessRequestModel> data;
  final String status;
  final String? message;

  AccessResponseModel({
    required this.data,
    required this.status,
    this.message,
  });

  factory AccessResponseModel.fromJson(Map<String, dynamic> json) {
    return AccessResponseModel(
      status: json['status'],
      data: (json['data'] as List)
          .map((e) => AccessRequestModel.fromJson(e))
          .toList(),
      message: json['message'],
    );
  }
}

class AccessRequestModel {
  final String? id; // Make id nullable for creation
  final String logo;
  final String name;
  final String crnNumber;
  final String email;
  final String reason;
  final List<String> supportingDocuments;

  AccessRequestModel({
    this.id, // Nullable for create operations
    required this.logo,
    required this.name,
    required this.crnNumber,
    required this.email,
    required this.reason,
    required this.supportingDocuments,
  });

  factory AccessRequestModel.fromJson(Map<String, dynamic> json) {
    return AccessRequestModel(
      id: json['_id'], // Optional field for updates
      logo: json['logo'],
      name: json['name'],
      crnNumber: json['crnNumber'],
      email: json['email'],
      reason: json['reason'],
      supportingDocuments: (json['supportingDocuments'] as List).cast<String>(),
    );
  }

  Map<String, dynamic> toJson({bool forUpdate = false}) {
    final data = {
      if (forUpdate && id != null) '_id': id, // Include `_id` only for updates
      'logo': logo,
      'name': name,
      'crnNumber': crnNumber,
      'email': email,
      'reason': reason,
      'supportingDocuments': supportingDocuments,
    };
    return data;
  }
}
