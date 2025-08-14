import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/about_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  String _languageCode = 'id';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _languageCode = prefs.getString('languageCode') ?? 'id';
      _isLoading = false;
    });
  }

  Future<void> _changeLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', langCode);
    setState(() {
      _languageCode = langCode;
    });
  }

  Future<void> _changeTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      title: 'D-Estima',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        languageCode: _languageCode,
        onLanguageChanged: _changeLanguage,
      ),
      routes: {
        '/about': (_) => AboutScreen(
              isDarkMode: _isDarkMode,
              languageCode: _languageCode,
              onLanguageChanged: _changeLanguage,
            ),
        '/settings': (_) => SettingsScreen(
              isDarkMode: _isDarkMode,
              onThemeChanged: _changeTheme,
              languageCode: _languageCode,
              onLanguageChanged: _changeLanguage,
            ),
      },
    );
  }
}