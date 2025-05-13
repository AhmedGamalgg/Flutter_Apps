import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/app_state.dart';
import '../services/session_service.dart';
import '../services/report_service.dart';
import '../services/task_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  final SessionService _sessionService = SessionService();
  final ReportService _reportService = ReportService();
  final TaskService _taskService = TaskService();

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  double _dailyHours = 0.0;
  double _dailyEarnings = 0.0;
  int _completedTasks = 0;

  Map<DateTime, double> _hoursWorked = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This helps ensure data refreshes when returning to this tab
    _loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh data when app comes back to foreground
      _loadData();
    }
  }

  // Keep this widget's state when switching tabs
  @override
  bool get wantKeepAlive => true;

  Future<void> _loadData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    await _loadDailyData();
    await _loadMonthlyData();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadDailyData() async {
    if (!mounted) return;

    final sessionsForDay =
        await _sessionService.getSessionsForDay(_selectedDay);
    final tasksForDay = await _taskService.getTasksForDay(_selectedDay);

    final hourlyRate = Provider.of<AppState>(context, listen: false).hourlyRate;

    double hours = 0.0;
    double earnings = 0.0;

    for (final session in sessionsForDay) {
      hours += session.durationHours;
      earnings += session.calculateEarnings(hourlyRate);
    }

    int completedTasksCount =
        tasksForDay.where((task) => task.isCompleted).length;

    setState(() {
      _dailyHours = hours;
      _dailyEarnings = earnings;
      _completedTasks = completedTasksCount;
    });
  }

  Future<void> _loadMonthlyData() async {
    if (!mounted) return;

    final startOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final endOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);

    final sessions = await _sessionService.getSessionsInRange(
      startOfMonth,
      endOfMonth,
    );

    // Calculate hours worked for each day
    final Map<DateTime, double> hoursWorked = {};

    for (final session in sessions) {
      if (session.endTime == null) continue; // Skip active sessions

      final sessionDate = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );

      if (hoursWorked.containsKey(sessionDate)) {
        hoursWorked[sessionDate] =
            hoursWorked[sessionDate]! + session.durationHours;
      } else {
        hoursWorked[sessionDate] = session.durationHours;
      }
    }

    setState(() {
      _hoursWorked = hoursWorked;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _loadDailyData();
    }
  }

  void _exportMonthlyReport() async {
    try {
      final filePath = await _reportService.exportMonthlyReport(_focusedDay);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Report exported to: $filePath')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error exporting report: $e')));
    }
  }

  void _shareMonthlyReport() async {
    try {
      await _reportService.shareMonthlyReport(_focusedDay);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error sharing report: $e')));
    }
  }

  // Helper method to determine color based on hours worked
  Color _getColorForHours(double hours) {
    if (hours <= 2) {
      return Colors.lightBlue.shade400;
    } else if (hours <= 4) {
      return Colors.blue.shade600;
    } else if (hours <= 6) {
      return Colors.indigo.shade600;
    } else if (hours <= 8) {
      return Colors.purple.shade700;
    } else {
      return Colors.deepPurple.shade800;
    }
  }

  // Helper to format hours in a more readable way
  String _formatHours(double hours) {
    if (hours == hours.roundToDouble()) {
      return '${hours.toInt()}h';
    } else {
      return '${hours.toStringAsFixed(1)}h';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    final hourlyRate = Provider.of<AppState>(context).hourlyRate;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        actions: [
          // Add a refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh Data',
          ),
          IconButton(
            icon: const Icon(Icons.ios_share),
            onPressed: _shareMonthlyReport,
            tooltip: 'Share Report',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportMonthlyReport,
            tooltip: 'Export Report',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calendar
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    calendarFormat: _calendarFormat,
                    onDaySelected: _onDaySelected,
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                      _loadMonthlyData();
                    },
                    calendarStyle: CalendarStyle(
                      // Improve overall calendar appearance
                      cellMargin: const EdgeInsets.all(4),
                      todayDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
                        final key = DateTime(date.year, date.month, date.day);
                        if (_hoursWorked.containsKey(key)) {
                          final hours = _hoursWorked[key] ?? 0.0;

                          // Enhanced hour display with more prominent styling
                          return Stack(
                            children: [
                              // Day cell background with color based on hours
                              Positioned.fill(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 40),
                                  decoration: BoxDecoration(
                                    color: _getColorForHours(hours)
                                        .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              // More prominent hours display
                              Positioned(
                                right: 0,
                                left: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 3),
                                  margin: const EdgeInsets.only(top: 2),
                                  decoration: BoxDecoration(
                                    color: _getColorForHours(hours),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black45,
                                        blurRadius: 3,
                                        offset: Offset(0, 1),
                                        spreadRadius: 0.5,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    _formatHours(hours),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return null;
                      },
                      // Add a custom day builder to allow more space for the hour marker
                      defaultBuilder: (context, day, focusedDay) {
                        return Container(
                          margin: const EdgeInsets.all(2),
                          alignment: Alignment.topCenter,
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      },
                    ),
                  ),

                  // Daily summary
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Summary',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Hours Worked:'),
                            Text('${_dailyHours.toStringAsFixed(2)} hours'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Earnings:'),
                            Text('\$${_dailyEarnings.toStringAsFixed(2)}'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Tasks Completed:'),
                            Text('$_completedTasks tasks'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Monthly summary
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monthly Overview',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Divider(),
                        FutureBuilder<Map<String, dynamic>>(
                          future: _reportService.getMonthlyStats(_focusedDay),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            final data = snapshot.data!;
                            final totalHours = data['totalHours'] as double;
                            final totalEarnings = totalHours * hourlyRate;
                            final totalDays = data['workingDays'] as int;
                            final avgHoursPerDay =
                                totalDays > 0 ? totalHours / totalDays : 0.0;

                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Total Hours:'),
                                    Text(
                                        '${totalHours.toStringAsFixed(2)} hours'),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Total Earnings:'),
                                    Text(
                                        '\$${totalEarnings.toStringAsFixed(2)}'),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Working Days:'),
                                    Text('$totalDays days'),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Avg. Hours/Day:'),
                                    Text(
                                      '${avgHoursPerDay.toStringAsFixed(2)} hours',
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
