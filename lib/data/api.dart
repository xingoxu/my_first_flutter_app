import 'dart:convert';

import 'indexFeed/index.dart';

Future<List<IndexFeed>> getIndexFeeds() async {
  const serverJson = '''
  {"data":[{"title":"Visaのタッチ決済 1,000円までタダ","startTime":"2020-03-02T00:00:00+09:00","endTime":"2020-04-30T23:59:59+09:00","id":"123"},{"title":"Visaのタッチ決済 1,000円までタダ","startTime":"2020-03-05T00:00:00+09:00","endTime":"2020-03-10T23:59:59+09:00","id":"125"},{"title":"三菱UFJニコス 新規クレジットカード20%キャッシュバック","startTime":"2020-02-01T00:00:00+09:00","endTime":"2020-06-30T23:59:59+09:00","id":"124"}]}
  ''';

  return IndexFeedsData.fromJson(jsonDecode(serverJson)).data;
}
