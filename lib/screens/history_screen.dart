// File: lib/screens/history_screen.dart

import 'package:flutter/material.dart';
import '../models/calculation_history.dart'; // Impor model yang tadi dibuat

class HistoryScreen extends StatelessWidget {
  final List<CalculationHistory> historyList;

  const HistoryScreen({super.key, required this.historyList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Perhitungan'),
        backgroundColor: Colors.blue[800],
      ),
      body: historyList.isEmpty
          ? const Center(
              child: Text(
                'Belum ada riwayat perhitungan.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final item = historyList[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: item.gender == 'Laki-laki'
                          ? Colors.blue
                          : Colors.pink,
                      child: Text(
                        item.gender[0], // Ambil huruf pertama 'L' atau 'P'
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      'TB: ${item.tinggiBadan.toStringAsFixed(2)} cm & BB: ${item.beratBadan.toStringAsFixed(2)} kg',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        'PL: ${item.panjangLengan} cm, LILA: ${item.lila} cm\nDiambil pada: ${item.timestamp.day}/${item.timestamp.month}/${item.timestamp.year} - ${item.timestamp.hour}:${item.timestamp.minute.toString().padLeft(2, '0')}'),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
