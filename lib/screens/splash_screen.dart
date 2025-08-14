import 'dart:async';
import 'package:flutter/material.dart';
import 'main_screen.dart'; // Impor halaman utama

class SplashScreen extends StatefulWidget {
  final String languageCode;
  final Function(String) onLanguageChanged;

  const SplashScreen({
    Key? key,
    required this.languageCode,
    required this.onLanguageChanged,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainScreen(
            languageCode: widget.languageCode, // ✅ ambil dari root
            onLanguageChanged: widget.onLanguageChanged, // ✅ langsung terhubung ke root
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0013),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _animation,
                child: Image.asset(
                  'assets/images/D-Estima1.png', 
                  width: 150,
                  height: 150,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'D-Estima',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0), 
                ),
              ),
              const Text(
                'Digital Estimator Berat dan Tinggi Badan',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFFFFFFF), 
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1565C0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}