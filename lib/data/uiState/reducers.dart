import 'model.dart';
import 'actions.dart';
import 'package:redux/redux.dart';

UIState _changeTab(UIState state, ChangeTabIndexAction action) {
  if (action.targetIndex == state.tabIndex) return state;
  return state.clone()..tabIndex = action.targetIndex;
}

final uiStateReducer = combineReducers<UIState>([
  TypedReducer<UIState, ChangeTabIndexAction>(_changeTab),
]);
