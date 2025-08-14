import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  final bool isDarkMode;
  final String languageCode;
  final void Function(String) onLanguageChanged;

  const AboutScreen({
    super.key,
    this.isDarkMode = true,
    required this.languageCode,
    required this.onLanguageChanged,
  });

  // Warna
  static const Color _bgColor1 = Color(0xFF12093E);
  static const Color _bgColor2 = Color(0xFF140A42);
  static const Color _bgColor3 = Color(0xFF150A43);
  static const Color _lightBgColor1 = Color(0xFFEDE7F6);
  static const Color _lightBgColor2 = Color(0xFFF3E5F5);

  Color get _appBarColor =>
      isDarkMode ? _bgColor1.withOpacity(0.9) : _lightBgColor1.withOpacity(0.9);

  Color get _textColor => isDarkMode ? Colors.white : Colors.black;
  Color get _iconColor => isDarkMode ? Colors.white : Colors.black;
  Color get _linkColor =>
      isDarkMode ? Colors.lightBlueAccent : Colors.blueAccent;

  Future<void> _openEmail(String email) async {
    if (kIsWeb) {
      final Uri gmailWeb = Uri.parse(
        'https://mail.google.com/mail/?view=cm&fs=1&to=$email',
      );
      if (!await launchUrl(gmailWeb, mode: LaunchMode.externalApplication)) {
        throw 'Tidak bisa membuka Gmail Web';
      }
    } else {
      final Uri emailApp = Uri(
        scheme: 'mailto',
        path: email,
      );
      if (!await launchUrl(emailApp)) {
        throw 'Tidak bisa membuka aplikasi email';
      }
    }
  }

  String _t(String id) {
    // Terjemahan sederhana
    const translations = {
      'title': {
        'id': 'Tentang Aplikasi',
        'en': 'About App',
      },
      'desc': {
        'id':
            'D-Estima (Digital Estimator Berat dan Tinggi Badan Pasien) adalah aplikasi yang dirancang untuk membantu tenaga kesehatan dan masyarakat umum dalam mengestimasi tinggi badan dan berat badan berdasarkan jenis kelamin, panjang lengan bawah (ULNA), dan lingkar lengan atas (LILA).\n\nAplikasi ini berguna dalam situasi ketika pengukuran langsung tidak memungkinkan, seperti pada pasien yang terbaring di tempat tidur.',
        'en':
            'D-Estima (Digital Estimator for Patient Height and Weight) is an application designed to help healthcare workers and the general public estimate height and weight based on gender, forearm length (ULNA), and upper arm circumference (MUAC).\n\nThis application is useful in situations where direct measurement is not possible, such as for bedridden patients.',
      },
      'developer': {
        'id': 'Pengembang',
        'en': 'Developer',
      },
      'developer_desc': {
        'id':
            'Aplikasi ini dikembangkan oleh Ns. Dendy Kharisna, M.Kep, Natha Widya Putra Nugraha, Jey Nintho Mahata, dan Hilman Cahya Wiguna, para pengembang yang memiliki minat di bidang teknologi kesehatan digital. Dengan tujuan untuk memberikan solusi praktis dalam penilaian antropometri, D-Estima dibuat sebagai alat bantu yang sederhana namun bermanfaat di berbagai kondisi.',
        'en':
            'This application was developed by Ns. Dendy Kharisna, M.Kep, Natha Widya Putra Nugraha, Jey Nintho Mahata, and Hilman Cahya Wiguna, developers with an interest in digital health technology. With the aim of providing practical solutions in anthropometric assessment, D-Estima was created as a simple yet useful tool in various conditions.',
      },
      'contact': {
        'id': 'Kontak',
        'en': 'Contact',
      }
    };

    return translations[id]?[languageCode] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode
      ? _bgColor1 // atau warna awal gradient
      : _lightBgColor1,
      appBar: AppBar(
        backgroundColor: _appBarColor,
        elevation: 1,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: _iconColor,
          size: 24,
        ),
        title: Text(
          _t('title'),
          style: TextStyle(
            color: _textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: isDarkMode
                ? LinearGradient(
                    colors: [_bgColor1, _bgColor2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [_lightBgColor1, _lightBgColor2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background gradient utama
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [_bgColor1, _bgColor2, _bgColor3]
                    : [_lightBgColor1, _lightBgColor2],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),

          // Glow circles hanya di dark mode
          if (isDarkMode) ...[
            Positioned(
              top: -120,
              left: -80,
              child: Container(
                width: 340,
                height: 340,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.purpleAccent.withOpacity(0.14),
                      Colors.transparent,
                    ],
                    radius: 0.9,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -140,
              right: -70,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.blueAccent.withOpacity(0.12),
                      Colors.transparent,
                    ],
                    radius: 0.9,
                  ),
                ),
              ),
            ),
          ],

          // Konten utama
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.black.withOpacity(0.28)
                          : Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                              isDarkMode ? 0.38 : 0.06),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: isDarkMode ? Colors.white12 : Colors.black12,
                      ),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/D-Estima1.png',
                          height: 100,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _t('desc'),
                          style: TextStyle(
                              color: _textColor, height: 1.5, fontSize: 15),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle(_t('developer'), _textColor),
                        const SizedBox(height: 10),
                        Text(
                          _t('developer_desc'),
                          style: TextStyle(
                              color: _textColor, height: 1.5, fontSize: 15),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle(_t('contact'), _textColor),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            _buildEmailLink(
                                "dendy.kharisna@payungnegeri.ac.id",
                                _linkColor),
                            _buildEmailLink("nathawidya7@gmail.com", _linkColor),
                            _buildEmailLink("jeynintho4@gmail.com", _linkColor),
                            _buildEmailLink("hilmancahya10@gmail.com", _linkColor),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildEmailLink(String email, Color color) {
    return GestureDetector(
      onTap: () => _openEmail(email),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          email,
          style: TextStyle(
            color: color,
            height: 1.6,
            fontSize: 15,
            decoration: TextDecoration.underline,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
