import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey_app/providers/LocationFilterData.dart';
import 'package:survey_app/utilities/consts.dart';
import 'package:survey_app/utilities/theme/app_theme/app_theme.dart';
import 'package:survey_app/view/spalash/SplashScreen.dart';
import 'model/AppUser.dart';


late SharedPreferences prefs;

Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final data = {
    Consts.isOnBoarded: prefs.getBool(Consts.isOnBoarded)??false,
    Consts.performed: prefs.getBool(Consts.performed)??false,
    Consts.accessToken: prefs.getString(Consts.accessToken)??'N/A',
    Consts.name: prefs.getString(Consts.name)??'N/A',
    Consts.isStaff: prefs.getBool(Consts.isStaff)??false,
    Consts.isActive: prefs.getBool(Consts.isActive)??false,
    Consts.photo: prefs.getString(Consts.photo)??'N/A',
    Consts.isLogin : prefs.getBool(Consts.isLogin)??false
  };
  runApp(
    // MyApp()
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_)=>AppUser.fromPrefs(data),lazy: false,),
          ChangeNotifierProvider(create: (_){
            final provider = LocationFilterData();
            provider.getInitialData();
            return provider;
          },lazy: false,),
        ],
      child: MyApp(),
  )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context,child){
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler:TextScaler.noScaling ),
          child: child!,
        );
      },
      title: 'Election Survey',
      darkTheme: AppTheme.dark,
      theme: AppTheme.light,
      themeMode: ThemeMode.system,
      home: const SplashScreen(), // Optional: change to Splash first
      debugShowCheckedModeBanner: false,
    );
  }
}
