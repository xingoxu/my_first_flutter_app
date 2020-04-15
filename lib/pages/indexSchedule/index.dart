import 'package:flutter/material.dart';
import 'package:flutter_playground/components/mainView.dart';
import 'package:flutter_playground/data/state.dart';
import 'package:flutter_playground/data/uiState/actions.dart';
import 'package:flutter_playground/pages/indexSchedule/calendarMonthView.dart';
import 'package:flutter_redux/flutter_redux.dart';

class IndexSchedule extends StatefulWidget implements MainView {
  IndexSchedule({this.tabIndex}) : super();

  @override
  final int tabIndex;

  @override
  State<StatefulWidget> createState() => IndexScheduleState();
}

class IndexScheduleState extends State<IndexSchedule> {
  DateTime _monthShowing;
  @override
  void initState() {
    super.initState();
    this._monthShowing = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, int>(
        converter: (store) => store.state.uiState.tabIndex,
        builder: (context, tabIndex) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Schedule - ${_monthShowing.month}月"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  tooltip: "Last Month",
                  onPressed: () {
                    setState(() {
                      _monthShowing = DateTime(_monthShowing.year,
                          _monthShowing.month - 1, _monthShowing.day);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  tooltip: "Next Month",
                  onPressed: () {
                    setState(() {
                      _monthShowing = DateTime(_monthShowing.year,
                          _monthShowing.month + 1, _monthShowing.day);
                    });
                  },
                ),
              ],
              // actionsIconTheme: IconThemeData(color: Colors.white,opacity: 1),
            ),
            body: CalendarMonthView(monthShowing: _monthShowing),
          );
        });
  }
}
