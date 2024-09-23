import 'package:flutter/material.dart';
import 'package:note_app_database/setting_page.dart';
import 'package:note_app_database/sign_up_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'log_in_page.dart';
import 'main_activity.dart';
import 'not_app_splash_screen.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  double fontSize = 12.0;
  String fontStyle = 'Kalnia_Glaze';
  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
      fontSize = prefs.getDouble('fontSize') ?? 12.0;
      fontStyle = prefs.getString('fontStyle') ?? 'Kalnia_Glaze';
    });
  }

  void updateTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  void updateFontSize(double value) {
    setState(() {
      fontSize = value;
    });
  }

  void updateFontStyle(String value) {
    setState(() {
      fontStyle = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark(
      ) : ThemeData.light(),
      routes: {
        '/settings': (context) => SettingsPage(
          updateTheme: updateTheme,
          updateFontSize: updateFontSize,
          updateFontStyle: updateFontStyle,
        ),
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/main': (context) => const MainActivity(),
      },
      builder: (context, child) {
        return DefaultTextStyle(
          style: TextStyle(fontSize: fontSize, fontFamily: fontStyle),
          child: child!,
        );
      },
    );
  }
}

