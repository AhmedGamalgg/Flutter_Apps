import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'storage_service.dart';

class BackupService {
  final StorageService _storage = StorageService();

  // Create a backup of all app data
  Future<String> createBackup() async {
    try {
      // Get all keys from shared preferences
      final allPrefs = await _getAllPreferences();

      // Create a JSON string from the preferences
      final jsonString = jsonEncode(allPrefs);

      // Get the documents directory
      final directory = await getApplicationDocumentsDirectory();
      final now = DateTime.now();
      final formattedDate =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}';
      final fileName = 'timetracking_backup_$formattedDate.json';
      final filePath = '${directory.path}/$fileName';

      // Write the backup file
      final file = File(filePath);
      await file.writeAsString(jsonString);

      return filePath;
    } catch (e) {
      throw Exception('Failed to create backup: $e');
    }
  }

  // Restore from a backup file
  Future<void> restoreFromBackup() async {
    try {
      // Let the user pick a backup file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        dialogTitle: 'Select a backup file to restore',
      );

      if (result == null || result.files.isEmpty) {
        throw Exception('No backup file selected');
      }

      final filePath = result.files.single.path;
      if (filePath == null) {
        throw Exception('Invalid file path');
      }

      // Read the backup file
      final file = File(filePath);
      final jsonString = await file.readAsString();

      // Parse the JSON
      final Map<String, dynamic> backupData = jsonDecode(jsonString);

      // Clear current preferences
      await _storage.clear();

      // Restore all preferences
      for (final entry in backupData.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is String) {
          await _storage.setString(key, value);
        } else if (value is bool) {
          await _storage.setBool(key, value);
        } else if (value is int) {
          await _storage.setInt(key, value);
        } else if (value is double) {
          await _storage.setDouble(key, value);
        } else if (value is List) {
          await _storage.setStringList(key, value.cast<String>());
        }
      }
    } catch (e) {
      throw Exception('Failed to restore from backup: $e');
    }
  }

  // Helper to get all preferences
  Future<Map<String, dynamic>> _getAllPreferences() async {
    // This is a simplified approach - in a real app, you'd need
    // to enumerate all keys from SharedPreferences which is tricky
    // For this example, we'll just retrieve the known keys
    final result = <String, dynamic>{};

    // App settings
    final darkMode = await _storage.getBool('darkMode');
    if (darkMode != null) result['darkMode'] = darkMode;

    final hourlyRate = await _storage.getDouble('hourlyRate');
    if (hourlyRate != null) result['hourlyRate'] = hourlyRate;

    final dateFormat = await _storage.getString('dateFormat');
    if (dateFormat != null) result['dateFormat'] = dateFormat;

    final notifications = await _storage.getBool('notificationsEnabled');
    if (notifications != null) result['notificationsEnabled'] = notifications;

    // Sessions and active session
    final sessions = await _storage.getStringList('sessions');
    if (sessions != null) result['sessions'] = sessions;

    final activeSession = await _storage.getString('active_session');
    if (activeSession != null) result['active_session'] = activeSession;

    // Tasks
    final tasks = await _storage.getStringList('tasks');
    if (tasks != null) result['tasks'] = tasks;

    return result;
  }
}
