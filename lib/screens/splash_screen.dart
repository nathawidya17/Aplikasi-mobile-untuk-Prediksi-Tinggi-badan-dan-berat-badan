import 'dart:async';
import 'package:flutter/material.dart';
import 'main_screen.dart'; // Impor halaman utama

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0013),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/D-Estima1.png', 
              width: 150,
              height: 150,
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
          ],
        ),
      ),
    );
  }
}
