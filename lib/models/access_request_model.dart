class AccessRequestModel {
  final String? id;
  final String logo;
  final String name;
  final String crnNumber;
  final String email;
  final String reason;
  final List<String> supportingDocuments;

  AccessRequestModel({
    this.id,
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
