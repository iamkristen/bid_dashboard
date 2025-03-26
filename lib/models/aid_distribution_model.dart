class AidDistributionModel {
  final String? id;
  final String beneficiaryId;
  final String aidType;
  final int quantity;
  final String unit;
  final String distributedBy;
  final String location;
  final String? notes;
  final DateTime? expire;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AidDistributionModel({
    this.id,
    required this.beneficiaryId,
    required this.aidType,
    required this.quantity,
    required this.unit,
    required this.distributedBy,
    required this.location,
    required this.expire,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory AidDistributionModel.fromJson(Map<String, dynamic> json) {
    return AidDistributionModel(
      id: json["_id"],
      beneficiaryId: json["beneficiaryId"],
      aidType: json["aidType"],
      quantity: json["quantity"],
      unit: json["unit"],
      distributedBy: json["distributedBy"],
      location: json["location"],
      notes: json["notes"],
      expire: json["expire"] != null ? DateTime.parse(json["expire"]) : null,
      createdAt:
          json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
      updatedAt:
          json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "beneficiaryId": beneficiaryId,
      "aidType": aidType,
      "quantity": quantity,
      "unit": unit,
      "distributedBy": distributedBy,
      "location": location,
      "notes": notes,
      "expire": expire?.toIso8601String(),
    };
  }
}
