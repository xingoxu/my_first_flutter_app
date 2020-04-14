import 'model.dart';
import 'actions.dart';
import 'package:redux/redux.dart';

UIState _changeTab(UIState state, ChangeTabIndexAction action) {
  if (action.targetIndex == state.tabIndex) return state;
  return state.clone()..tabIndex = action.targetIndex;
}

UIState _changeTitle(UIState state, ChangeAppBarTitleAction action) {
  if (action.targetTitle == state.title) return state;
  return state.clone()..title = action.targetTitle;
}

final uiStateReducer = combineReducers<UIState>([
  TypedReducer<UIState, ChangeTabIndexAction>(_changeTab),
  TypedReducer<UIState, ChangeAppBarTitleAction>(_changeTitle)
]);
