import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class AppState extends ChangeNotifier {
  bool _darkMode = false;
  double _hourlyRate = 15.0;
  String _dateFormat = 'MM/DD/YYYY';

  bool get darkMode => _darkMode;
  double get hourlyRate => _hourlyRate;
  String get dateFormat => _dateFormat;

  AppState() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final storage = StorageService();
    _darkMode = await storage.getBool('darkMode') ?? false;
    _hourlyRate = await storage.getDouble('hourlyRate') ?? 15.0;
    _dateFormat = await storage.getString('dateFormat') ?? 'MM/DD/YYYY';
    notifyListeners();
  }

  // Method to reload settings after restoration from backup
  Future<void> reloadSettings() async {
    await _loadSettings();
  }

  void toggleDarkMode() {
    _darkMode = !_darkMode;
    StorageService().setBool('darkMode', _darkMode);
    notifyListeners();
  }

  void setHourlyRate(double rate) {
    _hourlyRate = rate;
    StorageService().setDouble('hourlyRate', rate);
    notifyListeners();
  }

  void setDateFormat(String format) {
    _dateFormat = format;
    StorageService().setString('dateFormat', format);
    notifyListeners();
  }
}
