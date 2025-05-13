import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import 'storage_service.dart';

class TaskService {
  final StorageService _storage = StorageService();
  final String _tasksKey = 'tasks';
  final Uuid _uuid = const Uuid();

  // Get all tasks
  Future<List<Task>> getAllTasks() async {
    final tasksJson = await _storage.getStringList(_tasksKey);
    if (tasksJson == null || tasksJson.isEmpty) {
      return [];
    }

    return tasksJson.map((json) => Task.fromJson(jsonDecode(json))).toList();
  }

  // Save all tasks
  Future<void> _saveTasks(List<Task> tasks) async {
    final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();

    await _storage.setStringList(_tasksKey, tasksJson);
  }

  // Create a new task
  Future<Task> createTask(
    String title, {
    String? description,
    DateTime? assignedDate,
  }) async {
    final task = Task(
      id: _uuid.v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      assignedDate: assignedDate,
    );

    final tasks = await getAllTasks();
    tasks.add(task);
    await _saveTasks(tasks);

    return task;
  }

  // Toggle task completion status
  Future<Task> toggleTaskCompletion(String taskId) async {
    final tasks = await getAllTasks();
    final index = tasks.indexWhere((task) => task.id == taskId);

    if (index == -1) {
      throw Exception('Task not found');
    }

    tasks[index].toggleCompletion();
    await _saveTasks(tasks);

    return tasks[index];
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    final tasks = await getAllTasks();
    tasks.removeWhere((task) => task.id == taskId);
    await _saveTasks(tasks);
  }

  // Update a task
  Future<Task> updateTask(Task updatedTask) async {
    final tasks = await getAllTasks();
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);

    if (index == -1) {
      throw Exception('Task not found');
    }

    tasks[index] = updatedTask;
    await _saveTasks(tasks);

    return updatedTask;
  }

  // Get tasks for a specific day
  Future<List<Task>> getTasksForDay(DateTime date) async {
    final tasks = await getAllTasks();

    return tasks.where((task) {
      if (task.assignedDate == null) return false;

      final taskDate = DateTime(
        task.assignedDate!.year,
        task.assignedDate!.month,
        task.assignedDate!.day,
      );

      final targetDate = DateTime(date.year, date.month, date.day);

      return taskDate.isAtSameMomentAs(targetDate);
    }).toList();
  }

  // Get completed tasks for a day
  Future<List<Task>> getCompletedTasksForDay(DateTime date) async {
    final tasksForDay = await getTasksForDay(date);
    return tasksForDay.where((task) => task.isCompleted).toList();
  }

  // Get recent tasks (last 7 days)
  Future<List<Task>> getRecentTasks() async {
    final allTasks = await getAllTasks();
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    return allTasks
        .where((task) => task.createdAt.isAfter(sevenDaysAgo))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}
