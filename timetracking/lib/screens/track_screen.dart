import 'package:flutter/material.dart';
import 'dart:async';
import '../models/session.dart';
import '../services/session_service.dart';
import '../widgets/session_detail_view.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({Key? key}) : super(key: key);

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  final SessionService _sessionService = SessionService();
  Session? _currentSession;
  Timer? _timer;
  String _elapsedTime = '00:00:00';
  List<Session> _todaySessions = [];

  @override
  void initState() {
    super.initState();
    _loadTodaySessions();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadTodaySessions() async {
    final sessions = await _sessionService.getSessionsForDay(DateTime.now());
    setState(() {
      _todaySessions = sessions;
    });

    // Check if there's an active session
    final activeSession = await _sessionService.getActiveSession();
    if (activeSession != null) {
      setState(() {
        _currentSession = activeSession;
      });
      _startTimer();
    }
  }

  void _startSession() async {
    if (_currentSession != null) return;

    final session = await _sessionService.startSession();
    setState(() {
      _currentSession = session;
    });
    _startTimer();
  }

  void _stopSession() async {
    if (_currentSession == null) return;

    final completedSession = await _sessionService.endSession(
      _currentSession!.id,
    );
    setState(() {
      _currentSession = null;
      _todaySessions.add(completedSession);
    });
    _timer?.cancel();
    _timer = null;
    setState(() {
      _elapsedTime = '00:00:00';
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSession == null) {
        timer.cancel();
        return;
      }

      final now = DateTime.now();
      final difference = now.difference(_currentSession!.startTime);

      final hours = difference.inHours.toString().padLeft(2, '0');
      final minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');

      setState(() {
        _elapsedTime = '$hours:$minutes:$seconds';
      });
    });
  }

  void _addManualSession() async {
    final TextEditingController descriptionController = TextEditingController();
    DateTime? selectedStartDate;
    DateTime? selectedEndDate;
    TimeOfDay? selectedStartTime;
    TimeOfDay? selectedEndTime;

    // Set initial values to today
    selectedStartDate = DateTime.now();
    selectedEndDate = DateTime.now();
    selectedStartTime = TimeOfDay.now();

    // Calculate a default end time (1 hour after start)
    final now = DateTime.now();
    final defaultEndTime = TimeOfDay.fromDateTime(
      now.add(const Duration(hours: 1)),
    );
    selectedEndTime = defaultEndTime;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Manual Session'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'What did you work on?',
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  const Text('Start Time:'),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          label: Text(
                            selectedStartDate == null
                                ? 'Select Date'
                                : '${selectedStartDate!.day}/${selectedStartDate!.month}/${selectedStartDate!.year}',
                          ),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: selectedStartDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setState(() {
                                selectedStartDate = date;
                              });
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          icon: const Icon(Icons.access_time),
                          label: Text(
                            selectedStartTime == null
                                ? 'Select Time'
                                : selectedStartTime!.format(context),
                          ),
                          onPressed: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: selectedStartTime ?? TimeOfDay.now(),
                            );
                            if (time != null) {
                              setState(() {
                                selectedStartTime = time;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('End Time:'),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          label: Text(
                            selectedEndDate == null
                                ? 'Select Date'
                                : '${selectedEndDate!.day}/${selectedEndDate!.month}/${selectedEndDate!.year}',
                          ),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: selectedEndDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setState(() {
                                selectedEndDate = date;
                              });
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          icon: const Icon(Icons.access_time),
                          label: Text(
                            selectedEndTime == null
                                ? 'Select Time'
                                : selectedEndTime!.format(context),
                          ),
                          onPressed: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: selectedEndTime ?? TimeOfDay.now(),
                            );
                            if (time != null) {
                              setState(() {
                                selectedEndTime = time;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Add Session'),
              ),
            ],
          );
        },
      ),
    );

    if (confirmed == true &&
        selectedStartDate != null &&
        selectedEndDate != null &&
        selectedStartTime != null &&
        selectedEndTime != null) {
      // Create DateTime objects from selected date and time
      final startDateTime = DateTime(
        selectedStartDate!.year,
        selectedStartDate!.month,
        selectedStartDate!.day,
        selectedStartTime!.hour,
        selectedStartTime!.minute,
      );

      final endDateTime = DateTime(
        selectedEndDate!.year,
        selectedEndDate!.month,
        selectedEndDate!.day,
        selectedEndTime!.hour,
        selectedEndTime!.minute,
      );

      if (endDateTime.isBefore(startDateTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End time must be after start time')),
        );
        return;
      }

      // Add the manual session
      try {
        final session = await _sessionService.addManualSession(
          startTime: startDateTime,
          endTime: endDateTime,
          description: descriptionController.text.trim().isEmpty
              ? null
              : descriptionController.text.trim(),
        );

        // If the session is for today, add it to the list
        final today = DateTime.now();
        final sessionDay = DateTime(
          session.startTime.year,
          session.startTime.month,
          session.startTime.day,
        );
        final compareToday = DateTime(
          today.year,
          today.month,
          today.day,
        );

        if (sessionDay.isAtSameMomentAs(compareToday)) {
          setState(() {
            _todaySessions.add(session);
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session added successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding session: $e')),
        );
      }
    }
  }

  // Add method to delete a session
  Future<void> _deleteSession(Session session) async {
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
        await _sessionService.deleteSession(session.id);
        // Refresh the list
        _loadTodaySessions();

        // Notify other screens about this change (like reports screen)
        // This will trigger a rebuild of ReportsScreen if it's visible
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting session: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Time Tracking')),
      body: Column(
        children: [
          // Current session tracker
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Current Session',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                Text(
                  _elapsedTime,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _currentSession == null ? _startSession : null,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _currentSession != null ? _stopSession : null,
                      icon: const Icon(Icons.stop),
                      label: const Text('Stop'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Today's sessions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Sessions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton.icon(
                  onPressed: _addManualSession,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Manual'),
                ),
              ],
            ),
          ),

          Expanded(
            child: _todaySessions.isEmpty
                ? const Center(child: Text('No sessions recorded today'))
                : ListView.builder(
                    itemCount: _todaySessions.length,
                    itemBuilder: (context, index) {
                      final session = _todaySessions[index];
                      final startTime = TimeOfDay.fromDateTime(
                        session.startTime,
                      ).format(context);
                      final endTime = session.endTime != null
                          ? TimeOfDay.fromDateTime(
                              session.endTime!,
                            ).format(context)
                          : 'Ongoing';
                      final duration = session.durationHours.toStringAsFixed(
                        2,
                      );

                      return InkWell(
                        onTap: () {
                          // Only show details for completed sessions
                          if (session.endTime != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SessionDetailView(
                                  session: session,
                                  onSessionUpdated: _loadTodaySessions,
                                ),
                              ),
                            );
                          }
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 4.0,
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.timer),
                            title: Text('$startTime - $endTime'),
                            subtitle: Text(
                              session.description ?? 'No description',
                            ),
                            trailing: session.endTime == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('$duration hours'),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 2.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: const Text(
                                          'Active',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('$duration hours'),
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 18),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SessionDetailView(
                                                session: session,
                                                onSessionUpdated:
                                                    _loadTodaySessions,
                                              ),
                                            ),
                                          );
                                        },
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        iconSize: 18,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            size: 18, color: Colors.red),
                                        onPressed: () =>
                                            _deleteSession(session),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        iconSize: 18,
                                      ),
                                    ],
                                  ),
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
}
