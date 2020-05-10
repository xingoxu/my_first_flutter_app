import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_playground/components/bottomNavigation.dart';
import 'package:flutter_playground/pages/root/indexEvents/index.dart';
import 'package:flutter_playground/pages/root/indexFeeds/index.dart';
import 'package:flutter_playground/pages/root/indexSchedule/index.dart';
import 'package:flutter_playground/data/state.dart';

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
      "transition": _AnimatedMainView(
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
        "view": IndexScheduleListWidget(
          tabIndex: 1,
        ),
        "icon": Icon(Icons.home),
        "title": Text('日程一览'),
      },
      {
        "view": IndexSchedule(tabIndex: 2),
        "icon": Icon(Icons.calendar_today),
        "title": Text('日程'),
      }
    ];
    _bottomNavigation = BottomNavigation(items: mainView);

    _navigationViews =
        mainView.map((obj) => obj["view"]).map(addFadeTransition).toList();
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
          onInit: (store) {
            _tabIndex = store.state.uiState.tabIndex;
            (_navigationViews[_tabIndex]['controller'] as AnimationController)
                .forward();
          },
          converter: (store) => store.state.uiState.tabIndex,
          builder: (context, tabIndex) {
            if (tabIndex != _tabIndex) {
              (_navigationViews[_tabIndex]['controller'] as AnimationController)
                  .reset();
              _tabIndex = tabIndex;
              (_navigationViews[_tabIndex]['controller'] as AnimationController)
                  .forward();
            }

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

class _AnimatedMainView extends AnimatedWidget {
  final Widget child;
  _AnimatedMainView({
    Key key,
    Animation<double> animationValue,
    this.child,
  }) : super(key: key, listenable: animationValue);

  @override
  Widget build(BuildContext context) {
    final animationValue = listenable as Animation<double>;
    return Transform.scale(
        scale:
            animationValue.value == 0 ? 0 : animationValue.value * 0.04 + 0.96,
        child: Opacity(
          opacity:
              animationValue.value == 0 ? 0 : animationValue.value * 0.7 + 0.3,
          child: child,
        ));
  }
}
