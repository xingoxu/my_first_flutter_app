// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_playground/pages/indexFeeds/index.dart';
import 'package:flutter_playground/pages/indexSchedule/index.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'data/reducers.dart';
import 'data/state.dart';
import 'components/bottomNavigation.dart';

// TODO
// https://pub.dev/packages/flutter_statusbarcolor
// https://github.com/flutter/flutter/issues/24472#issuecomment-440015464


void main() {
  final store = new Store<AppState>(
    appStateReducer,
    initialState: AppState(),
    distinct: true,
  );
  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp(this.store);

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
        store: store,
        child: MaterialApp(
          title: 'My First Flutter App',
          home: Home(),
        ));
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Map<String, Object> addFadeTransition(Widget widget) {
    var controller = AnimationController(
      duration: kThemeAnimationDuration,
      vsync: this,
    );
    var animation = controller.drive(CurveTween(
      curve: const Interval(0, 1, curve: Curves.fastOutSlowIn),
    ));
    return {
      "controller": controller,
      "transition": AnimatedMainView(
        child: widget,
        animationValue: animation,
      )
    };
  }

  List<Map<String, Object>> _navigationViews;
  BottomNavigation _bottomNavigation;

  _HomeState() : super() {
    final mainView = [
      {
        "view": IndexFeedsListWidget(
          tabIndex: 0,
        ),
        "icon": Icon(Icons.home),
        "title": Text('活动一览'),
      },
      {
        "view": IndexSchedule(tabIndex: 1),
        "icon": Icon(Icons.calendar_today),
        "title": Text('日程'),
      }
    ];
    _bottomNavigation = BottomNavigation(items: mainView);

    _navigationViews = mainView
        .map((obj) => obj["view"])
        .map(addFadeTransition)
        .toList();
  }

  int _tabIndex;

  @override
  Widget build(BuildContext context) {
    final animationViews = _navigationViews
        .map((obj) => obj["transition"] as AnimatedWidget)
        .toList();
    animationViews.sort((a, b) => (a.listenable as Animation<double>)
        .value
        .compareTo((b.listenable as Animation<double>).value));

    return Scaffold(
      body: new StoreConnector<AppState, int>(
          onInit: (store) => _tabIndex = store.state.uiState.tabIndex,
          converter: (store) => store.state.uiState.tabIndex,
          builder: (context, tabIndex) {
            (_navigationViews[_tabIndex]['controller'] as AnimationController)
                .reset();
            _tabIndex = tabIndex;
            (_navigationViews[_tabIndex]['controller'] as AnimationController)
                .forward();

            return Stack(
              children: animationViews,
            );
          }),
      bottomNavigationBar: _bottomNavigation,
    );
  }

  @override
  void dispose() {
    _navigationViews
        .forEach((obj) => (obj['controller'] as AnimationController).dispose());
    super.dispose();
  }
}

class AnimatedMainView extends AnimatedWidget {
  final Widget child;
  AnimatedMainView({
    Key key,
    Animation<double> animationValue,
    this.child,
  }) : super(key: key, listenable: animationValue);

  @override
  Widget build(BuildContext context) {
    final animationValue = listenable as Animation<double>;
    return Transform.scale(
        scale: animationValue.value == 0 ? 0 : animationValue.value * 0.04 + 0.96,
        child: Opacity(
          opacity:
              animationValue.value == 0 ? 0 : animationValue.value * 0.7 + 0.3,
          child: child,
        ));
  }
}
