import 'package:flutter/material.dart';
import 'package:flutter_playground/data/state.dart';
import 'package:flutter_playground/data/uiState/actions.dart';
import 'package:flutter_playground/data/uiState/model.dart';
import 'package:flutter_redux/flutter_redux.dart';

class _VM {
  UIState state;
  Function(int index) callback;
  _VM({@required this.state, @required this.callback});
}

class BottomNavigation extends StatelessWidget {
  final List<Map<String, Widget>> items;
  BottomNavigation({@required this.items});

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _VM>(
        converter: (store) => new _VM(
            state: store.state.uiState,
            callback: (index) => store.dispatch(ChangeTabIndexAction(index))),
        builder: (context, vm) {
          return BottomNavigationBar(
            items: items.map((obj) => BottomNavigationBarItem(
                  icon: obj["icon"],
                  title: obj["title"],
                )).toList(),
            currentIndex: vm.state.tabIndex,
            onTap: vm.callback,
          );
        });
  }
}
