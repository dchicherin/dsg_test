import 'dart:ui';

class ScreenState {
  List<Offset> offsets = [];
  Offset? currentPoint;
  bool errorMode = false;
  bool paintMode = true;
  ScreenState? prevState;
  ScreenState? nextState;
  //Cloning for keeping track of history
  ScreenState.clone(ScreenState screenState) {
    offsets = List.from(screenState.offsets);
    currentPoint = screenState.currentPoint;
    errorMode = screenState.errorMode;
    paintMode = screenState.paintMode;
    prevState = screenState.prevState;
    nextState = screenState.nextState;
  }
  //regular constructor
  ScreenState({
    required this.offsets,
    this.currentPoint,
    required this.errorMode,
    required this.paintMode,
    this.nextState,
    this.prevState,
  });
}
