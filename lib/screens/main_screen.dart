import 'package:flutter/material.dart';
import 'about_screen.dart'; // Impor halaman tentang

class MainScreen extends StatefulWidget {
  // Menambahkan const di constructor
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Variabel untuk menyimpan data input dan hasil
  String? _selectedGender; // L untuk Laki-laki, P untuk Perempuan
  final _panjangLenganController = TextEditingController();
  final _lilaController = TextEditingController();

  double? _hasilTinggiBadan;
  double? _hasilBeratBadan;

  // GlobalKey untuk validasi form
  final _formKey = GlobalKey<FormState>();

  void _hitungEstimasi() {
    // Validasi form sebelum menghitung
    if (_formKey.currentState!.validate()) {
      // Ambil nilai dari input controller
      double panjangLengan =
          double.tryParse(_panjangLenganController.text) ?? 0;
      double lila = double.tryParse(_lilaController.text) ?? 0;
      double tinggiBadan = 0;
      double beratBadan = 0;

      // Logika perhitungan berdasarkan rumus
      if (_selectedGender == 'L') {
        // Rumus Laki-laki
        tinggiBadan = 97.252 + (2.645 * panjangLengan);
        beratBadan = -93.2 + (3.29 * lila) + (0.43 * tinggiBadan);
      } else if (_selectedGender == 'P') {
        // Rumus Perempuan
        tinggiBadan = 68.777 + (3.536 * panjangLengan);
        beratBadan = -64.6 + (2.15 * lila) + (0.54 * tinggiBadan);
      }

      // Perbarui state untuk menampilkan hasil di UI
      setState(() {
        _hasilTinggiBadan = tinggiBadan;
        _hasilBeratBadan = beratBadan;
      });
    }
  }

  // Hapus controller saat widget tidak digunakan untuk membebaskan memori
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
              'assets/images/D-estima.png', // Nama file logo diperbaiki
              height: 30,
            ),
            const SizedBox(width: 10),
          ],
        ),
        actions: [
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
                  labelText: 'Panjang Lengan (Ulna)',
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
