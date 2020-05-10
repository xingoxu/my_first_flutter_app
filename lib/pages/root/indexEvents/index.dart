import 'dart:convert';

import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_playground/components/mainView.dart';
import 'package:flutter_playground/data/schedule/actions.dart';
import 'package:flutter_playground/data/schedule/model.dart';
import 'package:flutter_playground/data/state.dart' hide ReduxState;
import 'package:flutter_playground/data/uiState/actions.dart';
import 'package:flutter_playground/pages/addEvent/index.dart';
import 'package:flutter_playground/utils/initNotifications.dart';
import 'package:flutter_playground/utils/io.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart' show DateFormat;

class IndexScheduleListWidget extends StatefulWidget implements MainView {
  @override
  State<IndexScheduleListWidget> createState() => IndexScheduleListState();

  IndexScheduleListWidget({@required this.tabIndex}) : super();
  @override
  final int tabIndex;
}

class IndexScheduleListState extends State<IndexScheduleListWidget> {
  final String title = "Schedule";
  IndexScheduleListState() : super();

  @override
  void initState() {
    super.initState();
    selectNotificationSubject.stream.listen((String payload) async {
      // await
      final store = StoreProvider.of<AppState>(context);
      print('test');
      print(payload);
      final eventCopy = Event.fromJson(jsonDecode(payload));
      final findEvent = store.state.schedule.events
          .where((event) => event.id == eventCopy.id)
          .toList();
      if (findEvent.length <= 0) return;

      store.dispatch(ChangeTabIndexAction(this.widget.tabIndex));
      showEditEventScreen(store, findEvent[0]);
    });
  }

  String formatNumber(int number) {
    return number.toString().padLeft(2, '0');
  }

  String formatDate(DateTime dt) {
    return '${dt.year}-${formatNumber(dt.month)}-${formatNumber(dt.day)} ${formatNumber(dt.hour)}:${formatNumber(dt.minute)}:${formatNumber(dt.second)}';
  }

  Future<void> showEditEventScreen(Store<AppState> store, Event event) async {
    Event eventEdited = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.9,
          builder: (context, scrollController) => ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            child: EditEventScreen(
              scrollController: scrollController,
              mode: EditEventScreenMode.Edit,
              event: event,
            ),
          ),
        );
      },
    );
    if (eventEdited == null) return;
    event?.notifications?.forEach((notification) {
      flutterLocalNotificationsPlugin.cancel(notification.id);
    });
    eventEdited.notifications?.forEach((notification) {
      _scheduleNotification(notification, eventEdited);
      // _scheduleNotification();
    });
    store.dispatch(ChangeEventAction(event, eventEdited));
    store.state.saveToStorage();
    saveStorage();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, vm) {
        final events = vm.state.schedule.events;
        return Scaffold(
          appBar: AppBar(
            title: Text(this.title),
          ),
          body: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, i) {
                // if (i.isOdd) return Divider();
                // final index = i ~/ 2;
                final index = i;
                final _endTimeDate = events[index].endTime.toLocal();
                return GestureDetector(
                  child: Card(
                    child: ListTile(
                      title: Text(events[index].title),
                      subtitle: Text(formatDate(_endTimeDate)),
                    ),
                  ),
                  onTap: () => showEditEventScreen(vm, events[index]),
                );
              }),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Event eventAdded = await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return DraggableScrollableSheet(
                    expand: false,
                    maxChildSize: 0.9,
                    builder: (context, scrollController) => ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                      ),
                      child: EditEventScreen(
                        scrollController: scrollController,
                        mode: EditEventScreenMode.Add,
                      ),
                    ),
                  );
                },
              );
              if (eventAdded == null) return;
              // Navigator.pushNamed(context, '/addEvent');
              vm.dispatch(AddEventAction(
                eventAdded..id = AddEventAction.id.toString(),
              ));
              eventAdded.notifications?.forEach((notification) {
                _scheduleNotification(notification, eventAdded);
                // _scheduleNotification();
              });
              vm.state.saveToStorage();
              saveStorage();
            },
            child: Icon(Icons.playlist_add),
          ),
        );
      },
    );
  }
}

class _VM {
  Schedule state;
  Function handler;
  _VM({this.state, this.handler});
}

Future<void> _scheduleNotification(
    Notification notification, Event event) async {
  DateTime scheduledNotificationDateTime = notification.scheduleTime;

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'CHANNEL_ID',
    'Calendar Notification',
    'Calendar Notification which set by yourself',
    priority: Priority.High,
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
    androidPlatformChannelSpecifics,
    iOSPlatformChannelSpecifics,
  );

  // await flutterLocalNotificationsPlugin.show(
  //     0, 'plain title', 'plain body', platformChannelSpecifics,
  //     payload: 'item x');
  await flutterLocalNotificationsPlugin.schedule(
    notification.id,
    event.title,
    DateFormat("yyyy-MM-dd HH:mm").format(scheduledNotificationDateTime),
    scheduledNotificationDateTime,
    platformChannelSpecifics,
    payload: jsonEncode(event.toJson()),
  );
}
