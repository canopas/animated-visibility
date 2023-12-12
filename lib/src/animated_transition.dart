import 'package:animated_visibility/src/transitions/enter_transition.dart';
import 'package:animated_visibility/src/transitions/exit_transition.dart';
import 'package:animated_visibility/src/transitions/transition_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimatedTransition extends StatelessWidget {
  const AnimatedTransition({
    super.key,
    required this.animation,
    required this.enterTransition,
    required this.exitTransition,
    this.child,
  });

  /// The animation that drives the [child]'s entrance and exit.
  final Animation<double> animation;

  /// The widget below this widget in the tree.
  ///
  /// This widget will transition in and out as driven by [animation]
  final Widget? child;

  /// [EnterTransition](s) used for the appearing animation, fading in by default
  final EnterTransition enterTransition;

  /// [ExitTransition](s) used for the disappearing animation, fading out by default
  final ExitTransition exitTransition;

  @override
  Widget build(BuildContext context) {
    return DualTransitionBuilder(
      animation: animation,
      forwardBuilder: (
        BuildContext context,
        Animation<double> animation,
        Widget? child,
      ) {
        return _build(context, child, animation, enterTransition.data) ??
            const SizedBox.shrink();
      },
      reverseBuilder: (
        BuildContext context,
        Animation<double> animation,
        Widget? child,
      ) {
        return _build(context, child, animation, exitTransition.data) ??
            const SizedBox.shrink();
      },
      child: child,
    );
  }

  Widget? _build(BuildContext context, Widget? child,
      Animation<double> animation, TransitionData data) {
    Widget? animatedChild = child;

    if (data.scale != null) {
      var scale = data.scale!.animation.animate(animation);
      animatedChild = ScaleTransition(
        scale: scale,
        alignment: data.scale!.alignment,
        child: animatedChild,
      );
    }

    if (data.changeSize != null) {
      final changeSize = data.changeSize!;
      animatedChild = SizeTransition(
        sizeFactor: changeSize.animation.animate(animation),
        axis: changeSize.axis,
        axisAlignment: changeSize.axisAlignment,
        child: animatedChild,
      );
    }

    if (data.slide != null) {
      animatedChild = SlideTransition(
        position: data.slide!.animation.animate(animation),
        child: animatedChild,
      );
    }

    if (data.opacity != null) {
      final fade = data.opacity!;
      animatedChild = FadeTransition(
        opacity: fade.animate(animation),
        child: animatedChild,
      );
    }

    return animatedChild;
  }
}
