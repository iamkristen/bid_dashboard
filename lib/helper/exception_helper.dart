class UserFriendlyException implements Exception {
  final String message;

  UserFriendlyException(this.message);

  @override
  String toString() => message;
}
