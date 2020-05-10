import 'schedule/reducers.dart';
import 'uiState/reducers.dart';
import 'state.dart';

AppState appStateReducer(AppState state, action) => AppState(
      uiState: uiStateReducer(state.uiState, action),
      schedule: scheduleStateReducer(state.schedule, action),
    );
