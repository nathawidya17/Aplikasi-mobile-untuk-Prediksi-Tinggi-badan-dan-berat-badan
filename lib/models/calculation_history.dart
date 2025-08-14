enum FormulaType {
  mainFormula,    // Rumus utama (regresi linier)
  simpleLila,     // (4 x LILA) - 50
  genderSpecific, // (2.592 x LILA - 12.902) atau (2.001 x LILA - 1.223)
}

class CalculationHistory {
  final String IDRespondent;
  final String name;
  final String gender;
  final double panjangLengan;
  final double lila;
  final double tinggiBadan;
  final double beratBadan;
  final double beratBadanAlternatif1;
  final double beratBadanAlternatif2;
  final FormulaType formulaType;
  final DateTime timestamp;

  CalculationHistory({
    required this.IDRespondent,
    required this.name,
    required this.gender,
    required this.panjangLengan,
    required this.lila,
    required this.tinggiBadan,
    required this.beratBadan,
    required this.beratBadanAlternatif1,
    required this.beratBadanAlternatif2,
    required this.formulaType,
    required this.timestamp,
  });

  /// Serialize to JSON (untuk simpan ke SharedPreferences / file)
  Map<String, dynamic> toJson() {
    return {
      'IDRespondent': IDRespondent,
      'name': name,
      'gender': gender,
      'panjangLengan': panjangLengan,
      'lila': lila,
      'tinggiBadan': tinggiBadan,
      'beratBadan': beratBadan,
      'beratBadanAlternatif1': beratBadanAlternatif1,
      'beratBadanAlternatif2': beratBadanAlternatif2,
      'formulaType': formulaType.index,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Deserialize dari JSON (mendukung format lama & baru)
  factory CalculationHistory.fromJson(Map<String, dynamic> json) {
    return CalculationHistory(
      IDRespondent: json['IDRespondent'] ??
          json['IDResponden'] ?? // format lama
          json['ID Responden'] ?? // format lama dengan spasi
          '',
      name: json['name'] ?? json['nama'] ?? '',
      gender: json['gender'] ?? '',
      panjangLengan: (json['panjangLengan'] as num?)?.toDouble() ?? 0,
      lila: (json['lila'] as num?)?.toDouble() ?? 0,
      tinggiBadan: (json['tinggiBadan'] as num?)?.toDouble() ?? 0,
      beratBadan: (json['beratBadan'] as num?)?.toDouble() ?? 0,
      beratBadanAlternatif1:
          (json['beratBadanAlternatif1'] as num?)?.toDouble() ?? 0,
      beratBadanAlternatif2:
          (json['beratBadanAlternatif2'] as num?)?.toDouble() ?? 0,
      formulaType: FormulaType.values[
          (json['formulaType'] is int) ? json['formulaType'] : 0],
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  /// Nama rumus yang digunakan
  String get formulaName {
    switch (formulaType) {
      case FormulaType.mainFormula:
        return "Rumus Utama";
      case FormulaType.simpleLila:
        return "4×LILA-50";
      case FormulaType.genderSpecific:
        return "Rumus Gender";
    }
  }

  /// Hasil berat badan sesuai rumus yang aktif
  String get activeWeightResult {
    switch (formulaType) {
      case FormulaType.mainFormula:
        return beratBadan.toStringAsFixed(2);
      case FormulaType.simpleLila:
        return beratBadanAlternatif1.toStringAsFixed(2);
      case FormulaType.genderSpecific:
        return beratBadanAlternatif2.toStringAsFixed(2);
    }
  }

  /// Format tanggal untuk ditampilkan
  String get formattedDate {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} '
        '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    return '''
ID Respondent: $IDRespondent
Nama: $name
Gender: $gender
Panjang Lengan: $panjangLengan cm
LILA: $lila cm
Tinggi Badan: $tinggiBadan cm
Berat Badan (Utama): $beratBadan kg
Berat Badan (4×LILA-50): $beratBadanAlternatif1 kg
Berat Badan (Rumus Gender): $beratBadanAlternatif2 kg
Rumus Aktif: $formulaName
Waktu: $formattedDate
''';
  }
}