import 'package:dsg_test/screen_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'lines_constants.dart';
import 'math_services.dart';

class LinesRiverPodModelData {
  ScreenState currentState = ScreenState(
    offsets: [],
    errorMode: false,
    paintMode: true,
  );
  Offset? currentOffset;
  List<Offset> gridPoints = [];
  int gridSpace = kGridSpace;
  bool snapOn = true;
  final snapDistance = kSnapDistance;

  LinesRiverPodModelData({
    this.currentOffset,
  });

  LinesRiverPodModelData.copy(LinesRiverPodModelData other) {
    currentState = other.currentState;
    currentOffset = other.currentOffset;
    gridPoints = List.from(other.gridPoints);
    gridSpace = other.gridSpace;
    snapOn = other.snapOn;
  }
}

class LinesRiverPodModel extends Notifier<LinesRiverPodModelData> {
  void panEndHandler() {
    if (!state.currentState.errorMode) {
      //Snap handle
      if (state.snapOn) {
        for (var gridPoint in state.gridPoints) {
          if ((state.currentOffset! - gridPoint).distance <
              state.snapDistance) {
            state.currentOffset = gridPoint;
            break;
          }
        }
      }
      //State history handle
      ScreenState previousState = ScreenState.clone(state.currentState);
      previousState.nextState = state.currentState;
      state.currentState.prevState = previousState;
      //update canvas handle
      state.currentState.nextState = null;
      if (state.currentOffset != null) {
        double snapThreshhold = kFinalSnapDistance;
        if (state.currentState.offsets.length > 2) {
          if ((state.currentOffset! - state.currentState.offsets.first)
                  .distance
                  .abs() <
              snapThreshhold) {
            state.currentOffset = null;
            if (state.currentState.paintMode) {
              state.currentState.offsets.add(state.currentState.offsets.first);
            }
            state.currentState.paintMode = false;
          }
        }
        if (state.currentOffset != null) {
          if (state.currentState.paintMode) {
            state.currentState.offsets.add(state.currentOffset!);
          }
          state.currentOffset = null;
        }
      }
    }
    state = LinesRiverPodModelData.copy(state);
  }

  void panUpdateHandler(Offset localPosition) {
    state.currentOffset = localPosition;
    bool editMode = false;
    //If thing is complete drag point instead of making a new one
    if (!state.currentState.paintMode) {
      for (int i = 0; i < state.currentState.offsets.length; i++) {
        if ((state.currentState.offsets[i] - state.currentOffset!).distance <
            kFinalSnapDistance) {
          state.currentState.offsets[i] = state.currentOffset!;
          if (i == 0 || i == state.currentState.offsets.length - 1) {
            state.currentState.offsets[0] = state.currentOffset!;
            state.currentState.offsets[state.currentState.offsets.length - 1] =
                state.currentOffset!;
          }
          editMode = true;
          break;
        }
      }
    }
    if (editMode || state.currentState.paintMode) {
      Offset firstPoint = const Offset(0, 0);
      Offset lastPoint = const Offset(0, 0);
      //Draw a line to current point
      if (state.currentState.offsets.isNotEmpty) {
        firstPoint = state.currentState.offsets.first;
        lastPoint = state.currentState.offsets.last;
        int counter = 0;
        for (var offset in state.currentState.offsets) {
          if (MathServices().checkIntersection(
              firstPoint, offset, lastPoint, state.currentOffset!)) {
            state.currentState.errorMode = true;
            break;
          }
          counter += 1;
          firstPoint = offset;
        }
        if (counter == state.currentState.offsets.length) {
          state.currentState.errorMode = false;
        }
      }
    }
    state = LinesRiverPodModelData.copy(state);
  }

  goBack() {
    var nextState = ScreenState.clone(state.currentState);
    state.currentState = ScreenState.clone(state.currentState.prevState!);
    state.currentState.nextState = nextState;
    state = LinesRiverPodModelData.copy(state);
  }

  goForward() {
    state.currentState = state.currentState.nextState!;
    state = LinesRiverPodModelData.copy(state);
  }

  @override
  LinesRiverPodModelData build() {
    return LinesRiverPodModelData();
  }
}

final linesProvider =
    NotifierProvider<LinesRiverPodModel, LinesRiverPodModelData>(() {
  return LinesRiverPodModel();
});
