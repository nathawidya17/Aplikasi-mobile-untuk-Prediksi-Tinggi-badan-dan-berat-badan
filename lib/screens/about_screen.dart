import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {

  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0013),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C0013),
        elevation: 0,
        title: const Text("Tentang Aplikasi"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/D-Estima1.png', 
              height: 100,
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Tentang Aplikasi"),
            const SizedBox(height: 10),
            const Text(
              "D-Estima (Digital Estimator Berat dan Tinggi Badan Pasien) adalah aplikasi yang dirancang untuk membantu tenaga kesehatan dan masyarakat umum dalam mengestimasi tinggi badan dan berat badan berdasarkan jenis kelamin, panjang lengan bawah (ulna), dan lingkar lengan atas (LiLA).\n\nAplikasi ini berguna dalam situasi ketika pengukuran langsung tidak memungkinkan, seperti pada pasien yang terbaring di tempat tidur.",
              style: TextStyle(color: Colors.white70, height: 1.5, fontSize: 15),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("Pengembang"),
            const SizedBox(height: 10),
            const Text(
              "Aplikasi ini dikembangkan oleh Ns. Dendy Kharisna, M.Kep, Natha Widya, Jey Nintho Mahata, dan Hilman Cahya, para pengembang yang memiliki minat di bidang teknologi kesehatan digital. Dengan tujuan untuk memberikan solusi praktis dalam penilaian antropometri, D-Estima dibuat sebagai alat bantu yang sederhana namun bermanfaat di berbagai kondisi.",
              style: TextStyle(color: Colors.white70, height: 1.5, fontSize: 15),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("Kontak"),
            const SizedBox(height: 10),
            const Text(
              "dendy.kharisna@payungnegeri.ac.id\n"
              "NathaWidya@example.com\n"
              "JeyNintho@example.com\n"
              "Hilman@example.com",
              style: TextStyle(color: Colors.lightBlueAccent, height: 1.6, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Widget bantuan untuk membuat judul seksi agar kode lebih rapi
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }
}
