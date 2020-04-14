import 'uiState/reducers.dart';

import 'state.dart';

AppState appStateReducer(AppState state, action) {
  return AppState.from(state, uiState: uiStateReducer(state.uiState, action));
}
