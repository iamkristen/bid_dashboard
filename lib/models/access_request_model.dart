class ProfileResponse {
  final int totalProfiles;
  final int totalPages;
  final int currentPage;
  final int limit;
  final List<AccessRequestModel> data;

  ProfileResponse({
    required this.totalProfiles,
    required this.totalPages,
    required this.currentPage,
    required this.limit,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      totalProfiles: json["totalProfiles"] ?? 0,
      totalPages: json["totalPages"] ?? 0,
      currentPage: json["currentPage"] ?? 1,
      limit: json["limit"] ?? 10,
      data: (json["data"] as List)
          .map((e) => AccessRequestModel.fromJson(e))
          .toList(),
    );
  }
}

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
