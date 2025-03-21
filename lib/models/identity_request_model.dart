class UserIdentityResponse {
  final int totalUsers;
  final int totalPages;
  final int currentPage;
  final int limit;
  final List<UserData> data;

  UserIdentityResponse({
    required this.totalUsers,
    required this.totalPages,
    required this.currentPage,
    required this.limit,
    required this.data,
  });

  factory UserIdentityResponse.fromJson(Map<String, dynamic> json) {
    return UserIdentityResponse(
      totalUsers: json["totalUsers"] ?? 0,
      totalPages: json["totalPages"] ?? 0,
      currentPage: json["currentPage"] ?? 1,
      limit: json["limit"] ?? 10,
      data: (json["data"] as List<dynamic>?)
              ?.map((e) => UserData.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class UserData {
  final String? id;
  final String fullName;
  final String dateOfBirth;
  final String gender;
  final String nationality;
  final String placeOfBirth;
  final String residentialAddress;
  final String biometricHash;
  final String profileImage;
  final String action;
  final String status;
  final String reason;
  final String responseReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  UserData({
    this.id,
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.nationality,
    required this.placeOfBirth,
    required this.residentialAddress,
    required this.biometricHash,
    required this.profileImage,
    required this.action,
    required this.status,
    required this.reason,
    required this.responseReason,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'],
      fullName: json['fullName'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      gender: json['gender'] ?? '',
      nationality: json['nationality'] ?? '',
      placeOfBirth: json['placeOfBirth'] ?? '',
      residentialAddress: json['residentialAddress'] ?? '',
      biometricHash: json['biometricHash'] ?? '',
      profileImage: json['profileImage'] ?? '',
      action: json['action'] ?? '',
      status: json['status'] ?? '',
      reason: json['reason'] ?? '',
      responseReason: json['responseReason'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson({bool includeId = false}) {
    final data = {
      if (includeId && id != null) '_id': id,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'nationality': nationality,
      'placeOfBirth': placeOfBirth,
      'residentialAddress': residentialAddress,
      'biometricHash': biometricHash,
      'profileImage': profileImage,
      'action': action,
      'status': status,
      'reason': reason,
      'responseReason': responseReason,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
    return data;
  }
}
