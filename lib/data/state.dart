import 'dart:convert';

import 'package:flutter_playground/data/schedule/model.dart';
import 'package:flutter_playground/data/uiState/model.dart';
import 'package:flutter_playground/utils/io.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

abstract class ReduxState {
  ReduxState clone();
}

@JsonSerializable(explicitToJson: true)
class AppState extends ReduxState {
  @JsonKey(ignore: true)
  UIState uiState;
  Schedule schedule;
  AppState({UIState uiState, Schedule schedule})
      : this.uiState = uiState ?? UIState(),
        this.schedule = schedule ?? Schedule();

  AppState.clone(AppState state) : this(uiState: state.uiState.clone());
  @override
  AppState clone() => AppState.clone(this);

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);

  Map<String, dynamic> toJson() => _$AppStateToJson(this);

  static Future<AppState> fromStorage() async => StateStorage().readState();

  @override
  String toString() => jsonEncode(this.toJson());

  void saveToStorage() {
    _storage.writeState(this);
  }

  StateStorage _storage = StateStorage();
}

class StateStorage extends Storage {
  String fileName = 'state.txt';
  Future<AppState> readState() async {
    try {
      return AppState.fromJson(jsonDecode(await getContent()));
    } catch (e) {
      print(e);
      return AppState();
    }
  }

  Future<void> writeState(AppState state) async {
    await writeContent(state.toString());
  }
}
