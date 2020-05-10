// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
    title: json['title'] as String,
    startTime: json['startTime'] == null
        ? null
        : DateTime.parse(json['startTime'] as String),
    endTime: json['endTime'] == null
        ? null
        : DateTime.parse(json['endTime'] as String),
    id: json['id'] as String,
    notifications: (json['notifications'] as List)
        ?.map((e) =>
            e == null ? null : Notification.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )..color = _parseColorJson(json['color'] as Map<String, dynamic>);
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'color': _strigifyColor(instance.color),
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'notifications':
          instance.notifications?.map((e) => e?.toJson())?.toList(),
    };

Notification _$NotificationFromJson(Map<String, dynamic> json) {
  return Notification(
    json['id'] as int,
    json['scheduleTime'] == null
        ? null
        : DateTime.parse(json['scheduleTime'] as String),
  );
}

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scheduleTime': instance.scheduleTime?.toIso8601String(),
    };

Schedule _$ScheduleFromJson(Map<String, dynamic> json) {
  return Schedule(
    events: (json['events'] as List)
        ?.map(
            (e) => e == null ? null : Event.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'events': instance.events?.map((e) => e?.toJson())?.toList(),
    };
