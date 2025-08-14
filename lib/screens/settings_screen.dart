  import 'package:flutter/material.dart';
  import 'package:shared_preferences/shared_preferences.dart';

  class SettingsScreen extends StatefulWidget {
    final bool isDarkMode;
    final ValueChanged<bool> onThemeChanged;
    final ValueChanged<String> onLanguageChanged; // Tambahan untuk sinkron bahasa
    final String languageCode; // Tambah ini
    

    const SettingsScreen({
      super.key,
      required this.isDarkMode,
      required this.onThemeChanged,
      required this.onLanguageChanged, // Tambahan
      required this.languageCode,      // Tambah ini
    });

    @override
    State<SettingsScreen> createState() => _SettingsScreenState();
  }

  class _SettingsScreenState extends State<SettingsScreen> {
    // Warna dari MainScreen
    static const Color _bgColor1 = Color(0xFF12093E);
    static const Color _bgColor2 = Color(0xFF140A42);
    static const Color _bgColor3 = Color(0xFF150A43);
    static const Color _lightBgColor1 = Color(0xFFEDE7F6);
    static const Color _lightBgColor2 = Color(0xFFF3E5F5);

    late bool _darkModeValue;
    String _selectedLanguage = 'id';

    // Getter warna
    Color get _appBarColor =>
        _darkModeValue ? _bgColor1.withOpacity(0.9) : _lightBgColor1.withOpacity(0.9);

    Color get _textColor => _darkModeValue ? Colors.white : Colors.black;
    Color get _iconColor => _darkModeValue ? Colors.white : Colors.black;

    @override
    void initState() {
      super.initState();
      _darkModeValue = widget.isDarkMode;
      _loadPreferences();
    }

    @override
    void didUpdateWidget(covariant SettingsScreen oldWidget) {
      super.didUpdateWidget(oldWidget);
      if (oldWidget.isDarkMode != widget.isDarkMode) {
        setState(() {
          _darkModeValue = widget.isDarkMode;
        });
      }
    }

    Future<void> _loadPreferences() async {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _selectedLanguage = prefs.getString('language') ?? 'id';
      });
    }

    Future<void> _saveThemePreference(bool value) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', value);
    }

    Future<void> _saveLanguagePreference(String langCode) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', langCode);
    }

    void _toggleTheme(bool value) {
      setState(() {
        _darkModeValue = value;
      });
      widget.onThemeChanged(value);
      _saveThemePreference(value);
    }

    void _showLanguagePopup() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: _darkModeValue ? _bgColor2 : _lightBgColor2,
            title: Text(
              _selectedLanguage == 'id' ? "Pilih Bahasa" : "Choose Language",
              style: TextStyle(color: _textColor),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  activeColor: _darkModeValue ? Colors.blue[200] : Colors.blue,
                  title: Text(
                    "Indonesia",
                    style: TextStyle(color: _textColor),
                  ),
                  value: 'id',
                  groupValue: _selectedLanguage,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                      _saveLanguagePreference(value);
                      widget.onLanguageChanged(value); // Sinkron bahasa
                      Navigator.pop(context);
                    }
                  },
                ),
                RadioListTile<String>(
                  activeColor: _darkModeValue ? Colors.blue[200] : Colors.blue,
                  title: Text(
                    "English",
                    style: TextStyle(color: _textColor),
                  ),
                  value: 'en',
                  groupValue: _selectedLanguage,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                      _saveLanguagePreference(value);
                      widget.onLanguageChanged(value); // Sinkron bahasa
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    @override
    Widget build(BuildContext context) {
      final backgroundColor = _darkModeValue ? _bgColor3 : _lightBgColor2;

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            _selectedLanguage == 'id' ? "Pengaturan" : "Settings",
          ),
          backgroundColor: _appBarColor,
          centerTitle: true,
          iconTheme: IconThemeData(color: _iconColor),
          titleTextStyle: TextStyle(color: _textColor, fontSize: 20),
        ),
        body: ListView(
          children: [
            const Divider(height: 1),
            ListTile(
              leading: Icon(Icons.dark_mode, color: _iconColor),
              title: Text(
                _selectedLanguage == 'id' ? "Pilih Mode" : "Choose Mode",
                style: TextStyle(color: _textColor),
              ),
              subtitle: Text(
                _darkModeValue
                    ? (_selectedLanguage == 'id' ? "Mode Gelap" : "Dark Mode")
                    : (_selectedLanguage == 'id' ? "Mode Cerah" : "Light Mode"),
                style: TextStyle(color: _textColor.withOpacity(0.7)),
              ),
              trailing: Switch(
                value: _darkModeValue,
                onChanged: _toggleTheme,
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(Icons.language, color: _iconColor),
              title: Text(
                _selectedLanguage == 'id' ? "Pilih Bahasa" : "Choose Language",
                style: TextStyle(color: _textColor),
              ),
              subtitle: Text(
                _selectedLanguage == 'id' ? "Indonesia" : "English",
                style: TextStyle(color: _textColor.withOpacity(0.7)),
              ),
              onTap: _showLanguagePopup,
            ),
            const Divider(height: 1),
          ],
        ),
      );
    }
  }