import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculation_history.dart';
import 'about_screen.dart';
import 'history_screen.dart';
import '../models/history_service.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  final String languageCode;
  final ValueChanged<String> onLanguageChanged;
  const MainScreen({
    super.key,
    required this.languageCode,
    required this.onLanguageChanged,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late String _languageCode; // <-- simpan lokal dan bisa diubah

  String? _selectedGender;
  final _idRespondentController = TextEditingController();
  final _nameController = TextEditingController();
  final _panjangLenganController = TextEditingController();
  final _lilaController = TextEditingController();

  double? _hasilTinggiBadan;
  double? _hasilBeratBadan;
  double? _hasilBeratBadanAlternatif1;
  double? _hasilBeratBadanAlternatif2;

  final _formKey = GlobalKey<FormState>();
  final List<CalculationHistory> _historyList = [];

  bool _isDrawerOpen = false;
  bool _isDarkMode = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const Color _bgColor1 = Color(0xFF12093E);
  static const Color _bgColor2 = Color(0xFF140A42);
  static const Color _bgColor3 = Color(0xFF150A43);
  static const Color _lightBgColor1 = Color(0xFFEDE7F6);
  static const Color _lightBgColor2 = Color(0xFFF3E5F5);

  Color get _appBarColor => _isDarkMode
      ? _bgColor1.withOpacity(0.9)
      : _lightBgColor1.withOpacity(0.9);

  Color get _textColor => _isDarkMode ? Colors.white : Colors.black;
  Color get _iconColor => _isDarkMode ? Colors.white : Colors.black87;
  Color get _subTextColor => _isDarkMode ? Colors.white70 : Colors.black54;
  Color get _dividerColor => _isDarkMode ? Colors.white54 : Colors.black26;
  Color get _borderColor => _isDarkMode ? Colors.white54 : Colors.black54;
  Color get _cardColor =>
      _isDarkMode ? Colors.black.withOpacity(0.28) : Colors.white.withOpacity(0.9);
  Color get _buttonColor =>
      _isDarkMode ? const Color(0xFF6A0DAD) : const Color(0xFF7B2CBF);

  @override
  void initState() {
    super.initState();
    _languageCode = widget.languageCode; // inisialisasi bahasa lokal
    _loadHistory();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    });
  }

  Future<void> _saveThemePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();
  void _closeDrawer() => Navigator.of(context).pop();

  Future<void> _loadHistory() async {
    final loadedHistory = await HistoryService.loadHistory();
    setState(() {
      _historyList
        ..clear()
        ..addAll(loadedHistory);
    });
  }

  void _updateLanguageCode(String newCode) {
    setState(() {
      _languageCode = newCode;
    });
    widget.onLanguageChanged(newCode);
  }

  @override
  void dispose() {
    _idRespondentController.dispose();
    _nameController.dispose();
    _panjangLenganController.dispose();
    _lilaController.dispose();
    super.dispose();
  }

  Future<void> _hitungEstimasi() async {
    if (_formKey.currentState!.validate()) {
      final panjangLengan =
          double.parse(_panjangLenganController.text.replaceAll(',', '.'));
      final lila = double.parse(_lilaController.text.replaceAll(',', '.'));

      double tinggiBadan;
      double beratBadan;
      double beratBadanAlternatif1 = (4 * lila) - 50;
      double beratBadanAlternatif2;

      if (_selectedGender == 'L') {
        tinggiBadan = 97.252 + (2.645 * panjangLengan);
        beratBadan = -93.2 + (3.29 * lila) + (0.43 * tinggiBadan);
        beratBadanAlternatif2 = (2.592 * lila) - 12.902;
      } else {
        tinggiBadan = 68.777 + (3.536 * panjangLengan);
        beratBadan = -64.6 + (2.15 * lila) + (0.54 * tinggiBadan);
        beratBadanAlternatif2 = (2.001 * lila) - 1.223;
      }

      final newHistoryEntry = CalculationHistory(
        IDRespondent: _idRespondentController.text.trim(),
        name: _nameController.text.trim(),
        gender: _selectedGender == 'L' ? 'Laki-laki' : 'Perempuan',
        panjangLengan: panjangLengan,
        lila: lila,
        tinggiBadan: tinggiBadan,
        beratBadan: beratBadan,
        beratBadanAlternatif1: beratBadanAlternatif1,
        beratBadanAlternatif2: beratBadanAlternatif2,
        formulaType: FormulaType.mainFormula,
        timestamp: DateTime.now(),
      );

      setState(() {
        _hasilTinggiBadan = tinggiBadan;
        _hasilBeratBadan = beratBadan;
        _hasilBeratBadanAlternatif1 = beratBadanAlternatif1;
        _hasilBeratBadanAlternatif2 = beratBadanAlternatif2;
        _historyList.insert(0, newHistoryEntry);
      });

      await HistoryService.saveHistory(_historyList);
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
      _hasilBeratBadanAlternatif1 = null;
      _hasilBeratBadanAlternatif2 = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      onDrawerChanged: (isOpened) {
        setState(() {
          _isDrawerOpen = isOpened;
        });
      },
      appBar: AppBar(
        backgroundColor: _appBarColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.menu, color: _iconColor, size: 28),
          onPressed: () {
            if (_isDrawerOpen) {
              _closeDrawer();
            } else {
              _openDrawer();
            }
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _isDarkMode
                  ? [_bgColor1, _bgColor2]
                  : [_lightBgColor1, _lightBgColor2],
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset('assets/images/D-Estima1.png', height: 56),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _isDarkMode
                    ? [_bgColor1, _bgColor2, _bgColor3]
                    : [_lightBgColor1, _lightBgColor2],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
          if (_isDarkMode) ...[
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
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: _cardColor,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(_isDarkMode ? 0.38 : 0.06),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(color: _borderColor),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _languageCode == 'en' ? "CALCULATOR" : "KALKULATOR",
                            style: TextStyle(
                              color: _textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(color: _dividerColor),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: _idRespondentController,
                            label: _languageCode == 'en'
                                ? "Respondent ID"
                                : "ID Responden",
                            hint: _languageCode == 'en'
                                ? "Enter Respondent ID "
                                : "Masukkan ID Responden",
                             isNumber: false,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _nameController,
                            label: _languageCode == 'en'
                                ? "Name"
                                : "Nama",
                            hint: _languageCode == 'en'
                                ? "Enter Name"
                                : "Masukkan Nama",
                            isNumber: false,
                          ),
                          const SizedBox(height: 12),
                          _buildDropdownGender(),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _panjangLenganController,
                            label: _languageCode == 'en'
                                ? "Arm Length (ULNA)"
                                : "Panjang Lengan (ULNA)",
                            hint: _languageCode == 'en'
                                ? "e.g. 18 or 19.5"
                                : "contoh: 18 atau 19.5",
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _lilaController,
                            label: _languageCode == 'en'
                                ? "Mid-Upper Arm Circumference (MUAC)"
                                : "Lingkar Lengan Atas (LILA)",
                            hint: _languageCode == 'en'
                                ? "e.g. 18 or 19.5"
                                : "contoh: 18 atau 19.5",
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              _buildPrimaryButton(
                                  _languageCode == 'en' ? "Calculate" : "Hitung",
                                  _hitungEstimasi),
                              const SizedBox(width: 12),
                              if (_panjangLenganController.text.isNotEmpty ||
                                  _lilaController.text.isNotEmpty ||
                                  _hasilTinggiBadan != null)
                                _buildSecondaryButton(
                                    _languageCode == 'en' ? "Reset" : "Reset",
                                    _resetForm),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (_hasilTinggiBadan != null && _hasilBeratBadan != null)
                    _buildResultBox(),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: _isDarkMode ? const Color(0xFF0B0014) : Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 40),
          SizedBox(
            height: kToolbarHeight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                icon: Transform.rotate(
                  angle: 90 * 3.1416 / 180,
                  child: Icon(Icons.menu, color: _iconColor, size: 28),
                ),
                onPressed: _closeDrawer,
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildMenuItem(context, _languageCode == 'en' ? "Calculator" : "Kalkulator",
              Icons.calculate, _closeDrawer),
          Divider(color: _dividerColor, thickness: 0.5),
          _buildMenuItem(context, _languageCode == 'en' ? "History" : "Riwayat",
              Icons.history, () {
            _closeDrawer();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HistoryScreen(
                  historyList: _historyList,
                  isDarkMode: _isDarkMode,
                  languageCode: _languageCode,
                  onLanguageChanged: _updateLanguageCode,
                ),
              ),
            );
          }),
          Divider(color: _dividerColor, thickness: 0.5),
          _buildMenuItem(context, _languageCode == 'en' ? "Settings" : "Pengaturan",
              Icons.settings, () {
            _closeDrawer();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SettingsScreen(
                  isDarkMode: _isDarkMode,
                  onThemeChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                    _saveThemePreference(value);
                  },
                  languageCode: _languageCode,
                  onLanguageChanged: _updateLanguageCode,
                ),
              ),
            );
          }),
          Divider(color: _dividerColor, thickness: 0.5),
          _buildMenuItem(context, _languageCode == 'en' ? "About App" : "Tentang Aplikasi",
              Icons.info, () {
            _closeDrawer();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AboutScreen(
                  isDarkMode: _isDarkMode,
                  languageCode: _languageCode,
                  onLanguageChanged: _updateLanguageCode,
                ),
              ),
            );
          }),
          Divider(color: _dividerColor, thickness: 0.5),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: _iconColor),
      title: Text(title, style: TextStyle(color: _textColor)),
      onTap: onTap,
    );
  }

  // Semua getter teks untuk dropdown dan validator pakai _languageCode

  String getGenderLabel() {
    switch (_languageCode) {
      case 'en':
        return 'Select Gender';
      case 'id':
      default:
        return 'Pilih Jenis Kelamin';
    }
  }

  String getHintGender() {
    switch (_languageCode) {
      case 'en':
        return 'Male / Female';
      case 'id':
      default:
        return 'Pria / Wanita';
    }
  }

  String getMaleText() {
    switch (_languageCode) {
      case 'en':
        return 'Male';
      case 'id':
      default:
        return 'Pria';
    }
  }

  String getFemaleText() {
    switch (_languageCode) {
      case 'en':
        return 'Female';
      case 'id':
      default:
        return 'Wanita';
    }
  }

  String getValidatorMessage() {
    switch (_languageCode) {
      case 'en':
        return 'Gender must be selected';
      case 'id':
      default:
        return 'Jenis kelamin harus diisi';
    }
  }

  Widget _buildDropdownGender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getGenderLabel(),
          style: TextStyle(
            color: _textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          dropdownColor: _isDarkMode ? const Color(0xFF1E0A2A) : Colors.white,
          icon: Icon(Icons.arrow_drop_down, color: _textColor),
          decoration: _inputDecoration(),
          hint: Text(
            getHintGender(),
            style: TextStyle(
              color: _subTextColor,
              fontSize: 16,
            ),
          ),
          items: [
            DropdownMenuItem(
              value: 'L',
              child: Text(getMaleText()),
            ),
            DropdownMenuItem(
              value: 'P',
              child: Text(getFemaleText()),
            ),
          ],
          style: TextStyle(
            color: _textColor,
            fontSize: 16,
          ),
          onChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
          },
          validator: (value) => value == null ? getValidatorMessage() : null,
        ),
      ],
    );
  }

  String getRequiredFieldMessage(String label) {
    switch (_languageCode) {
      case 'en':
        return '$label is required';
      case 'id':
      default:
        return '$label harus diisi';
    }
  }

  String getInvalidNumberMessage() {
    switch (_languageCode) {
      case 'en':
        return 'Please enter a valid number';
      case 'id':
      default:
        return 'Masukkan angka yang valid';
    }
  }

  Widget _buildTextField({
      required TextEditingController controller,
      required String label,
      required String hint,
      bool isNumber = true, // <-- Default true untuk field angka
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: _textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            style: TextStyle(color: _textColor),
            controller: controller,
            decoration: _inputDecoration().copyWith(
              hintText: hint,
              hintStyle: TextStyle(color: _subTextColor),
            ),
            keyboardType: isNumber
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return getRequiredFieldMessage(label);
              }
              if (isNumber) { // <-- Hanya validasi angka jika isNumber true
                final number = double.tryParse(value.replaceAll(',', '.'));
                if (number == null) {
                  return getInvalidNumberMessage();
                }
              }
              return null;
            },
          ),
        ],
      );
}

  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      filled: true,
      fillColor: Colors.transparent,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: _borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: _textColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }

  Widget _buildPrimaryButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _buttonColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 2,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: _textColor,
        side: BorderSide(color: _borderColor, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 0,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: _textColor,
        ),
      ),
    );
  }

