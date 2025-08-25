import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey_app/utilities/consts.dart';
import 'package:survey_app/utilities/theme/app_theme/app_theme.dart';
import 'package:survey_app/view/home/homescreen.dart';
import 'package:survey_app/view/spalash/SplashScreen.dart';

import 'model/AppUser.dart';

late SharedPreferences prefs;

Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  final data = {
    Consts.isOnBoarded: prefs.getBool(Consts.isOnBoarded),
    Consts.performed: prefs.getBool(Consts.performed),
    Consts.accessToken: prefs.getString(Consts.accessToken),
    Consts.name: prefs.getString(Consts.name),
    Consts.isStaff: prefs.getBool(Consts.isStaff),
    Consts.isActive: prefs.getBool(Consts.isActive),
    Consts.photo: prefs.getString(Consts.photo),
    Consts.isLogin : prefs.getBool(Consts.isLogin)
  };
  runApp(
    // MyApp()
    ChangeNotifierProvider(
      create: (_) => AppUser.fromPrefs(data),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Election Survey',
      darkTheme: AppTheme.dark,
      theme: AppTheme.light,
      themeMode: ThemeMode.system,
      home: const SplashScreen(), // Optional: change to Splash first
      debugShowCheckedModeBanner: false,
    );
  }
}
