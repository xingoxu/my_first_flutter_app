
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:flutter_playground/data/schedule/model.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart' hide Notification;

enum EditEventScreenMode { Add, Edit }

class EditEventScreen extends StatefulWidget {
  EditEventScreen({
    Key key,
    this.scrollController,
    @required this.mode,
    this.event,
  }) : super(key: key);
  final ScrollController scrollController;
  final EditEventScreenMode mode;
  final Event event;
  @override
  State<StatefulWidget> createState() => _EditEventScreenState(
        event: this.event,
      );
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  Event event;

  _EditEventScreenState({this.event}) : super();
  @override
  void initState() {
    event = event?.clone() ?? Event();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = this.event;

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Theme(
          data: ThemeData(
            primaryColor: Colors.white,
          ),
          child: Scaffold(
            primary: false,
            appBar: AppBar(
              title: Text(
                  '${this.widget.mode == EditEventScreenMode.Add ? "Add" : "Edit"} Event'),
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close),
              ),
              actions: <Widget>[
                Transform.scale(
                  scale: 0.6,
                  child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Navigator.pop(context, this.event);
                      }
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                )
              ],
              elevation: 0,
            ),
            body: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _FormRow(
                        right: TextFormField(
                          initialValue: model.title,
                          decoration: const InputDecoration(
                            hintText: 'Enter title',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            model.title = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                      Divider(),
                      _FormRow(
                        icon: Icons.access_time,
                        right: DateTimeField(
                          format: DateFormat("yyyy-MM-dd"),
                          initialValue: model.startTime,
                          onChanged: (value) => model.startTime = value,
                          onShowPicker: (context, currentValue) {
                            return showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter Start Date',
                            border: InputBorder.none,
                          ),
                          validator:
                              _dateValidator('Please select start time.'),
                        ),
                      ),
                      _FormRow(
                        right: DateTimeField(
                          format: DateFormat("yyyy-MM-dd"),
                          initialValue: model.endTime,
                          onChanged: (value) => model.endTime = value,
                          onShowPicker: (context, currentValue) {
                            return showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter End Date',
                            border: InputBorder.none,
                          ),
                          validator: _dateValidator('Please select end time.'),
                        ),
                      ),
                      Divider(),
                      ...(model.notifications).asMap().entries.map((entry) {
                        final index = entry.key;
                        final notification = entry.value;
                        return _FormRow(
                          icon: index == 0 ? Icons.notifications_none : null,
                          right: Row(
                            children: <Widget>[
                              Expanded(
                                child: DateTimeField(
                                  format: DateFormat("yyyy-MM-dd HH:mm"),
                                  initialValue: notification.scheduleTime,
                                  onChanged: (value) =>
                                      notification.scheduleTime = value,
                                  onShowPicker: (context, currentValue) async {
                                    final date = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1900),
                                        initialDate:
                                            currentValue ?? DateTime.now(),
                                        lastDate: DateTime(2100));
                                    if (date == null) return currentValue;
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(
                                          currentValue ?? DateTime.now()),
                                    );
                                    return time != null
                                        ? DateTimeField.combine(date, time)
                                        : null;
                                  },
                                  decoration: const InputDecoration(
                                    hintText:
                                        'Choose when should be notificated',
                                    border: InputBorder.none,
                                  ),
                                  validator: _dateValidator(
                                      'Please choose when should be notificated.'),
                                  resetIcon: null,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    model.removeNotification(notification);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                      FlatButton(
                        padding: EdgeInsets.all(0),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () async {
                          final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: DateTime.now(),
                              lastDate: DateTime(2100));
                          if (date == null) return;
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                          );
                          if (time != null) {
                            setState(() {
                              model.addNotification(
                                  DateTimeField.combine(date, time));
                            });
                          }
                        },
                        child: Padding(
                          padding: model.notifications.length == 0
                              ? EdgeInsets.all(0)
                              : const EdgeInsets.fromLTRB(0, 15, 0, 15),
                          child: _FormRow(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            icon: model.notifications.length == 0
                                ? Icons.notifications_none
                                : null,
                            right: Text(
                              'Add notification',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    color: Theme.of(context).hintColor,
                                  ),
                            ),
                          ),
                        ),
                      ),

                      // Divider(),
                      // TODO: Color Picker
                      Divider(),
                      // TODO: Add Description
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      controller: this.widget.scrollController,
    );

    return Column(
      children: <Widget>[
        // TODO:
        // Row(
        //   children: <Widget>[
        //     Expanded(
        //       child: GestureDetector(
        //         onTap: () {},
        //         child: Transform(
        //             alignment: Alignment.center,
        //             transform: Matrix4.diagonal3Values(4, 1, 1),
        //             child: Icon(Icons.expand_more),
        //           ),
        //       ),
        //     )
        //   ],
        // ),
      ],
    );
  }
}

Function _dateValidator(String errorText) {
  String validator(DateTime value) {
    return value != null ? null : errorText;
  }

  return validator;
}

class _FormRow extends StatelessWidget {
  final IconData icon;
  final Widget right;

  final CrossAxisAlignment crossAxisAlignment;
  final TextBaseline textBaseline;

  _FormRow({
    this.icon,
    this.right,
    this.crossAxisAlignment = CrossAxisAlignment.baseline,
    this.textBaseline = TextBaseline.ideographic,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: this.crossAxisAlignment,
      textBaseline: this.textBaseline,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          // padding: EdgeInsets.fromLTRB(12, 9, 12, 15),
          padding: EdgeInsets.all(15),
          child: Icon(
            this.icon,
            color: Colors.black54,
          ),
        ),
        Expanded(child: this.right),
      ],
    );
  }
}


