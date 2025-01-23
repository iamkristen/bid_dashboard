class IdentityRequest {
  final String id;
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

  IdentityRequest({
    required this.id,
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
  });

  factory IdentityRequest.fromJson(Map<String, dynamic> json) {
    return IdentityRequest(
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
    );
  }
}
