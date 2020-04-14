// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IndexFeed _$IndexFeedFromJson(Map<String, dynamic> json) {
  return IndexFeed(
    title: json['title'] as String,
    startTime: json['startTime'] as String,
    endTime: json['endTime'] as String,
    campaignId: json['id'] as String,
  );
}

Map<String, dynamic> _$IndexFeedToJson(IndexFeed instance) => <String, dynamic>{
      'title': instance.title,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'id': instance.campaignId,
    };

IndexFeedsData _$IndexFeedsDataFromJson(Map<String, dynamic> json) {
  return IndexFeedsData(
    data: (json['data'] as List)
        ?.map((e) =>
            e == null ? null : IndexFeed.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$IndexFeedsDataToJson(IndexFeedsData instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
