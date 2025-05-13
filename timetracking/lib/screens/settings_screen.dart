import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../services/backup_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final BackupService _backupService = BackupService();
  final TextEditingController _hourlyRateController = TextEditingController();
  bool _isBackupInProgress = false;
  bool _isRestoreInProgress = false;

  @override
  void initState() {
    super.initState();
    _hourlyRateController.text =
        Provider.of<AppState>(context, listen: false).hourlyRate.toString();
  }

  @override
  void dispose() {
    _hourlyRateController.dispose();
    super.dispose();
  }

  Future<void> _backupData() async {
    setState(() {
      _isBackupInProgress = true;
    });

    try {
      final path = await _backupService.createBackup();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Backup created at: $path')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Backup failed: $e')));
    } finally {
      setState(() {
        _isBackupInProgress = false;
      });
    }
  }

  Future<void> _restoreData() async {
    setState(() {
      _isRestoreInProgress = true;
    });

    try {
      await _backupService.restoreFromBackup();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data restored successfully')),
      );
      // Reload app state
      Provider.of<AppState>(context, listen: false).reloadSettings();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Restore failed: $e')));
    } finally {
      setState(() {
        _isRestoreInProgress = false;
      });
    }
  }

  void _updateHourlyRate() {
    if (_hourlyRateController.text.isNotEmpty) {
      final rate = double.tryParse(_hourlyRateController.text);
      if (rate != null && rate > 0) {
        Provider.of<AppState>(context, listen: false).setHourlyRate(rate);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Hourly rate updated')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Preferences section
          Text('Preferences', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),

          // Hourly rate
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hourly Rate',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _hourlyRateController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$ ',
                            hintText: 'Enter your hourly rate',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _updateHourlyRate,
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Date format
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date Format',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: appState.dateFormat,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'MM/DD/YYYY',
                        child: Text('MM/DD/YYYY'),
                      ),
                      DropdownMenuItem(
                        value: 'DD/MM/YYYY',
                        child: Text('DD/MM/YYYY'),
                      ),
                      DropdownMenuItem(
                        value: 'YYYY-MM-DD',
                        child: Text('YYYY-MM-DD'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        appState.setDateFormat(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Theme toggle
          Card(
            child: SwitchListTile(
              title: Text(
                'Dark Mode',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: const Text('Toggle between light and dark themes'),
              value: appState.darkMode,
              onChanged: (_) => appState.toggleDarkMode(),
            ),
          ),

          const SizedBox(height: 24),

          // Backup & Restore section
          Text(
            'Backup & Restore',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          // Backup
          Card(
            child: ListTile(
              title: Text(
                'Backup Data',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: const Text('Export app data for safekeeping'),
              trailing: _isBackupInProgress
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.backup),
              onTap: _isBackupInProgress ? null : _backupData,
            ),
          ),

          const SizedBox(height: 16),

          // Restore
          Card(
            child: ListTile(
              title: Text(
                'Restore Data',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: const Text('Recover from previous backups'),
              trailing: _isRestoreInProgress
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.restore),
              onTap: _isRestoreInProgress ? null : _restoreData,
            ),
          ),

          const SizedBox(height: 16),

          // About section
          Card(
            child: ListTile(
              title: Text(
                'About',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: const Text('Time Tracking App v1.0.0'),
              trailing: const Icon(Icons.info_outline),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Time Tracking',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2023 Time Tracking App',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
