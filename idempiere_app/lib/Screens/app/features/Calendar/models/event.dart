// ignore: unused_import
import 'dart:collection';

// ignore: unused_import
import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final int id;
  final String title;
  final String type;
  final String scheduledStartDate;
  final String scheduledStartTime;
  final String scheduledEndTime;

  const Event({
    required this.id,
    required this.title,
    required this.type,
    required this.scheduledStartDate,
    required this.scheduledStartTime,
    required this.scheduledEndTime,
  });
}
