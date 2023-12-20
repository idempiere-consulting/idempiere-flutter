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
  final String startDate;
  final String scheduledStartTime;
  final String scheduledEndTime;
  final String phone;
  final String phone2;
  final String refname;
  final String ref2name;
  final String cBPartner;
  final int workOrderId;
  final String workOrderName;
  final int userId;
  final String userName;
  final String? createdby;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.typeId,
    required this.status,
    required this.statusId,
    required this.scheduledStartDate,
    required this.startDate,
    required this.scheduledStartTime,
    required this.scheduledEndTime,
    required this.phone,
    required this.phone2,
    required this.refname,
    required this.ref2name,
    required this.cBPartner,
    required this.workOrderId,
    required this.workOrderName,
    required this.userId,
    required this.userName,
    this.createdby,
  });
}
