import 'package:flutter/material.dart';
import 'about_screen.dart';
import 'history_screen.dart';
import '../models/calculation_history.dart';

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
  final List<CalculationHistory> _historyList = [];

  @override
  void dispose() {
    _panjangLenganController.dispose();
    _lilaController.dispose();
    super.dispose();
  }

  void _hitungEstimasi() {
    if (_formKey.currentState!.validate()) {
      // Menggunakan replaceAll untuk memastikan input koma juga diterima
      final panjangLengan =
          double.tryParse(_panjangLenganController.text.replaceAll(',', '.')) ??
              0;
      final lila =
          double.tryParse(_lilaController.text.replaceAll(',', '.')) ?? 0;

      double tinggiBadan = 0;
      double beratBadan = 0;

      if (_selectedGender == 'L') {
        tinggiBadan = 97.252 + (2.645 * panjangLengan);
        beratBadan = -93.2 + (3.29 * lila) + (0.43 * tinggiBadan);
      } else if (_selectedGender == 'P') {
        tinggiBadan = 68.777 + (3.536 * panjangLengan);
        beratBadan = -64.6 + (2.15 * lila) + (0.54 * tinggiBadan);
      }

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
        _historyList.insert(0, newHistoryEntry);
      });
      // Menutup keyboard setelah menghitung untuk pengalaman pengguna yang lebih baik
      FocusScope.of(context).unfocus();
    }
  }

  void _resetForm() {
    setState(() {
      _formKey.currentState?.reset();
      _selectedGender = null;
      _panjangLenganController.clear();
      _lilaController.clear();
      _hasilTinggiBadan = null;
      _hasilBeratBadan = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0013),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C0013),
        elevation: 0,
        title: Image.asset(
          'assets/images/D-Estima1.png',
          height: 40,
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF0B0014),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading:
                  false, // Menghilangkan tombol back di drawer
              title: const Text("Menu", style: TextStyle(color: Colors.white)),
            ),
            _buildMenuItem(context, "Kalkulator", Icons.calculate, () {
              Navigator.pop(context); // Cukup tutup drawer
            }),
            const Divider(color: Colors.white54, thickness: 0.5),
            _buildMenuItem(context, "Riwayat", Icons.history, () {
              Navigator.pop(context); // Tutup drawer dulu
              Navigator.push(
                context,
                MaterialPageRoute(
                  // FIX: Mengirim list riwayat yang benar
                  builder: (_) => HistoryScreen(historyList: _historyList),
                ),
              );
            }),
            const Divider(color: Colors.white54, thickness: 0.5),
            _buildMenuItem(context, "Tentang Aplikasi", Icons.info, () {
              Navigator.pop(context); // Tutup drawer dulu
              Navigator.push(
                context,
                // FIX: AboutScreen tidak memerlukan historyList
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            }),
            const Divider(color: Colors.white54, thickness: 0.5),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("KALKULATOR",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const Divider(color: Colors.white),
              const SizedBox(height: 12),
              _buildDropdownGender(),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _panjangLenganController,
                label: "Panjang Lengan (ULNA)",
                hint: "contoh: 25 atau 26.5",
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _lilaController,
                label: "Lingkar Lengan Atas (LILA)",
                hint: "contoh: 28 atau 29.5",
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton("Hitung", _hitungEstimasi),
                  const SizedBox(width: 12),
                  // Tombol reset akan muncul jika ada input atau hasil
                  if (_panjangLenganController.text.isNotEmpty ||
                      _hasilTinggiBadan != null)
                    _buildButton("Reset", _resetForm),
                ],
              ),
              const SizedBox(height: 24),
              if (_hasilTinggiBadan != null && _hasilBeratBadan != null)
                _buildResultBox(),
            ],
          ),
        ),
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

  Widget _buildDropdownGender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Pilih Jenis Kelamin",
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          dropdownColor: const Color(0xFF1E0A2A),
          value: _selectedGender,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          hint: const Text('Pria/Wanita',
              style: TextStyle(color: Colors.white70)),
          decoration: _inputDecoration(),
          items: const [
            DropdownMenuItem(
                value: 'L',
                child: Text('Pria', style: TextStyle(color: Colors.white))),
            DropdownMenuItem(
                value: 'P',
                child: Text('Wanita', style: TextStyle(color: Colors.white))),
          ],
          onChanged: (value) => setState(() => _selectedGender = value),
          validator: (value) =>
              value == null ? 'Jenis kelamin harus diisi' : null,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          style: const TextStyle(color: Colors.white),
          controller: controller,
          decoration: _inputDecoration().copyWith(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label harus diisi';
            }
            if (double.tryParse(value.replaceAll(',', '.')) == null) {
              return 'Masukkan angka yang valid';
            }
            return null;
          },
        ),
      ],
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white54),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor:
              text == "Reset" ? Colors.transparent : const Color(0xFF6A1B9A),
          foregroundColor: Colors.white,
          side: text == "Reset"
              ? const BorderSide(color: Colors.white54)
              : BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _buildResultBox() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E0A2A),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("Hasil Estimasi",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildResultRow(
              "Tinggi Badan", "${_hasilTinggiBadan!.toStringAsFixed(2)} cm"),
          const SizedBox(height: 8),
          _buildResultRow(
              "Berat Badan", "${_hasilBeratBadan!.toStringAsFixed(2)} kg"),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$label :",
            style: const TextStyle(color: Colors.white70, fontSize: 16)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
