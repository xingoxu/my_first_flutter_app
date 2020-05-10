import 'model.dart';
import 'actions.dart';
import 'package:redux/redux.dart';

Schedule _changeEvent(Schedule state, ChangeEventAction action) {
  // if action.event == state.previousEvent then return;
  final index = state.events.indexOf(action.originEvent);
  return state.clone()
    ..events = List.unmodifiable(
      List.from(state.events)
        ..replaceRange(index, index + 1, [action.newEvent]),
    );
}

Schedule _addEvent(Schedule state, AddEventAction action) {
  return state.clone()
    ..events = List.unmodifiable(
      List.from(state.events)..add(action.event),
    );
}

Schedule _removeEvent(Schedule state, RemoveEventAction action) {
  return state.clone()
    ..events = List.unmodifiable(
      List.from(state.events)..remove(action.event),
    );
}

final scheduleStateReducer = combineReducers<Schedule>([
  TypedReducer<Schedule, ChangeEventAction>(_changeEvent),
  TypedReducer<Schedule, AddEventAction>(_addEvent),
  TypedReducer<Schedule, RemoveEventAction>(_removeEvent),
]);
