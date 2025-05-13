class Session {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final String? description;

  Session({
    required this.id,
    required this.startTime,
    this.endTime,
    this.description,
  });

  // Calculate duration in hours
  double get durationHours {
    if (endTime == null) {
      return 0.0;
    }

    final duration = endTime!.difference(startTime);
    return duration.inMinutes / 60.0;
  }

  // Calculate earnings based on hourly rate
  double calculateEarnings(double hourlyRate) {
    return durationHours * hourlyRate;
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'description': description,
    };
  }

  // Create from JSON
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      description: json['description'],
    );
  }
}
