import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:survey_app/view/home/homescreen.dart';
import 'package:survey_app/view/spalash/SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Election Survey',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: GoogleFonts.robotoSlabTextTheme(), // ✨ Election-suitable font
        useMaterial3: true,
      ),
      home: const HomeScreen(), // Optional: change to Splash first
      debugShowCheckedModeBanner: false,
    );
  }
}
