class IdentityResponseModel {
  final String status;
  final List<IdentityRequestModel> data;

  IdentityResponseModel({
    required this.status,
    required this.data,
  });

  factory IdentityResponseModel.fromJson(Map<String, dynamic> json) {
    return IdentityResponseModel(
      status: json['status'],
      data: (json['data'] as List)
          .map((item) => IdentityRequestModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((item) => item.toJson(includeId: true)).toList(),
    };
  }
}

class IdentityRequestModel {
  final String? id; // Nullable for creation
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
  final String? responseReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  IdentityRequestModel({
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
    this.responseReason = "",
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory IdentityRequestModel.fromJson(Map<String, dynamic> json) {
    return IdentityRequestModel(
      id: json['_id'],
      fullName: json['fullName'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      nationality: json['nationality'],
      placeOfBirth: json['placeOfBirth'],
      residentialAddress: json['residentialAddress'],
      biometricHash: json['biometricHash'],
      profileImage: json['profileImage'],
      action: json['action'],
      status: json['status'],
      reason: json['reason'],
      responseReason: json['responseReason'] ?? "",
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['__v'],
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
