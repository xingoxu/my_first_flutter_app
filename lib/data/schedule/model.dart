import 'package:flutter/material.dart';
import 'package:flutter_playground/utils/io.dart';
import 'package:json_annotation/json_annotation.dart';

import '../state.dart';
part 'model.g.dart';

@JsonSerializable(explicitToJson: true)
class Event {
  Event({
    this.title,
    this.startTime,
    this.endTime,
    this.id,
    this.notifications,
  }) {
    if (this.notifications == null) this.notifications = [];
  }

  Event clone() {
    return Event()
      ..title = this.title
      ..startTime = DateTime.parse(this.startTime.toIso8601String())
      ..endTime = DateTime.parse(this.endTime.toIso8601String())
      ..notifications = List.from(this.notifications)
      ..color = this.color;
  }

  String id;
  String title;
  @JsonKey(toJson: _strigifyColor, fromJson: _parseColorJson)
  Color color;
  DateTime startTime;
  DateTime endTime;
  void addNotification(DateTime time) {
    notifications.add(Notification.fromAvailableId(time));
  }

  void removeNotification(Notification schedule) {
    notifications.remove(schedule);
  }

  List<Notification> notifications;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Notification {
  static int availableId = 0;

  Notification(this.id, this.scheduleTime);
  Notification.fromAvailableId(this.scheduleTime) {
    id = ++availableId;
  }

  int id;
  DateTime scheduleTime;

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);

  static Future<void> saveAvailableId() async {
    await NotificationAvailableIdStorage().saveId(availableId);
  }

  static Future<void> setAvailableId() async {
    availableId = await NotificationAvailableIdStorage().getSavedId();
  }
}

@JsonSerializable(explicitToJson: true)
class Schedule extends ReduxState {
  Schedule({List<Event> events})
      : this.events = events ?? List.unmodifiable([]);
  Schedule.clone(Schedule state) : this.events = state.events;
  Schedule clone() => Schedule.clone(this);
  List<Event> events;

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}

Map<String, int> _strigifyColor(Color color) => ({
      'a': color?.alpha,
      'r': color?.red,
      'g': color?.green,
      'b': color?.blue,
    });

Color _parseColorJson(Map<String, dynamic> json) =>
    (json['a'] != null && json['r'] != null && json['g'] != null && json['b'] != null)
        ? Color.fromARGB(json['a'], json['r'], json['g'], json['b'])
        : null;


class NotificationAvailableIdStorage extends Storage  {
  String fileName = 'NotificationAvailableId.txt';
  Future<int> getSavedId() async {
    try {
      return int.parse(await getContent());
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<void> saveId(int id) async {
    await writeContent(id.toString());
  }
}