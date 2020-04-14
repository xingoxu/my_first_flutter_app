import 'package:flutter_playground/data/uiState/model.dart';

class AppState {
  UIState uiState;
  AppState({UIState uiState}) : this.uiState = uiState ?? UIState();

  factory AppState.from(AppState originState, {UIState uiState}) {
    var isSame = originState.uiState == uiState;
    return isSame ? originState : AppState(uiState: uiState);
  }
  AppState.clone(AppState state) : this(uiState: state.uiState.clone());

  AppState clone() => AppState.clone(this);
}
