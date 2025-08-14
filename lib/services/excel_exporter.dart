import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb; // Untuk mendeteksi platform web
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/calculation_history.dart';

// Import 'dart:html' hanya akan digunakan saat kompilasi untuk web
import 'dart:html' as html;

class ExcelExporter {
  static Future<void> exportHistoryToExcel({
    required BuildContext context,
    required List<CalculationHistory> historyList,
    required String languageCode,
  }) async {
    // 1. Membuat workbook dan sheet Excel
    var excel = Excel.createExcel();
    Sheet sheet = excel[languageCode == 'id' ? 'Riwayat Perhitungan' : 'Calculation History'];

    // 2. Menulis Header
    List<String> headers = [
      'ID Responden', 'Nama', 'Jenis Kelamin', 'Tinggi Badan (cm)',
      'Berat Badan (Crandall) (kg)', 'Berat Badan (Cattermole) (kg)', 'Berat Badan (Gibson) (kg)',
      'Input PL (cm)', 'Input LILA (cm)', 'Waktu Perhitungan'
    ];
    sheet.appendRow(headers);

    // 3. Menulis data riwayat
    for (var item in historyList) {
      List<dynamic> row = [
        item.IDRespondent,
        item.name,
        item.gender,
        item.tinggiBadan,
        item.beratBadan,
        item.beratBadanAlternatif1 ?? 0.0,
        item.beratBadanAlternatif2 ?? 0.0,
        item.panjangLengan,
        item.lila,
        '${item.timestamp.day}/${item.timestamp.month}/${item.timestamp.year} ${item.timestamp.hour}:${item.timestamp.minute.toString().padLeft(2, '0')}'
      ];
      sheet.appendRow(row);
    }
    
    // 4. Menyimpan file berdasarkan platform
    final fileBytes = excel.encode();
    if (fileBytes == null) return;

    if (kIsWeb) {
      // --- LOGIKA KHUSUS UNTUK WEB ---
      try {
        final blob = html.Blob([fileBytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "D-Estima_Riwayat.xlsx")
          ..click(); // Memicu unduhan di browser
        html.Url.revokeObjectUrl(url);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(languageCode == 'id' ? 'Unduhan dimulai...' : 'Download started...')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${languageCode == 'id' ? 'Gagal mengunduh file' : 'Failed to download file'}: $e')),
          );
        }
      }
    } else {
      // --- LOGIKA UNTUK MOBILE (ANDROID/IOS) ---
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(languageCode == 'id' ? 'Izin penyimpanan ditolak.' : 'Storage permission denied.')),
          );
        }
        return;
      }
      try {
        final directory = await getDownloadsDirectory();
        if (directory == null) throw Exception("Direktori Downloads tidak ditemukan.");
        
        final filePath = '${directory.path}/D-Estima_Riwayat_${DateTime.now().millisecondsSinceEpoch}.xlsx';
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${languageCode == 'id' ? 'Berhasil diekspor ke' : 'Successfully exported to'}: ${directory.path}'),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } catch (e) {
         if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${languageCode == 'id' ? 'Gagal mengekspor file' : 'Failed to export file'}: $e')),
          );
         }
      }
    }
  }
}
