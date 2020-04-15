abstract class UIStateAction {}

class ChangeTabIndexAction implements UIStateAction {
  int targetIndex;
  ChangeTabIndexAction(this.targetIndex);
}

