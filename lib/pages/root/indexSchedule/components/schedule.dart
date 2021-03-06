import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_playground/data/schedule/model.dart';
import 'package:flutter_playground/data/state.dart';
import 'package:flutter_playground/utils/calendarHelpers.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_playground/data/api.dart';
import 'package:flutter_playground/data/indexFeed/index.dart';

import 'package:flutter_playground/consts.dart';

class ScheduleWidget extends StatefulWidget {
  final DateTime monthShowing;
  ScheduleWidget({this.monthShowing}) : super();

  @override
  State<StatefulWidget> createState() => ScheduleState();
}

class ScheduleState extends State<ScheduleWidget> {
  DateTime monthShowing;
  List<List<List<_WidgetPlaceholder>>> currentCalendarEventWidgets;

  @override
  Widget build(BuildContext context) {
    _setContextVar();
    return StoreConnector<AppState, Schedule>(
      converter: (store) => store.state.schedule,
      builder: (BuildContext context, Schedule schedule) {
        this.indexEvents = schedule.events;
        this.setCalendarEvent();

        final rowLength =
            ((getNumberOfDaysInMonth(monthShowing.year, monthShowing.month) +
                        getDayPadding(monthShowing.year, monthShowing.month)) /
                    NUM_WEEK_DAYS)
                .ceil();

        List<Expanded> rows = Iterable<int>.generate(rowLength).map((rowIndex) {
          return Expanded(
            flex: 1,
            child: Container(
                padding: EdgeInsets.fromLTRB(0, _dayTextWidgetHeight, 0, 0),
                child: _buildEventWidget(rowIndex)),
          );
        }).toList(growable: true);
        return IgnorePointer(
          ignoring: true,
          child: new Column(
            children: rows,
          ),
        );
      },
    );
  }

  double _dayTextWidgetHeight;
  TextStyle _dayTextStyle;

  void _setContextVar() {
    this.monthShowing = widget.monthShowing;
    _dayTextStyle = Theme.of(context).textTheme.body1;

    final constraints = BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width, // maxwidth calculated
      minHeight: 0.0,
      minWidth: 0.0,
    );
    RenderParagraph renderParagraph = RenderParagraph(
        TextSpan(
          text: '日本語 Test',
          style: _dayTextStyle,
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr);
    renderParagraph.layout(constraints);

    _dayTextWidgetHeight =
        renderParagraph.getMaxIntrinsicHeight(double.infinity).ceilToDouble() +
            2 * 2 +
            3 * 2;
  }

