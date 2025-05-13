import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../models/session.dart';
import 'storage_service.dart';

class SessionService {
  final StorageService _storage = StorageService();
  final String _sessionsKey = 'sessions';
  final String _activeSessionKey = 'active_session';
  final Uuid _uuid = const Uuid();

  // Start a new session
  Future<Session> startSession() async {
    final now = DateTime.now();
    final sessionId = _uuid.v4();

    final session = Session(id: sessionId, startTime: now);

    // Save as active session
    await _storage.setString(_activeSessionKey, jsonEncode(session.toJson()));

    return session;
  }

  // End an active session
  Future<Session> endSession(String sessionId) async {
    final activeSessionJson = await _storage.getString(_activeSessionKey);
    if (activeSessionJson == null) {
      throw Exception('No active session found');
    }

    final activeSession = Session.fromJson(jsonDecode(activeSessionJson));
    if (activeSession.id != sessionId) {
      throw Exception('Session ID mismatch');
    }

    final now = DateTime.now();
    final completedSession = Session(
      id: activeSession.id,
      startTime: activeSession.startTime,
      endTime: now,
      description: activeSession.description,
    );

    // Clear active session
    await _storage.remove(_activeSessionKey);

    // Save to session history
    await _saveSession(completedSession);

    return completedSession;
  }

  // Save a session to storage
  Future<void> _saveSession(Session session) async {
    final sessions = await _getAllSessions();
    sessions.add(session);
    await _saveSessions(sessions);
  }

  // Add manual session
  Future<Session> addManualSession({
    required DateTime startTime,
    required DateTime endTime,
    String? description,
  }) async {
    if (endTime.isBefore(startTime)) {
      throw Exception('End time cannot be before start time');
    }

    final session = Session(
      id: _uuid.v4(),
      startTime: startTime,
      endTime: endTime,
      description: description,
    );

    await _saveSession(session);
    return session;
  }

  // Get active session if any
  Future<Session?> getActiveSession() async {
    final activeSessionJson = await _storage.getString(_activeSessionKey);
    if (activeSessionJson == null) {
      return null;
    }

    return Session.fromJson(jsonDecode(activeSessionJson));
  }

  // Get all sessions
  Future<List<Session>> _getAllSessions() async {
    final sessionsJson = await _storage.getStringList(_sessionsKey);
    if (sessionsJson == null || sessionsJson.isEmpty) {
      return [];
    }

    return sessionsJson
        .map((json) => Session.fromJson(jsonDecode(json)))
        .toList();
  }

  // Save all sessions
  Future<void> _saveSessions(List<Session> sessions) async {
    final sessionsJson =
        sessions.map((session) => jsonEncode(session.toJson())).toList();

    await _storage.setStringList(_sessionsKey, sessionsJson);
  }

  // Get sessions for a specific day
  Future<List<Session>> getSessionsForDay(DateTime date) async {
    final allSessions = await _getAllSessions();

    return allSessions.where((session) {
      final sessionDate = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );

      final targetDate = DateTime(date.year, date.month, date.day);

      return sessionDate.isAtSameMomentAs(targetDate);
    }).toList();
  }

  // Get sessions between date range
  Future<List<Session>> getSessionsInRange(DateTime start, DateTime end) async {
    final allSessions = await _getAllSessions();

    return allSessions.where((session) {
      final sessionDate = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );

      final startDate = DateTime(start.year, start.month, start.day);

      final endDate = DateTime(end.year, end.month, end.day);

      return sessionDate.isAtSameMomentAs(startDate) ||
          sessionDate.isAtSameMomentAs(endDate) ||
          (sessionDate.isAfter(startDate) && sessionDate.isBefore(endDate));
    }).toList();
  }

  // Delete a session
  Future<void> deleteSession(String sessionId) async {
    final sessions = await _getAllSessions();
    sessions.removeWhere((session) => session.id == sessionId);
    await _saveSessions(sessions);
  }

  // Update a session
  Future<Session> updateSession(Session updatedSession) async {
    final sessions = await _getAllSessions();
    final index = sessions.indexWhere((s) => s.id == updatedSession.id);

    if (index == -1) {
      throw Exception('Session not found');
    }

    sessions[index] = updatedSession;
    await _saveSessions(sessions);

    return updatedSession;
  }
}
