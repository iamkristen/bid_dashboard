import 'package:dashboard/helper/app_fonts.dart';
import 'package:flutter/material.dart';

class CustomMessage {
  static void show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    TextStyle? textStyle,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textStyle ??
              AppTextStyles.poppinsRegularStyle.copyWith(
                color: Colors.white,
                fontSize: 14,
              ),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
      ),
    );
  }
}
