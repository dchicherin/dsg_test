import 'dart:ui';
import 'package:dsg_test/lines_riverpod_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'buttons.dart';
import 'line_painter.dart';
import 'package:dsg_test/screen_state.dart';
import 'package:flutter/material.dart';

import 'lines_constants.dart';

class LinesPage extends ConsumerWidget {
  final gridSpace = kGridSpace;
  bool snapOn = true;
  final snapDistance = kSnapDistance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    int numOfRows = (screenHeight / gridSpace).floor();
    int numOfColumns = (screenWidth / gridSpace).floor();

    //Grid layout based on screen params
    final List<Offset> gridPoints = [];
    for (int i = 1; i < numOfRows; i++) {
      for (int j = 1; j < numOfColumns; j++) {
        gridPoints
            .add(Offset(j * gridSpace.toDouble(), i * gridSpace.toDouble()));
      }
    }
    ref.read(linesProvider).gridPoints = gridPoints;
    ScreenState currentState = ref.watch(linesProvider).currentState;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            //Drawing area
            GestureDetector(
              onPanStart: (details) {
                ref
                    .read(linesProvider.notifier)
                    .panUpdateHandler(details.localPosition);
              },
              onPanUpdate: (details) {
                ref
                    .watch(linesProvider.notifier)
                    .panUpdateHandler(details.localPosition);
              },
              onPanEnd: (details) {
                ref.watch(linesProvider.notifier).panEndHandler();
              },
              child: Container(
                color: kBGColor,
                child: CustomPaint(
                  painter: LinesPainter(
                    ref: ref,
                    offsets: currentState.offsets,
                    currentPoint: ref.watch(linesProvider).currentOffset,
                    errorMode: currentState.errorMode,
                  ),
                  child: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            //Buttons panel
            Padding(
              padding: const EdgeInsets.all(kPanelPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UndoRedoButtons(
                    currentState: currentState,
                    ref: ref,
                  ),
                  SnapButton(
                    ref: ref,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