  Widget _buildEventWidget(int rowIndex) {
    if (currentCalendarEventWidgets == null) {
      return FittedBox();
    }

    return Column(
      children: currentCalendarEventWidgets[rowIndex]
          .map((rowWidgets) => Row(
                children: rowWidgets
                    .map((widget) => buildTask(widget.feed, widget.dayLast))
                    .toList(),
              ))
          .toList(),
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // TODO
  //   getIndexFeeds().then((data) {
  //     setState(() {
  //       indexFeeds = data;
  //     });
  //   });
  // }

  // List<IndexFeed> indexFeeds;
  List<Event> indexEvents;

  void setCalendarEvent() {
    var feeds = indexEvents == null ? [] : [...indexEvents];
    final _totalDays =
        getNumberOfDaysInMonth(monthShowing.year, monthShowing.month);

    List<List<Event>> mCalendarEvent = [];
    mCalendarEvent.length = _totalDays + 1;

    final monthEnd = new DateTime(
        monthShowing.year, monthShowing.month, _totalDays, 23, 59, 59);
    final monthStart =
        new DateTime(monthShowing.year, monthShowing.month, 1, 0, 0, 0);

    // filter feeds don't need to show on this month
    // sort the oldest to the newest
    feeds = feeds.where((feed) {
      return !( /** DateTime.parse */ (feed.startTime).isAfter(monthEnd) ||
           /** DateTime.parse */ (feed.endTime).isBefore(monthStart));
    }).toList(growable: true)
      ..sort((feedA, feedB) {
        var startTimeA = /** DateTime.parse */ (feedA.startTime);
        var startTimeB = /** DateTime.parse */ (feedB.startTime);
        if (startTimeA.isBefore(startTimeB) == false &&
            startTimeA.isAfter(startTimeB) == false) {
          return  /** DateTime.parse */ (feedA.endTime)
                  .isAfter( /** DateTime.parse */ (feedB.endTime))
              ? 1
              : -1;
        }
        return startTimeA.isBefore(startTimeB) ? -1 : 1;
      });

    // set date schedule
    for (var i = 0; i < feeds.length; i++) {
      final _startTime = /** DateTime.parse */(feeds[i].startTime).toLocal();
      final _endTime = /** DateTime.parse */(feeds[i].endTime).toLocal();

      setDayFree(
          monthStart.isAfter(_startTime) ? 1 : _startTime.day,
          monthEnd.isBefore(_endTime) ? _totalDays : _endTime.day,
          feeds[i],
          mCalendarEvent);
    }

    final _beginPadding = getDayPadding(monthShowing.year, monthShowing.month);

    final rowLength = ((_totalDays + _beginPadding) / NUM_WEEK_DAYS).ceil();

    var result = Iterable<int>.generate(rowLength).map((rowIndex) {
      List<List<_WidgetPlaceholder>> rowSchedule = [];
      // get row length (max week length)
      int maxV = 0;
      for (var i = 0; i < NUM_WEEK_DAYS; i++) {
        final tableCellIndex = rowIndex * NUM_WEEK_DAYS + i + 1;
        final actualDate = tableCellIndex - _beginPadding;

        if ((actualDate <= 0 || (actualDate) > _totalDays)) {
          continue;
        }
        var length = mCalendarEvent[actualDate] == null
            ? 0
            : mCalendarEvent[actualDate].length;
        maxV = max(length, maxV);
      }

      // set row widget
      rowSchedule.length = maxV;
      for (var j = 0; j < maxV; j++) {
        Event feedLast;
        int start = 0;
        rowSchedule[j] = [];
        for (var i = 0; i < NUM_WEEK_DAYS; i++) {
          final tableCellIndex = rowIndex * NUM_WEEK_DAYS + i + 1;
          final actualDate = tableCellIndex - _beginPadding;

          Event feedNow;
          // isDate
          if (!((actualDate <= 0 || (actualDate) > _totalDays))) {
            if (mCalendarEvent[actualDate] != null &&
                mCalendarEvent[actualDate].length > j &&
                mCalendarEvent[actualDate][j] != null)
              feedNow = mCalendarEvent[actualDate][j];
          }

          if (i == 0) {
            feedLast = feedNow;
            continue;
          }
          if (feedLast != feedNow) {
            rowSchedule[j].add(
                new _WidgetPlaceholder(feed: feedLast, dayLast: i - start));
            feedLast = feedNow;
            start = i;
          }
        }
        rowSchedule[j].add(new _WidgetPlaceholder(
          feed: feedLast,
          dayLast: NUM_WEEK_DAYS - start,
        ));
      }

      return rowSchedule;
    }).toList();

    // setState(() {
      currentCalendarEventWidgets = result;
    // });
  }

  void setDayFree(
      int from, int to, Event feed, List<List<Event>> _calendarEvent) {
    int setIndex = 0;
    while (true) {
      bool canSet = true;
      for (var i = from; i <= to; i++) {
        if (_calendarEvent[i] == null) _calendarEvent[i] = [];

        if (_calendarEvent[i].length <= setIndex)
          _calendarEvent[i].length = setIndex + 1;

        if (_calendarEvent[i][setIndex] != null) {
          canSet = false;
          break;
        }
      }
      if (canSet) {
        for (var i = from; i <= to; i++) {
          _calendarEvent[i][setIndex] = feed;
        }
        return;
      } else {
        ++setIndex;
      }
    }
  }

  Widget _buildTask(Event task) {
    return Container(
      margin: EdgeInsets.only(left: 1, right: 1),
      decoration: new BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        color: Theme.of(context).primaryColorDark,
      ),
      padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
      child: Text(
        task.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: _dayTextStyle.copyWith(color: Colors.white),
      ),
    );
  }

  Widget buildTask(Event task, int lastDay) {
    return Expanded(
      child: task == null ? Container() : _buildTask(task),
      flex: lastDay,
    );
  }
}

class _WidgetPlaceholder {
  Event feed;
  int dayLast;
  _WidgetPlaceholder({this.feed, this.dayLast});
}
