class UIState {
  int tabIndex;
  String title;
  UIState({this.tabIndex = 0, this.title = "Home"});
  UIState.clone(UIState state)
      : this(tabIndex: state.tabIndex, title: state.title);

  UIState clone() => UIState.clone(this);
}
