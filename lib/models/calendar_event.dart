import 'package:flutter/material.dart';

class CalendarEvent {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final DateTime? endDateTime;
  final EventType type;
  final String? relatedId; // ID de session, programme, etc.
  final bool hasReminder;
  final int reminderMinutes; // minutes avant l'événement
  final Color color;
  final bool isCompleted;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    this.endDateTime,
    required this.type,
    this.relatedId,
    this.hasReminder = false,
    this.reminderMinutes = 30,
    this.color = const Color(0xFF1B3A5E),
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'endDateTime': endDateTime?.millisecondsSinceEpoch,
      'type': type.index,
      'relatedId': relatedId,
      'hasReminder': hasReminder,
      'reminderMinutes': reminderMinutes,
      'colorValue': color.value,
      'isCompleted': isCompleted,
    };
  }

  factory CalendarEvent.fromMap(Map<String, dynamic> map, String id) {
    return CalendarEvent(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
      endDateTime: map['endDateTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endDateTime'])
          : null,
      type: EventType.values[map['type'] ?? 0],
      relatedId: map['relatedId'],
      hasReminder: map['hasReminder'] ?? false,
      reminderMinutes: map['reminderMinutes'] ?? 30,
      color: Color(map['colorValue'] ?? 0xFF1B3A5E),
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  String getFormattedTime(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (eventDate == today) {
      return 'Today at ${_formatTime(dateTime)}';
    } else if (eventDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday at ${_formatTime(dateTime)}';
    } else if (eventDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow at ${_formatTime(dateTime)}';
    } else {
      return '${_formatDate(dateTime)} at ${_formatTime(dateTime)}';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

enum EventType {
  session,
  seance,
  appointment,
  program,
  personal,
  reminder,
}

extension EventTypeExtension on EventType {
  String getDisplayName(String lang) {
    switch (this) {
      case EventType.session:
        return lang == 'AR' ? 'جلسة' : lang == 'FR' ? 'Session' : 'Session';
      case EventType.seance:
        return lang == 'AR' ? 'حصة' : lang == 'FR' ? 'Séance' : 'Seance';
      case EventType.appointment:
        return lang == 'AR' ? 'موعد' : lang == 'FR' ? 'Rendez-vous' : 'Appointment';
      case EventType.program:
        return lang == 'AR' ? 'برنامج' : lang == 'FR' ? 'Programme' : 'Program';
      case EventType.personal:
        return lang == 'AR' ? 'شخصي' : lang == 'FR' ? 'Personnel' : 'Personal';
      case EventType.reminder:
        return lang == 'AR' ? 'تذكير' : lang == 'FR' ? 'Rappel' : 'Reminder';
    }
  }

  IconData getIcon() {
    switch (this) {
      case EventType.session:
        return Icons.video_call;
      case EventType.seance:
        return Icons.fitness_center;
      case EventType.appointment:
        return Icons.calendar_today;
      case EventType.program:
        return Icons.school;
      case EventType.personal:
        return Icons.person;
      case EventType.reminder:
        return Icons.alarm;
    }
  }
}