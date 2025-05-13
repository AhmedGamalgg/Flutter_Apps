import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../widgets/animated_task_item.dart';
import '../widgets/recent_tasks_widget.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with SingleTickerProviderStateMixin {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];
  bool _showOnlyUncompleted = false;
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });

    final tasks = await _taskService.getAllTasks();
    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  List<Task> get _filteredTasks {
    if (_showOnlyUncompleted) {
      return _tasks.where((task) => !task.isCompleted).toList();
    }
    return _tasks;
  }

  void _toggleFilter() {
    setState(() {
      _showOnlyUncompleted = !_showOnlyUncompleted;
    });
  }

  void _addTask() async {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descController = TextEditingController();
    DateTime? _assignedDate;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter task title',
                  ),
                ),
                TextField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter task description (optional)',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Assigned Date:'),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _assignedDate != null
                          ? OutlinedButton.icon(
                              icon: const Icon(Icons.calendar_today),
                              label: Text(
                                '${_assignedDate!.day}/${_assignedDate!.month}/${_assignedDate!.year}',
                              ),
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _assignedDate ?? DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030),
                                );
                                if (date != null) {
                                  setState(() {
                                    _assignedDate = date;
                                  });
                                }
                              },
                            )
                          : TextButton.icon(
                              icon: const Icon(Icons.calendar_today),
                              label: const Text('Select Date'),
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030),
                                );
                                if (date != null) {
                                  setState(() {
                                    _assignedDate = date;
                                  });
                                }
                              },
                            ),
                    ),
                    if (_assignedDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _assignedDate = null;
                          });
                        },
                      ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_titleController.text.trim().isNotEmpty) {
                    final task = await _taskService.createTask(
                      _titleController.text.trim(),
                      description: _descController.text.trim().isNotEmpty
                          ? _descController.text.trim()
                          : null,
                      assignedDate: _assignedDate,
                    );
                    setState(() {
                      _tasks.add(task);
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _toggleTaskCompletion(Task task) async {
    await _taskService.toggleTaskCompletion(task.id);
    setState(() {
      task.toggleCompletion();
    });
  }

  void _deleteTask(Task task) async {
    await _taskService.deleteTask(task.id);
    setState(() {
      _tasks.removeWhere((t) => t.id == task.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Tasks'),
            Tab(text: 'Recent Tasks'),
          ],
        ),
        actions: [
          if (_tabController.index == 0)
            IconButton(
              icon: Icon(
                _showOnlyUncompleted
                    ? Icons.filter_list_off
                    : Icons.filter_list,
              ),
              onPressed: _toggleFilter,
              tooltip: 'Toggle filter',
            ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All Tasks Tab
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredTasks.isEmpty
                  ? Center(
                      child: Text(
                        _showOnlyUncompleted
                            ? 'No uncompleted tasks'
                            : 'No tasks added yet',
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = _filteredTasks[index];
                        return AnimatedTaskItem(
                          task: task,
                          onToggle: _toggleTaskCompletion,
                          onDelete: _deleteTask,
                        );
                      },
                    ),

          // Recent Tasks Tab
          RecentTasksWidget(
            onTaskToggle: _toggleTaskCompletion,
            onTaskDelete: _deleteTask,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
