import '../state.dart';

class UIState extends ReduxState {
  int tabIndex;
  UIState({this.tabIndex = 0});
  UIState.clone(UIState state)
      : this(tabIndex: state.tabIndex);

  UIState clone() => UIState.clone(this);
}
