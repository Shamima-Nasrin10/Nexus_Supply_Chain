import 'package:flutter/material.dart';

class NotifyUtil {
  static void success(BuildContext context, String? message) {
    final msg = message ?? 'Successful';
    _showSnackBar(context, msg, Colors.green);
  }

  static void error(BuildContext context, dynamic error) {
    String errorMessage;

    if (error is String) {
      errorMessage = error;
    } else if (error is Exception) {
      errorMessage = error.toString();
    } else {
      errorMessage = error?.message ?? error.toString() ?? 'An error occurred';
    }

    _showSnackBar(context, errorMessage, Colors.red);
  }

  static void _showSnackBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
