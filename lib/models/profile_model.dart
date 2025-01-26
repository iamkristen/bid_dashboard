class ProfileModel {
  final String logo;
  final String name;
  final String crnNumber;
  final String email;
  final String reason;
  final List<String> supportingDocuments;

  ProfileModel({
    required this.logo,
    required this.name,
    required this.crnNumber,
    required this.email,
    required this.reason,
    required this.supportingDocuments,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      logo: json['logo'],
      name: json['name'],
      crnNumber: json['crnNumber'],
      email: json['email'],
      reason: json['reason'],
      supportingDocuments: List<String>.from(json['supportingDocuments']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "logo": logo,
      "name": name,
      "crnNumber": crnNumber,
      "email": email,
      "reason": reason,
      "supportingDocuments": supportingDocuments,
    };
  }
}
