import 'package:flutter/material.dart';
import 'package:flutter_playground/components/mainView.dart';
import 'package:flutter_playground/data/state.dart';
import 'package:flutter_playground/data/uiState/actions.dart';
import 'package:flutter_playground/pages/indexSchedule/calendarMonthView.dart';
import 'package:flutter_redux/flutter_redux.dart';

class IndexSchedule extends StatelessWidget implements MainView {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, int>(
        converter: (store) => store.state.uiState.tabIndex,
        builder: (context, tabIndex) {
          if (tabIndex == this.tabIndex) {
            StoreProvider.of<AppState>(context, listen: false)
                .dispatch(ChangeAppBarTitleAction(title));
          }

          return CalendarMonthView();
        });
  }

  IndexSchedule({this.tabIndex}) : super();

  @override
  final int tabIndex;

  final String title = "Schedule";
}
