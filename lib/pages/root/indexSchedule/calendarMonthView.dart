import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_playground/pages/root/indexSchedule/components/schedule.dart';
import 'package:flutter_playground/utils/calendarHelpers.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CalendarMonthView extends StatefulWidget {
  final DateTime _monthShowing;
  CalendarMonthView({DateTime monthShowing})
      : this._monthShowing = monthShowing ?? DateTime.now(),
        super();
  @override
  State<StatefulWidget> createState() => CalendarState();
}

class CalendarState extends State<CalendarMonthView> {
  PageController _pageController = PageController();

  final int numWeekDays = 7;

  @override
  Widget build(BuildContext context) {
    setContextVar();
    return getPageView(context);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Widget> getCalendar(DateTime _monthDate) {
    final rowLength =
        ((getNumberOfDaysInMonth(_monthDate.year, _monthDate.month) +
                    getDayPadding(_monthDate.year, _monthDate.month)) /
                numWeekDays)
            .ceil();
    List<Expanded> rows = Iterable<int>.generate(rowLength)
        .map((rowIndex) => Iterable<int>.generate(numWeekDays)
            .map((columnIndex) {
              final tableCellIndex = rowIndex * numWeekDays + columnIndex + 1;
              return buildDayNumberWidget(_monthDate, tableCellIndex);
            })
            .map((dayNumberWidget) => Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: Column(
                      children: [
                        dayNumberWidget,
                      ],
                    ),
                    onTap: () {
                      print('tapped from calendar');
                    },
                  ),
                ))
            .toList())
        .map((children) => Expanded(
              flex: 1,
              child: Row(
                children: children,
              ),
            ))
        .toList(growable: true);
    return rows;
  }

  Widget getWeekDayBar(BuildContext context) {
    final weekDayWidgets = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
        .map((str) => Text(
              str,
              textAlign: TextAlign.center,
              style: _dayTextStyle.copyWith(
                  color: Theme.of(context).unselectedWidgetColor),
            ))
        .map((textWidget) => Expanded(child: textWidget))
        .toList();
    return Container(
      padding: EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        children: weekDayWidgets,
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }

  DateTime _monthShowing;
  final _nextMonthDate = DateTime.now().add(new Duration(days: 30));

  Widget getPageView(BuildContext context) {
    // return Column(children: <Widget>[
    //   getWeekDayBar(context),
    //   Expanded(child: PageView(scrollDirection: Axis.vertical, children: <Widget>[
    //     Column(
    //       children: getCalendar(_monthShowing),
    //     ),
    //     Column(
    //       children: getCalendar(_nextMonthDate),
    //     ),
    //   ]))
    // ]);

    return Column(children: <Widget>[
      getWeekDayBar(context),
      Expanded(
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment(0.6, 0.6),
          children: <Widget>[
            new Column(
              children: getCalendar(_monthShowing),
            ),
            ScheduleWidget(
              monthShowing: _monthShowing,
            ),
          ],
        ),
      )
    ]);
  }

  BorderSide _tableBorder;
  TextStyle _dayTextStyle;

  void setContextVar() {
    _monthShowing = widget._monthShowing;
    _tableBorder = BorderSide(width: 1, color: Theme.of(context).dividerColor);
    _dayTextStyle = Theme.of(context).textTheme.body1;
  }

  Widget buildDayNumberWidget(DateTime monthShowing, int tableCellIndex) {
    final _beginPadding = getDayPadding(monthShowing.year, monthShowing.month);
    final _totalDays =
        getNumberOfDaysInMonth(monthShowing.year, monthShowing.month);

    final _isBlank = (tableCellIndex <= _beginPadding ||
        (tableCellIndex - _beginPadding) > _totalDays);
    final _todayDate = DateTime.now();
    final _isToday = (tableCellIndex - _beginPadding) == _todayDate.day &&
        monthShowing.month == _todayDate.month &&
        monthShowing.year == _todayDate.year;
    final _isLeftBorder = tableCellIndex % 7 == 1;

    final text = _isBlank
        ? null
        : new Text(
            (tableCellIndex - _beginPadding).toString(),
            textAlign: TextAlign.center,
            style: _isToday
                ? _dayTextStyle.copyWith(color: Colors.white)
                : _dayTextStyle,
          );

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: _tableBorder,
            bottom: BorderSide.none,
            left: _isLeftBorder ? BorderSide.none : _tableBorder,
            right: BorderSide.none,
          ),
        ),
        child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: _isToday ? EdgeInsets.all(0) : EdgeInsets.all(2),
              child: Container(
                padding: _isToday
                    ? EdgeInsets.fromLTRB(8, 5, 8, 5)
                    : EdgeInsets.all(3),
                decoration: _isToday
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).accentColor,
                      )
                    : null,
                child: text,
              ),
            )),
      ),
    );
  }
}
