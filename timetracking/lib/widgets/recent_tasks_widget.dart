import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import 'animated_task_item.dart';

class RecentTasksWidget extends StatefulWidget {
  final Function(Task) onTaskToggle;
  final Function(Task) onTaskDelete;

  const RecentTasksWidget({
    Key? key,
    required this.onTaskToggle,
    required this.onTaskDelete,
  }) : super(key: key);

  @override
  State<RecentTasksWidget> createState() => _RecentTasksWidgetState();
}

class _RecentTasksWidgetState extends State<RecentTasksWidget> {
  final TaskService _taskService = TaskService();
  List<Task> _recentTasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentTasks();
  }

  Future<void> _loadRecentTasks() async {
    setState(() {
      _isLoading = true;
    });

    final tasks = await _taskService.getRecentTasks();

    setState(() {
      _recentTasks = tasks;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_recentTasks.isEmpty) {
      return const Center(
        child: Text('No recent tasks found'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRecentTasks,
      child: ListView.builder(
        itemCount: _recentTasks.length,
        itemBuilder: (context, index) {
          final task = _recentTasks[index];
          return AnimatedTaskItem(
            task: task,
            onToggle: widget.onTaskToggle,
            onDelete: widget.onTaskDelete,
          );
        },
      ),
    );
  }
}
