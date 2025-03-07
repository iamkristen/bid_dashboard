import 'dart:convert';

class RegisteredUserData {
  final String id;
  final String url;
  final String name;

  RegisteredUserData({required this.id, required this.url, required this.name});

  factory RegisteredUserData.fromJson(String str) =>
      RegisteredUserData.fromMap(json.decode(str));

  factory RegisteredUserData.fromMap(Map<String, dynamic> json) =>
      RegisteredUserData(
        id: json["id"],
        url: json["url"],
        name: json["name"],
      );
}
