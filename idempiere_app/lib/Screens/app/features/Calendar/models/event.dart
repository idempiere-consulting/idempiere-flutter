// ignore: unused_import
import 'dart:collection';

// ignore: unused_import
import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final int id;
  final String title;
  final String description;
  final String type;
  final String typeId;
  final String status;
  final String statusId;
  final String scheduledStartDate;
  final String scheduledStartTime;
  final String scheduledEndTime;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.typeId,
    required this.status,
    required this.statusId,
    required this.scheduledStartDate,
    required this.scheduledStartTime,
    required this.scheduledEndTime,
  });
}
