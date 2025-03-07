class ResponseHelper<T> {
  final bool success;
  final String? message;
  final T? data;

  ResponseHelper({required this.success, this.message, this.data});

  factory ResponseHelper.fromJson(
    Map<String, dynamic> json,
  ) {
    return ResponseHelper(
      success: json['success'],
      message: json['message'],
      data: json['data'],
    );
  }
}
