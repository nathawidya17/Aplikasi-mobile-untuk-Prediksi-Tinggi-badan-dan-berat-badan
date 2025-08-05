import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset('assets/images/D-Estima.png', height: 100),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'D-Estima',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'D-Estima adalah aplikasi sederhana untuk memperkirakan tinggi dan berat badan pasien dewasa berdasarkan pengukuran antropometri panjang lengan (ulna) dan lingkar lengan atas (LILA). Aplikasi ini cocok digunakan pada kondisi di mana pengukuran tinggi dan berat badan secara langsung tidak memungkinkan.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16),
            ),
            const Divider(height: 32, thickness: 1),
            const Text(
              'Pengembang',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hilman', 
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Kontak Email', 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'hilman@gmail.com',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
