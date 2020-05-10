// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_playground/pages/addEvent/index.dart';
import 'package:flutter_playground/utils/io.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'data/reducers.dart';
import 'pages/root/index.dart';
import 'data/state.dart';
import 'utils/initNotifications.dart';

// TODO
// https://pub.dev/packages/flutter_statusbarcolor
// https://github.com/flutter/flutter/issues/24472#issuecomment-440015464

void main() async {
  await Future.wait([
    restoreStorage(),
    initNotification(),
  ]);
  final store = new Store<AppState>(
    appStateReducer,
    initialState: await AppState.fromStorage(),
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
          initialRoute: '/',
          routes: {
            '/': (context) => Home(),
            // TODO: should define a onGenerateRoute to handle popupRoute/route setting here
            '/addEvent': (context) => EditEventScreen(
                  mode: EditEventScreenMode.Add,
                )
          },
        ));
  }
}
