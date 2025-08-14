import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calculation_history.dart';

class HistoryService {
  static const String _prefsKey = 'calculation_history';
  static const String _backupFileName = 'history_backup.json';

  /// Simpan semua histori (SharedPreferences + File backup)
  static Future<void> saveHistory(List<CalculationHistory> historyList) async {
    try {
      final jsonString = _convertToJson(historyList);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, jsonString);

      await _backupToFile(jsonString);
    } catch (e) {
      throw Exception('History save failed: $e');
    }
  }

  /// Ambil semua histori (dengan fallback dari file backup)
  static Future<List<CalculationHistory>> loadHistory() async {
    try {
      String? jsonString = await _loadFromSharedPrefs();

      if (jsonString == null || jsonString.isEmpty) {
        jsonString = await _restoreFromBackup();
      }

      return _parseJson(jsonString ?? '');
    } catch (e) {
      throw Exception('History load failed: $e');
    }
  }

  /// Hapus semua histori
  static Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefsKey);
      await _deleteBackup();
    } catch (e) {
      throw Exception('History clear failed: $e');
    }
  }

  // Helper methods -----------------------------------------------------------

  static String _convertToJson(List<CalculationHistory> historyList) {
    return jsonEncode(historyList.map((history) => history.toJson()).toList());
  }

  static Future<String?> _loadFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefsKey);
  }

  static Future<void> _backupToFile(String jsonString) async {
    try {
      final file = await _getBackupFile();
      await file.writeAsString(jsonString);
    } catch (e) {
      print('File backup failed: $e');
    }
  }

  static Future<String?> _restoreFromBackup() async {
    try {
      final file = await _getBackupFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        if (contents.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_prefsKey, contents);
          return contents;
        }
      }
      return null;
    } catch (e) {
      print('File restore failed: $e');
      return null;
    }
  }

  static Future<void> _deleteBackup() async {
    try {
      final file = await _getBackupFile();
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('File delete failed: $e');
    }
  }

  static Future<File> _getBackupFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_backupFileName');
  }

  /// Parsing JSON → List<CalculationHistory>
  static List<CalculationHistory> _parseJson(String jsonString) {
    if (jsonString.isEmpty) return [];

    final List<dynamic> decoded = jsonDecode(jsonString);

    return decoded.map((json) {
      try {
        // Backward compatibility: handle versi lama yang belum punya 'formulaType'
        if (json['formulaType'] == null) {
          return CalculationHistory(
            IDRespondent: json['IDRespondent'] ?? json['IDResponden'] ?? '',
            name: json['name'] ?? json['nama'] ?? '',
            gender: json['gender'] ?? '',
            panjangLengan: (json['panjangLengan'] ?? 0).toDouble(),
            lila: (json['lila'] ?? 0).toDouble(),
            tinggiBadan: (json['tinggiBadan'] ?? 0).toDouble(),
            beratBadan: (json['beratBadan'] ?? 0).toDouble(),
            beratBadanAlternatif1: (json['beratBadanAlternatif1'] ?? 0).toDouble(),
            beratBadanAlternatif2: (json['beratBadanAlternatif2'] ?? 0).toDouble(),
            formulaType: FormulaType.mainFormula,
            timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
          );
        }
        // Versi baru
        return CalculationHistory.fromJson(Map<String, dynamic>.from(json));
      } catch (e) {
        print('Error parsing history entry: $e');
        return null;
      }
    }).whereType<CalculationHistory>().toList();
  }

  // CRUD operations ----------------------------------------------------------

  static Future<void> addHistoryEntry(CalculationHistory entry) async {
    final currentHistory = await loadHistory();
    await saveHistory([entry, ...currentHistory]);
  }

  static Future<void> removeHistoryEntry(int index) async {
    final currentHistory = await loadHistory();
    if (index >= 0 && index < currentHistory.length) {
      currentHistory.removeAt(index);
      await saveHistory(currentHistory);
    }
  }

  static Future<void> updateHistoryEntry(int index, CalculationHistory newEntry) async {
    final currentHistory = await loadHistory();
    if (index >= 0 && index < currentHistory.length) {
      currentHistory[index] = newEntry;
      await saveHistory(currentHistory);
    }
  }

  static Future<CalculationHistory?> getMostRecent() async {
    final history = await loadHistory();
    return history.isNotEmpty ? history.first : null;
  }
}