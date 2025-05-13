import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/session.dart';
import '../models/app_state.dart';
import '../services/session_service.dart';
import 'package:intl/intl.dart';

class SessionDetailView extends StatefulWidget {
  final Session session;
  final VoidCallback onSessionUpdated;

  const SessionDetailView({
    Key? key,
    required this.session,
    required this.onSessionUpdated,
  }) : super(key: key);

  @override
  State<SessionDetailView> createState() => _SessionDetailViewState();
}

class _SessionDetailViewState extends State<SessionDetailView> {
  late TextEditingController _descriptionController;
  final SessionService _sessionService = SessionService();

  // New properties to hold the editable dates and times
  late DateTime _startDate;
  late TimeOfDay _startTime;
  late DateTime _endDate;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.session.description);

    // Initialize with current session values
    _startDate = widget.session.startTime;
    _startTime = TimeOfDay.fromDateTime(widget.session.startTime);

    if (widget.session.endTime != null) {
      _endDate = widget.session.endTime!;
      _endTime = TimeOfDay.fromDateTime(widget.session.endTime!);
    } else {
      _endDate = DateTime.now();
      _endTime = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime dateTime, String format) {
    return DateFormat(format).format(dateTime);
  }

  String _formatDuration(double hours) {
    final totalMinutes = (hours * 60).round();
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    return '$h hour${h != 1 ? 's' : ''} $m minute${m != 1 ? 's' : ''}';
  }

  Future<void> _updateSession() async {
    try {
      // Combine date and time for start and end
      final startDateTime = DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day,
        _startTime.hour,
        _startTime.minute,
      );

      // Combine date and time for end
      final endDateTime = DateTime(
        _endDate.year,
        _endDate.month,
        _endDate.day,
        _endTime.hour,
        _endTime.minute,
      );

      // Validate end time is after start time
      if (endDateTime.isBefore(startDateTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End time must be after start time')),
        );
        return;
      }

      final updatedSession = Session(
        id: widget.session.id,
        startTime: startDateTime,
        endTime: endDateTime,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );

      await _sessionService.updateSession(updatedSession);
      widget.onSessionUpdated();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session updated successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating session: $e')),
      );
    }
  }

  // Add method to handle session deletion
  Future<void> _deleteSession() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Session'),
        content: const Text(
          'Are you sure you want to delete this session? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _sessionService.deleteSession(widget.session.id);
        widget.onSessionUpdated();

        // Show success message
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session deleted successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting session: $e')),
        );
      }
    }
  }

  // Methods to handle date/time selection
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (picked != null && picked != _endTime) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final dateFormat = appState.dateFormat.replaceAll('YYYY', 'yyyy');
    final formattedDate = _formatDateTime(widget.session.startTime, dateFormat);

    final duration = widget.session.durationHours;
    final earnings = widget.session.calculateEarnings(appState.hourlyRate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Session'),
        actions: [
          // Add delete button in app bar
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteSession,
            tooltip: 'Delete Session',
            color: Colors.red,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session Date - Now Editable
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Time',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                            ),
                            onPressed: () => _selectStartDate(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.access_time),
                            label: Text(_startTime.format(context)),
                            onPressed: () => _selectStartTime(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // End Time - Editable
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'End Time',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                            ),
                            onPressed: () => _selectEndDate(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.access_time),
                            label: Text(_endTime.format(context)),
                            onPressed: () => _selectEndTime(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Current duration info
            Card(
              child: ListTile(
                leading: const Icon(Icons.timer),
                title: const Text('Original Duration'),
                subtitle: Text(_formatDuration(duration)),
                trailing: Text('${duration.toStringAsFixed(2)} hours'),
              ),
            ),
            const SizedBox(height: 8),

            // Earnings
            Card(
              child: ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Original Earnings'),
                subtitle: Text('\$${earnings.toStringAsFixed(2)}'),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Add a description...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
