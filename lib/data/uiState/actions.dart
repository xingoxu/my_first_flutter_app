abstract class UIStateAction {}

class ChangeTabIndexAction implements UIStateAction {
  int targetIndex;
  ChangeTabIndexAction(this.targetIndex);
}

class ChangeAppBarTitleAction implements UIStateAction {
  String targetTitle;
  ChangeAppBarTitleAction(this.targetTitle);
}
