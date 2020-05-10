import 'package:flutter_playground/data/schedule/model.dart';
import 'package:flutter_playground/utils/io.dart';

abstract class ScheduleStateAction {}

class AddEventAction implements ScheduleStateAction {
  static int _id = 0;
  Event event;
  AddEventAction(this.event) : super() {
    this.event.id = _id.toString();
    _id++;
  }
  static int get id => _id;

  static Future<void> saveAvailableId() async {
    await EventAvailableIdStorage().saveId(_id);
  }

  static Future<void> setAvailableId() async {
    _id = await EventAvailableIdStorage().getSavedId();
  }
}

class RemoveEventAction implements ScheduleStateAction {
  Event event;
  RemoveEventAction(this.event);
}

class ChangeEventAction implements ScheduleStateAction {
  Event originEvent;
  Event newEvent;
  ChangeEventAction(this.originEvent, this.newEvent);
}

class EventAvailableIdStorage extends Storage  {
  String fileName = 'EventAvailableId.txt';
  Future<int> getSavedId() async {
    try {
      return int.parse(await getContent());
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<void> saveId(int id) async {
    await writeContent(id.toString());
  }
}
