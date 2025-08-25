import 'package:flutter/material.dart';
import 'package:survey_app/utilities/cust_colors.dart';

class TTextFieldTheme{
  TTextFieldTheme._();
  static final InputDecorationTheme inputDecoration = InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFf9f9fb),
    hintStyle: const TextStyle(color: Colors.grey),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: CustColors.grey100),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: CustColors.soft_indigo,
        width: 2,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(
        vertical: 14, horizontal: 16),
  );
}