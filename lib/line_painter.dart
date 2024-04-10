import 'dart:ui';
import 'package:draw_on_path/draw_on_path.dart';
import 'package:dsg_test/lines_riverpod_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'lines_constants.dart';

class LinesPainter extends CustomPainter {
  List<Offset> offsets;
  List<Offset> grid = [];
  Offset? currentPoint;
  bool errorMode = false;
  WidgetRef ref;

  LinesPainter({
    required this.ref,
    required this.offsets,
    required this.errorMode,
    this.currentPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    grid = ref.read(linesProvider).gridPoints;
    offsets = ref.watch(linesProvider).currentState.offsets;
    //Setup drawers
    final pointPainter = Paint()
      ..color = Colors.white
      ..strokeWidth = kPointWeight;
    final gridPainter = Paint()
      ..color = Colors.blue
      ..strokeWidth = kLineWidth;
    for (var offset in grid) {
      canvas.drawCircle(offset, kGridRadius, gridPainter);
    }
    final linePainter = Paint()
      ..color = Colors.black
      ..strokeWidth = kLineWidth;

    if (offsets.isNotEmpty) {
      var firstPoint = offsets.first;
      //Drawing shape
      for (var offset in offsets) {
        canvas.drawLine(firstPoint, offset, linePainter);
        firstPoint = offset;
      }
      //Drawing filling and lengths
      if (offsets.length > 3 &&
          (offsets.first - offsets.last).distanceSquared == 0) {
        var path = Path();
        Offset? firstOff;
        drawLineLength(firstOff, canvas, path);

        final shapeFiller = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
        canvas.drawPath(path, shapeFiller);
      } else if (currentPoint != null) {
        if (errorMode) {
          linePainter.color = Colors.red;
        }
        canvas.drawLine(firstPoint, currentPoint!, linePainter);
      }
    }
    //Drawing cursor
    if (currentPoint != null) {
      drawPointer(pointPainter, canvas);
    }
    pointPainter.color = Colors.white;

    //Drawing points
    for (var offset in offsets) {
      canvas.drawCircle(offset, kPointRadius + kOuterPointWidth, pointPainter);
    }
    pointPainter.color = Colors.blue;
    for (var offset in offsets) {
      canvas.drawCircle(offset, kPointRadius, pointPainter);
    }
  }

  void drawLineLength(Offset? firstOff, Canvas canvas, Path path) {
    for (var offset in offsets) {
      Path textPath = Path();
      if (firstOff != null) {
        textPath.moveTo(firstOff.dx, firstOff.dy);
        textPath.arcToPoint(firstOff);
        textPath.arcToPoint(offset);
        String distance = "";
        int numOfReps = ((firstOff - offset).distance / 9).floor() - 2;
        for (int i = 0; i < numOfReps; i++) {
          distance += " ";
        }
        distance =
            distance + (firstOff - offset).distance.toStringAsPrecision(3);
        canvas.drawTextOnPath(
          distance,
          textPath,
          textStyle: const TextStyle(
            fontSize: kFontSize,
            color: Colors.blue,
          ),
          textAlignment: TextAlignment.up,
        );
        canvas.drawTextOnPath(
          distance,
          textPath,
          textStyle: const TextStyle(
              fontSize: kFontSize,
              color: Colors.blue,
              fontWeight: FontWeight.w600),
          textAlignment: TextAlignment.bottom,
        );
      }
      path.arcToPoint(offset);
      firstOff = offset;
    }
  }

  void drawPointer(Paint pointPainter, Canvas canvas) {
    pointPainter.color = Colors.blue;

    //TODO change pointer
    canvas.drawCircle(currentPoint!, (12.47 / 2) + 1.77, pointPainter);
    double dist = 30;
    //One
    Offset newDotYM = Offset(currentPoint!.dx, currentPoint!.dy + dist);
    canvas.drawLine(currentPoint!, newDotYM, pointPainter);
    canvas.drawLine(Offset(newDotYM.dx - 1, newDotYM.dy),
        Offset(newDotYM.dx + 10, newDotYM.dy - 6), pointPainter);
    canvas.drawLine(Offset(newDotYM.dx + 1, newDotYM.dy),
        Offset(newDotYM.dx - 10, newDotYM.dy - 6), pointPainter);
    //Two
    Offset newDotYP = Offset(currentPoint!.dx, currentPoint!.dy - dist);
    canvas.drawLine(currentPoint!, newDotYP, pointPainter);
    canvas.drawLine(Offset(newDotYP.dx - 1, newDotYP.dy),
        Offset(newDotYP.dx + 10, newDotYP.dy + 6), pointPainter);
    canvas.drawLine(Offset(newDotYP.dx + 1, newDotYP.dy),
        Offset(newDotYP.dx - 10, newDotYP.dy + 6), pointPainter);
    //Three
    Offset newDotXM = Offset(currentPoint!.dx - dist, currentPoint!.dy);
    canvas.drawLine(currentPoint!, newDotXM, pointPainter);
    canvas.drawLine(Offset(newDotXM.dx, newDotXM.dy - 1),
        Offset(newDotXM.dx + 6, newDotXM.dy + 10), pointPainter);
    canvas.drawLine(Offset(newDotXM.dx, newDotXM.dy + 1),
        Offset(newDotXM.dx + 6, newDotXM.dy - 10), pointPainter);

    //Four
    Offset newDotXP = Offset(currentPoint!.dx + dist, currentPoint!.dy);
    canvas.drawLine(currentPoint!, newDotXP, pointPainter);
    canvas.drawLine(Offset(newDotXP.dx, newDotXP.dy - 1),
        Offset(newDotXP.dx - 6, newDotXP.dy + 10), pointPainter);
    canvas.drawLine(Offset(newDotXP.dx, newDotXP.dy + 1),
        Offset(newDotXP.dx - 6, newDotXP.dy - 10), pointPainter);
    pointPainter.color = Colors.white;
    canvas.drawCircle(currentPoint!, 12.47 / 2, pointPainter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
