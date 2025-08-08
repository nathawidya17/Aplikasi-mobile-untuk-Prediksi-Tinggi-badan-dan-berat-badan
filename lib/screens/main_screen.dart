import 'package:flutter/material.dart';
import 'about_screen.dart';
import 'history_screen.dart'; // 1. Impor halaman history
import '../models/calculation_history.dart'; // 2. Impor model data

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? _selectedGender;
  final _panjangLenganController = TextEditingController();
  final _lilaController = TextEditingController();

  double? _hasilTinggiBadan;
  double? _hasilBeratBadan;

  final _formKey = GlobalKey<FormState>();

  // 3. Buat list untuk menyimpan riwayat
  final List<CalculationHistory> _historyList = [];

  void _hitungEstimasi() {
    if (_formKey.currentState!.validate()) {
      double panjangLengan =
          double.tryParse(_panjangLenganController.text) ?? 0;
      double lila = double.tryParse(_lilaController.text) ?? 0;
      double tinggiBadan = 0;
      double beratBadan = 0;

      if (_selectedGender == 'L') {
        tinggiBadan = 97.252 + (2.645 * panjangLengan);
        beratBadan = -93.2 + (3.29 * lila) + (0.43 * tinggiBadan);
      } else if (_selectedGender == 'P') {
        tinggiBadan = 68.777 + (3.536 * panjangLengan);
        beratBadan = -64.6 + (2.15 * lila) + (0.54 * tinggiBadan);
      }

      // 4. Buat entri baru dan tambahkan ke list riwayat
      final newHistoryEntry = CalculationHistory(
        gender: _selectedGender == 'L' ? 'Laki-laki' : 'Perempuan',
        panjangLengan: panjangLengan,
        lila: lila,
        tinggiBadan: tinggiBadan,
        beratBadan: beratBadan,
        timestamp: DateTime.now(),
      );

      setState(() {
        _hasilTinggiBadan = tinggiBadan;
        _hasilBeratBadan = beratBadan;
        _historyList.insert(
            0, newHistoryEntry); // Masukkan ke posisi paling atas
      });
    }
  }

  @override
  void dispose() {
    _panjangLenganController.dispose();
    _lilaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Row(
          children: [
            Image.asset(
              'assets/images/D-Estima.png',
              height: 30,
            ),
            const SizedBox(width: 10),
            const Text('D-Estima'),
          ],
        ),
        actions: [
          // 5. Tambahkan tombol untuk membuka halaman history
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      HistoryScreen(historyList: _historyList),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ... (Sisa kode form input tidak berubah, jadi saya persingkat)
              DropdownButtonFormField<String>(
                value: _selectedGender,
                hint: const Text('Pilih Jenis Kelamin'),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                items: const [
                  DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                  DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Jenis kelamin harus diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _panjangLenganController,
                decoration: const InputDecoration(
                  labelText: 'Panjang Lengan ()',
                  hintText: 'Masukkan dalam cm',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.straighten),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Panjang lengan harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lilaController,
                decoration: const InputDecoration(
                  labelText: 'Lingkar Lengan Atas (LILA)',
                  hintText: 'Masukkan dalam cm',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.donut_small),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'LILA harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _hitungEstimasi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Hitung', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 24),
              if (_hasilTinggiBadan != null && _hasilBeratBadan != null)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hasil Estimasi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        const Divider(height: 20, thickness: 1),
                        Text(
                          'Tinggi Badan: ${_hasilTinggiBadan!.toStringAsFixed(2)} cm',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Berat Badan: ${_hasilBeratBadan!.toStringAsFixed(2)} kg',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
