import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculation_history.dart';
import 'about_screen.dart';
import 'main_screen.dart';
import '../models/history_service.dart';
import '../services/excel_exporter.dart'; // Impor service excel
import 'settings_screen.dart';

class HistoryScreen extends StatefulWidget {
  final List<CalculationHistory>? historyList;
  final bool isDarkMode;
  final String languageCode;
  final void Function(String) onLanguageChanged;

  const HistoryScreen({
    super.key,
    this.historyList,
    this.isDarkMode = false,
    required this.languageCode,
    required this.onLanguageChanged,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late List<CalculationHistory> _localHistory;
  late bool _isDarkMode;

  static const Color _bgColor1 = Color(0xFF12093E);
  static const Color _bgColor2 = Color(0xFF140A42);
  static const Color _bgColor3 = Color(0xFF150A43);
  static const Color _lightBgColor1 = Color(0xFFEDE7F6);
  static const Color _lightBgColor2 = Color(0xFFF3E5F5);

  @override
  void initState() {
    super.initState();
    _localHistory = [];
    _isDarkMode = widget.isDarkMode;
    _loadHistory();
  }

  Future<void> _saveThemePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  Future<void> _loadHistory() async {
    if (widget.historyList != null && widget.historyList!.isNotEmpty) {
      _localHistory = List.from(widget.historyList!);
    } else {
      _localHistory = await HistoryService.loadHistory();
    }
    setState(() {});
  }

  void _deleteHistoryItem(int index) async {
    setState(() {
      _localHistory.removeAt(index);
    });
    await HistoryService.saveHistory(_localHistory);
  }

  Future<void> _showDeleteConfirmationDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _isDarkMode ? const Color(0xFF1E0A2A) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text(
            widget.languageCode == 'id'
                ? 'Konfirmasi Hapus'
                : 'Delete Confirmation',
            style: TextStyle(
              color: _isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            widget.languageCode == 'id'
                ? 'Apakah Anda yakin ingin menghapus riwayat ini?'
                : 'Are you sure you want to delete this history?',
            style: TextStyle(
              color: _isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                widget.languageCode == 'id' ? 'Tidak' : 'Cancel',
                style: TextStyle(
                    color: _isDarkMode ? Colors.white70 : Colors.black54),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                widget.languageCode == 'id' ? 'Ya, Hapus' : 'Yes, Delete',
                style: const TextStyle(color: Colors.redAccent),
              ),
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

  String _getGenderLabel(String genderCode) {
    final code = genderCode.trim().toLowerCase();
    if (widget.languageCode == 'id') {
      if (code == 'male' || code == 'laki-laki') return 'Laki-laki';
      if (code == 'female' || code == 'perempuan') return 'Perempuan';
    } else {
      if (code == 'male' || code == 'laki-laki') return 'Male';
      if (code == 'female' || code == 'perempuan') return 'Female';
    }
    return genderCode;
  }

  Color get _appBarColor =>
      _isDarkMode ? _bgColor1.withOpacity(0.9) : _lightBgColor1.withOpacity(0.9);

  Color get _textColor => _isDarkMode ? Colors.white : Colors.black;
  Color get _iconColor => _isDarkMode ? Colors.white : Colors.black;
  Color get _textSecondaryColor =>
      _isDarkMode ? Colors.white70 : Colors.black54;
  Color get _dividerColor => _isDarkMode ? Colors.white54 : Colors.black26;
  Color get _cardColor =>
      _isDarkMode ? Colors.black.withOpacity(0.28) : Colors.white.withOpacity(0.9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode
      ? _bgColor1 // atau warna awal gradient
      : _lightBgColor1,
      appBar: AppBar(
        backgroundColor: _appBarColor,
        elevation: 1,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: _iconColor,
          size: 28,
        ),
        title: Text(
          widget.languageCode == 'id'
              ? 'Riwayat Perhitungan'
              : 'Calculation History',
          style: TextStyle(
            color: _textColor,
            fontWeight: FontWeight.w500,
          ),
        ),

         actions: [
          IconButton(
            icon: Icon(Icons.file_download_outlined, color: _iconColor),
            tooltip: widget.languageCode == 'id' ? 'Ekspor ke Excel' : 'Export to Excel',
            onPressed: _localHistory.isEmpty
                ? null // Nonaktifkan tombol jika riwayat kosong
                : () {
                    ExcelExporter.exportHistoryToExcel(
                      context: context,
                      historyList: _localHistory,
                      languageCode: widget.languageCode,
                    );
                  },
          ),
        ],

        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: _isDarkMode
                ? LinearGradient(
                    colors: [_bgColor1, _bgColor2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [_lightBgColor1, _lightBgColor2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          ),
        ),
      ),
      drawer: _buildDrawer(context),
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
          SafeArea(
            child: _localHistory.isEmpty
                ? Center(
                    child: Text(
                      widget.languageCode == 'id'
                          ? 'Belum ada riwayat perhitungan.'
                          : 'No calculation history yet.',
                      style:
                          TextStyle(fontSize: 18, color: _textSecondaryColor),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _localHistory.length,
                    itemBuilder: (context, index) {
                      final item = _localHistory[index];
                      return Card(
                        color: _cardColor,
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: _isDarkMode
                                ? Colors.white12
                                : Colors.black12,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display Respondent Information
                              if (item.IDRespondent.isNotEmpty)
                              Text(
                                '${widget.languageCode == 'id' ? 'ID Responden' : 'Respondent ID'}: ${item.IDRespondent}',
                                style: TextStyle(
                                  color: _textColor,
                                  fontSize: 16,
                                ),
                              ),
                              if (item.name.isNotEmpty)
                              Text(
                                '${widget.languageCode == 'id' ? 'Nama' : 'Name'}: ${item.name}',
                                style: TextStyle(
                                  color: _textColor,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Display Gender
                              Text(
                                '${widget.languageCode == 'id' ? 'Jenis Kelamin' : 'Gender'}: ${_getGenderLabel(item.gender)}',
                                style: TextStyle(
                                  
                                  color: _textColor,
                                  fontSize: 16,
                                ),
                              ),
                              Divider(color: _dividerColor, height: 16),

                              // Display Results Header
                              Text(
                                widget.languageCode == 'id'
                                    ? 'Hasil Estimasi'
                                    : 'Estimation Result',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _textColor,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Display Height
                              Text(
                                '${widget.languageCode == 'id' ? 'Tinggi Badan' : 'Height'}: ${item.tinggiBadan.toStringAsFixed(2)} cm',
                                style: TextStyle(
                                  color: _textColor,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Display Weight (Crandall)
                              Text(
                                '${widget.languageCode == 'id' ? 'Berat Badan (Crandall)' : 'Weight (Crandall)'}: ${item.beratBadan.toStringAsFixed(2)} kg',
                                style: TextStyle(
                                  color: _textColor,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Display Weight (Cattermole)
                              Text(
                                '${widget.languageCode == 'id' ? 'Berat Badan (Cattermole)' : 'Weight (Cattermole)'}: ${item.beratBadanAlternatif1.toStringAsFixed(2)} kg',
                                style: TextStyle(
                                  color: _textColor,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Display Weight (Gibson)
                              Text(
                                '${widget.languageCode == 'id' ? 'Berat Badan (Gibson)' : 'Weight (Gibson)'}: ${item.beratBadanAlternatif2.toStringAsFixed(2)} kg',
                                style: TextStyle(
                                  color: _textColor,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),

                              Divider(color: _dividerColor, height: 16),

                              // Display Input Values
                              Text(
                                '${widget.languageCode == 'id' ? 'Input' : 'Input'} -> PL: ${item.panjangLengan} cm, LILA: ${item.lila} cm',
                                style: TextStyle(
                                    color: _textSecondaryColor, fontSize: 12),
                              ),
                              const SizedBox(height: 8),

                              // Display Timestamp and Delete Button
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${item.timestamp.day}/${item.timestamp.month}/${item.timestamp.year} - ${item.timestamp.hour}:${item.timestamp.minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                        color: _textSecondaryColor,
                                        fontSize: 12),
                                  ),
                                  InkWell(
                                    onTap: () =>
                                        _showDeleteConfirmationDialog(index),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Icon(Icons.delete_outline,
                                          color: Colors.redAccent, size: 20),
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
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildMenuItem(
            context,
            widget.languageCode == 'id' ? "Kalkulator" : "Calculator",
            Icons.calculate,
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => MainScreen(
                    languageCode: widget.languageCode,
                    onLanguageChanged: widget.onLanguageChanged,
                  ),
                ),
              );
            },
          ),
          Divider(color: _dividerColor, thickness: 0.5),
          _buildMenuItem(
            context,
            widget.languageCode == 'id' ? "Riwayat" : "History",
            Icons.history,
            () {
              Navigator.pop(context);
            },
          ),
          Divider(color: _dividerColor, thickness: 0.5),
          _buildMenuItem(
            context,
            widget.languageCode == 'id' ? "Pengaturan" : "Settings",
            Icons.settings,
            () {
              Navigator.pop(context);
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
                    languageCode: widget.languageCode,
                    onLanguageChanged: (lang) {
                      widget.onLanguageChanged(lang);
                      setState(() {});
                    },
                  ),
                ),
              );
            },
          ),
          Divider(color: _dividerColor, thickness: 0.5),
          _buildMenuItem(
            context,
            widget.languageCode == 'id' ? "Tentang Aplikasi" : "About App",
            Icons.info,
            () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AboutScreen(
                          isDarkMode: _isDarkMode,
                          languageCode: widget.languageCode,
                          onLanguageChanged: widget.onLanguageChanged,
                        )),
              );
            },
          ),
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
}