Widget _buildResultBox() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _cardColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _borderColor),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _languageCode == 'en' ? "ESTIMATION RESULT" : "HASIL ESTIMASI",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _textColor,
          ),
        ),
        const Divider(),
        const SizedBox(height: 12),
        // ID Responden
        _buildResultRow(
          _languageCode == 'en' ? "Respondent ID" : "ID Responden",
          _idRespondentController.text,
        ),
        const SizedBox(height: 8),
        // Nama
        _buildResultRow(
          _languageCode == 'en' ? "Name" : "Nama",
          _nameController.text,
        ),
        const SizedBox(height: 8),
        // Jenis Kelamin (ditambahkan)
        _buildResultRow(
          _languageCode == 'en' ? "Gender" : "Jenis Kelamin",
          _selectedGender == 'L' 
              ? (_languageCode == 'en' ? "Male" : "Laki-laki")
              : (_languageCode == 'en' ? "Female" : "Perempuan"),
        ),
        const SizedBox(height: 8),
        _buildResultRow(
          _languageCode == 'en' ? "Estimated Height" : "Perkiraan Tinggi Badan",
          "${_hasilTinggiBadan!.toStringAsFixed(2)} cm",
        ),
        const SizedBox(height: 8),
        _buildResultRow(
          _languageCode == 'en' ? "Estimated Weight" : "Perkiraan Berat Badan",
          "${_hasilBeratBadan!.toStringAsFixed(2)} kg",
        ),
        const SizedBox(height: 8),
        _buildResultRow(
          _languageCode == 'en' ? "Weight (Cattermole)" : "Berat Badan (Cattermole)",
          "${_hasilBeratBadanAlternatif1!.toStringAsFixed(2)} kg",
          isAlternate: true,
        ),
        const SizedBox(height: 8),
        _buildResultRow(
          _languageCode == 'en' ? "Weight (Gibson)" : "Berat Badan (Gibson)",
          "${_hasilBeratBadanAlternatif2!.toStringAsFixed(2)} kg",
          isAlternate: true,
        ),
      ],
    ),
  );
}

  Widget _buildResultRow(String label, String value, {bool isAlternate = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$label :",
          style: TextStyle(
            color: isAlternate ? Colors.blueGrey : _subTextColor,
            fontSize: 16,
            fontStyle: isAlternate ? FontStyle.italic : FontStyle.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isAlternate ? Colors.blueAccent : _textColor,
            fontSize: 16,
            fontWeight: isAlternate ? FontWeight.normal : FontWeight.bold,
          ),
        ),
      ],
    );
  }
}