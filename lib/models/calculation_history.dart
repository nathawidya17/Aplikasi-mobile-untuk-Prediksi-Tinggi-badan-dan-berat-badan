// File: lib/models/calculation_history.dart

class CalculationHistory {
  final String gender;
  final double panjangLengan;
  final double lila;
  final double tinggiBadan;
  final double beratBadan;
  final DateTime timestamp;

  CalculationHistory({
    required this.gender,
    required this.panjangLengan,
    required this.lila,
    required this.tinggiBadan,
    required this.beratBadan,
    required this.timestamp,
  });
}
