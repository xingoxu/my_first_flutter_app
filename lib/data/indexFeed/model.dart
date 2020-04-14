import 'package:json_annotation/json_annotation.dart';
part 'model.g.dart';

@JsonSerializable()
class IndexFeed {
  IndexFeed({this.title, this.startTime, this.endTime, this.campaignId});

  String title;
  String startTime;
  String endTime;

  @JsonKey(name: "id")
  String campaignId;

  factory IndexFeed.fromJson(Map<String, dynamic> json) =>
      _$IndexFeedFromJson(json);

  Map<String, dynamic> toJson() => _$IndexFeedToJson(this);
}

@JsonSerializable()
class IndexFeedsData {
  IndexFeedsData({this.data});

  List<IndexFeed> data;

  factory IndexFeedsData.fromJson(Map<String, dynamic> json) =>
      _$IndexFeedsDataFromJson(json);
}
