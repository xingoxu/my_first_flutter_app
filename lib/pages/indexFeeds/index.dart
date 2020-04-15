import 'package:flutter/material.dart';
import 'package:flutter_playground/components/mainView.dart';
import 'package:flutter_playground/data/api.dart';
import 'package:flutter_playground/data/indexFeed/index.dart';
import 'package:flutter_redux/flutter_redux.dart';

class IndexFeedsListWidget extends StatefulWidget implements MainView {
  @override
  State<IndexFeedsListWidget> createState() => IndexFeedsState(tabIndex);

  IndexFeedsListWidget({@required this.tabIndex}) : super();
  @override
  final int tabIndex;
}

class IndexFeedsState extends State<IndexFeedsListWidget> {
  final int tabIndex;
  final String title = "Home";
  IndexFeedsState(this.tabIndex) : super();

  Future<List<IndexFeed>> indexFeedsPromise;
  @override
  void initState() {
    super.initState();
    indexFeedsPromise = getIndexFeeds();
  }

  String formatNumber(int number) {
    return number.toString().padLeft(2, '0');
  }

  String formatDate(DateTime dt) {
    return '${dt.year}-${formatNumber(dt.month)}-${formatNumber(dt.day)} ${formatNumber(dt.hour)}:${formatNumber(dt.minute)}:${formatNumber(dt.second)}';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<IndexFeed>>(
        future: indexFeedsPromise,
        builder: (context, snapshot) {
          Widget body = (() {
            if (snapshot.hasData) {
              return ListView.builder(
                  // itemCount: (snapshot.data.length-1)*2+1,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    // if (i.isOdd) return Divider();
                    // final index = i ~/ 2;
                    final index = i;
                    final _endTimeDate =
                        DateTime.parse(snapshot.data[index].endTime).toLocal();
                    return GestureDetector(
                      child: Card(
                        child: ListTile(
                          title: Text(snapshot.data[index].title),
                          subtitle: Text(formatDate(_endTimeDate)),
                        ),
                      ),
                      onTap: () {
                        print('tapped from card');
                      },
                    );
                  });
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          })();

          return Scaffold(
            appBar: AppBar(
              title: Text("Home"),
            ),
            body: body,
          );
        });
  }
}
