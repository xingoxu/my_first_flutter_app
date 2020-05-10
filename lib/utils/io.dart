import 'dart:io';
import 'package:flutter_playground/data/schedule/actions.dart';
import 'package:flutter_playground/data/schedule/model.dart';
import 'package:path_provider/path_provider.dart';

abstract class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  String fileName;

  Future<File> get _localFile async {
    final path = await _localPath;
    print('$path/$fileName');
    return File('$path/$fileName');
  }

  Future<File> writeContent(String content) async {
    final file = await _localFile;

    // Write the file.
    return file.writeAsString(content);
  }

  Future<String> getContent() async {
    final file = await _localFile;

    // Read the file.
    return await file.readAsString();
  }
}

Future<void> saveStorage() {
  return Future.wait([
    Notification.saveAvailableId(),
    AddEventAction.saveAvailableId(),
  ]);
}

Future<void> restoreStorage() {
  return Future.wait([
    Notification.setAvailableId(),
    AddEventAction.setAvailableId(),
  ]);
}
