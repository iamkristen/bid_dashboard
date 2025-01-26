import 'package:dashboard/components/loading_screen.dart';
import 'package:flutter/material.dart';

class LoadingDialog {
  static void show(BuildContext context, {required String loadingText}) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (_) => CustomLoadingScreen(loadingText: loadingText),
    );
  }

  static void dismiss(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop(); // Close the dialog
  }
}
