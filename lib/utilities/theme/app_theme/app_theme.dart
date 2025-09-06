import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:survey_app/utilities/cust_colors.dart';
import 'package:survey_app/utilities/theme/elevated_button_theme/TElevatedButtonTheme.dart';
import 'package:survey_app/utilities/theme/text_field_theme/TTextFieldTheme.dart';

class AppTheme{
  AppTheme._();
  static final ThemeData light = ThemeData(
    appBarTheme: AppBarTheme(
       backgroundColor: CustColors.background1,
      foregroundColor: Colors.white,
    ),
    primarySwatch: Colors.indigo,
    textTheme: GoogleFonts.joanTextTheme().copyWith(), // ✨ Election-suitable font
    useMaterial3: true,
    elevatedButtonTheme: ElevatedButtonThemeData(style: TElevatedButtonTheme.buttonStyle),
    inputDecorationTheme: TTextFieldTheme.inputDecoration
  );

  static final ThemeData dark = ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: CustColors.background1,
        foregroundColor: Colors.white,
      ),
    primarySwatch: Colors.indigo,
    textTheme: GoogleFonts.robotoSlabTextTheme(), // ✨ Election-suitable font
    useMaterial3: true,
      elevatedButtonTheme: ElevatedButtonThemeData(style: TElevatedButtonTheme.buttonStyle),
    inputDecorationTheme: TTextFieldTheme.inputDecoration,
  );
}