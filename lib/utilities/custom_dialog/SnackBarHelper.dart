import 'package:flutter/material.dart';
import 'package:survey_app/utilities/cust_colors.dart';


class SnackBarHelper {
  static void show(
      BuildContext context,
      String message, {
        Color backgroundColor = CustColors.background1,
        Duration duration = const Duration(seconds: 2),
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        margin: const EdgeInsets.all(8.0),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: duration,
      ),
    );
  }
}
