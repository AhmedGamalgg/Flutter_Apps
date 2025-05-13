class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime? assignedDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    this.assignedDate,
    this.isCompleted = false,
  });

  // Toggle completion status
  void toggleCompletion() {
    isCompleted = !isCompleted;
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'assignedDate': assignedDate?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  // Create from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      assignedDate:
          json['assignedDate'] != null
              ? DateTime.parse(json['assignedDate'])
              : null,
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
