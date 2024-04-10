import 'dart:ui';
import 'package:dsg_test/lines_riverpod_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dsg_test/screen_state.dart';
import 'package:flutter/material.dart';
import 'lines_constants.dart';

//Undo and redo buttons
class UndoRedoButtons extends StatelessWidget {
  UndoRedoButtons({
    super.key,
    required this.currentState,
    required this.ref,
  });
  WidgetRef ref;

  final ScreenState currentState;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kUnRedoWidth,
      height: kUnRedoHeight,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(kUnRedoBorder)),
        color: kButtonColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //Undo
          IconButton(
            onPressed: currentState.prevState != null
                ? () {
                    ref.read(linesProvider.notifier).goBack();
                  }
                : null,
            icon: Transform.flip(
              flipX: true,
              child: SvgPicture.asset(
                "assets/arrow.svg",
                colorFilter: currentState.prevState != null
                    ? ColorFilter.mode(Colors.grey.shade600, BlendMode.srcIn)
                    : ColorFilter.mode(Colors.grey.shade300, BlendMode.srcIn),
                width: kURIconSize,
                height: kURIconSize,
              ),
            ),
          ),
          kDivider,
          //Redo
          IconButton(
            onPressed: currentState.nextState != null
                ? () {
                    ref.read(linesProvider.notifier).goForward();
                  }
                : null,
            icon: SvgPicture.asset(
              "assets/arrow.svg",
              colorFilter: currentState.nextState != null
                  ? ColorFilter.mode(Colors.grey.shade600, BlendMode.srcIn)
                  : ColorFilter.mode(Colors.grey.shade300, BlendMode.srcIn),
              width: kURIconSize,
              height: kURIconSize,
            ),
          ),
        ],
      ),
    );
  }
}

//Button to
class SnapButton extends StatelessWidget {
  SnapButton({
    super.key,
    required this.ref,
  });
  WidgetRef ref;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: kSnapButtonSize,
      height: kSnapButtonSize,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(kSnapButtonSize / 2)),
        color: kButtonColor,
      ),
      child: IconButton(
        onPressed: () {
          ref.read(linesProvider).snapOn = !ref.read(linesProvider).snapOn;
        },
        icon: SvgPicture.asset(
          "assets/Vector.svg",
          colorFilter: ref.watch(linesProvider).snapOn == true
              ? const ColorFilter.mode(Colors.grey, BlendMode.srcIn)
              : ColorFilter.mode(Colors.grey.shade400, BlendMode.srcIn),
          width: kSnapIconSize,
          height: kSnapIconSize,
        ),
      ),
    );
  }
}
