import 'package:flutter/material.dart';
import '../models/calculation_history.dart';
import 'about_screen.dart';
import 'main_screen.dart';

class HistoryScreen extends StatefulWidget {
  final List<CalculationHistory> historyList;

  const HistoryScreen({super.key, required this.historyList});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  void _deleteHistoryItem(int index) {
    setState(() {
      widget.historyList.removeAt(index);
    });
  }

  Future<void> _showDeleteConfirmationDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E0A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text(
            'Konfirmasi Hapus',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Apakah Anda yakin ingin menghapus riwayat ini?',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tidak', style: TextStyle(color: Colors.white70)),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: const Text('Ya, Hapus', style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                Navigator.of(context).pop(); 
                _deleteHistoryItem(index);  
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0013),
      appBar: AppBar(
        title: const Text('Riwayat Perhitungan'),
        backgroundColor: const Color(0xFF0C0013),
        elevation: 0,
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF0B0014),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: const Text("Menu", style: TextStyle(color: Colors.white)),
            ),
            _buildMenuItem(context, "Kalkulator", Icons.calculate, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainScreen()),
              );
            }),
            const Divider(color: Colors.white54, thickness: 0.5),
            _buildMenuItem(context, "Riwayat", Icons.history, () {
              Navigator.pop(context);
            }),
            const Divider(color: Colors.white54, thickness: 0.5),
            _buildMenuItem(context, "Tentang Aplikasi", Icons.info, () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            }),
            const Divider(color: Colors.white54, thickness: 0.5),
          ],
        ),
      ),
      body: widget.historyList.isEmpty
          ? const Center(
              child: Text(
                'Belum ada riwayat perhitungan.',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: widget.historyList.length,
              itemBuilder: (context, index) {
                final item = widget.historyList[index];
                return Card(
                  color: const Color(0xFF1E0A2A),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.gender,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16),
                        ),
                        const Divider(color: Colors.white24, height: 16),
                        Text(
                          'TB: ${item.tinggiBadan.toStringAsFixed(2)} cm & BB: ${item.beratBadan.toStringAsFixed(2)} kg',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Input -> PL: ${item.panjangLengan} cm, LILA: ${item.lila} cm',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text(
                              '${item.timestamp.day}/${item.timestamp.month}/${item.timestamp.year} - ${item.timestamp.hour}:${item.timestamp.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(color: Colors.white54, fontSize: 12)
                            ),
                            InkWell(
                              onTap: () => _showDeleteConfirmationDialog(index),
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, IconData icon, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}
