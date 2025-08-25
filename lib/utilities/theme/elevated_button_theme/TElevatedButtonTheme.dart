import 'package:flutter/material.dart';
import 'package:survey_app/utilities/cust_colors.dart';

class TElevatedButtonTheme{
  TElevatedButtonTheme._();
  static final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: CustColors.soft_indigo,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}