import 'package:animated_visibility_widget/src/transitions/transition_data.dart';
import 'package:flutter/material.dart';

/// ExitTransition defines how an AnimatedVisibility Widget disappears from screen as it becomes invisible.
/// The 4 categories of ExitTransitions available are:
///   1. fade: [fadeOut]
///   2. scale: [scaleOut]
///   3. slide: [slideOut], [slideOutHorizontally], [slideOutVertically]
///   4. shrink: [shrinkHorizontally], [shrinkVertically]
///
/// [ExitTransitionNone] can be used when no exit transition is desired.
///
/// Different ExitTransitions can be combined using plus operator
@immutable
abstract class ExitTransition {
  TransitionData get data;

  /// Combines different exit transitions.
  ExitTransition operator +(ExitTransition exit) {
    return ExitTransitionImpl(
      TransitionData(
        opacity: data.opacity ?? exit.data.opacity,
        slide: data.slide ?? exit.data.slide,
        changeSize: data.changeSize ?? exit.data.changeSize,
        scale: data.scale ?? exit.data.scale,
      ),
    );
  }
}

class ExitTransitionImpl extends ExitTransition {
  @override
  final TransitionData data;

  ExitTransitionImpl(this.data);
}

/// This can be used when no exit transition is desired.
/// Note: If None is used, and nothing is animating in the Transition scope that AnimatedVisibility provided,
/// the content will be removed from AnimatedVisibility right away.
class ExitTransitionNone extends ExitTransition {
  static final ExitTransitionNone instance = ExitTransitionNone._();

  ExitTransitionNone._();

  @override
  TransitionData get data => const TransitionData();
}

/// This fades out the content of the transition, from full opacity to the specified target alpha (i.e. targetAlpha).
/// By default, the content will be faded out to fully transparent (i.e. targetAlpha defaults to 0), and [Curves.linear] is used by default.
/// Params:
/// * [curve] - the easing curve for this animation, [Curves.linear] by default
/// * [targetAlpha] - the starting alpha of the exit transition, 1f by default
ExitTransition fadeOut({
  double targetAlpha = 0.0,
  Curve curve = Curves.linear,
}) {
  final Animatable<double> fadeOutTransition = Tween<double>(
    begin: 1.0,
    end: targetAlpha,
  ).chain(CurveTween(curve: curve));

  return ExitTransitionImpl(
    TransitionData(opacity: fadeOutTransition),
  );
}

/// This slides out the content of the transition, from an offset of IntOffset(0, 0) to the target offset defined in targetOffset.
/// The offset is defined in terms of fractions of the transition's size.
/// By default, the content will slide out to the bottom right corner of the transition, and [Curves.linear] is used by default.
///
/// The direction of the slide can be controlled by configuring the targetOffset.
/// Fa positive x value corresponds to sliding to the right, and a negative x value corresponds to sliding to the left.
/// Similarly, a positive y value corresponds to sliding down, and a negative y value corresponds to sliding up.
/// If the sliding is only desired horizontally or vertically, instead of along both axis, consider using [slideOutVertically] or [slideOutVertically].
ExitTransition slideOut({
  Offset targetOffset = const Offset(1.0, 1.0),
  Curve curve = Curves.linear,
}) {
  final slideTransition =
      Tween(begin: const Offset(0.0, 0.0), end: targetOffset)
          .chain(CurveTween(curve: curve));
  return ExitTransitionImpl(
    TransitionData(slide: Slide(targetOffset, slideTransition)),
  );
}

/// This scales out the content of the transition, from full scale to the specified target scale (i.e. targetScale).
/// By default, the content will be scaled out to 0f, and [Curves.linear] is used by default.
///
/// The scaling will change the visual of the content, but will not affect the layout size.
/// [scaleOut] can be combined with [shrinkHorizontally]/[shrinkVertically] to coordinate layout size change while scaling.
///
/// Note: Scale is applied before slide.
/// This means when using slideIn/slideOut with scaleIn/scaleOut, the amount of scaling needs to be taken into account when sliding.
/// params:
/// * [targetScale] - the target scale of the exit transition, 0f by default
/// * [alignment] - the alignment of the scale, [Alignment.center] by default
/// * [curve] - the easing curve for this animation, [Curves.linear] by default

ExitTransition scaleOut({
  double targetScale = 0.0,
  Alignment alignment = Alignment.center,
  Curve curve = Curves.linear,
}) {
  final Animatable<double> scaleOutTransition = Tween<double>(
    begin: 1.0,
    end: targetScale,
  ).chain(CurveTween(curve: curve));

  return ExitTransitionImpl(
    TransitionData(scale: Scale(scaleOutTransition, alignment)),
  );
}

/// This slide out content horizontally, to the target x defined in terms of fractions of the transition's width.
/// By default, the content will slide out to the right, and [Curves.linear] is used by default.
/// The direction of the slide can be controlled by configuring the targetOffsetX.
/// A positive value means sliding to the right, whereas a negative value would slide the content towards the left.
/// params:
/// * [targetOffsetX] - the target x of the exit transition, 1f by default
/// * [curve] - the easing curve for this animation, [Curves.linear] by default
ExitTransition slideOutHorizontally({
  double targetOffsetX = 1.0,
  Curve curve = Curves.linear,
}) {
  return slideOut(targetOffset: Offset(targetOffsetX, 0.0), curve: curve);
}

/// This slide out content vertically, to the targetOffset y defined in terms of fractions of the transition's height.
/// By default, the content will slide out to the bottom, and [Curves.linear] is used by default.
/// The direction of the slide can be controlled by configuring the targetOffsetY.
/// A positive value means sliding down, whereas a negative value would slide the content upwards.
/// params:
/// * [targetOffsetY] - the target y of the exit transition, 1f by default
/// * [curve] - the easing curve for this animation, [Curves.linear] by default
ExitTransition slideOutVertically({
  double targetOffsetY = 1.0,
  Curve curve = Curves.linear,
}) {
  return slideOut(targetOffset: Offset(0.0, targetOffsetY), curve: curve);
}

/// This shrinks out the content of the transition, to targetFactor defined in terms of fraction of the transition's height.
/// By default, the content will shrink out to 0f, and [Curves.linear] is used by default.
/// params:
/// * [targetFactor] - the target factor of the exit transition, 0f by default
/// * [alignment] - align the child along the axis that [sizeFactor] is modifying.
///               A value of -1.0 indicates the top. A value of 1.0 indicates the bottom.
///               A value of 0.0 (the default) indicates the center.
/// * [curve] - the easing curve for this animation, [Curves.linear] by default
ExitTransition shrinkVertically({
  double targetFactor = 0.0,
  double alignment = 0.0,
  Curve curve = Curves.linear,
}) {
  final Animatable<double> shrinkTransition =
      Tween<double>(begin: 1.0, end: targetFactor)
          .chain(CurveTween(curve: curve));
  return ExitTransitionImpl(
    TransitionData(
        changeSize: ChangeSize(
            targetFactor, shrinkTransition, Axis.vertical, alignment)),
  );
}

/// This shrinks out the content of the transition, to targetFactor defined in terms of fraction of the transition's width.
/// By default, the content will shrink out to 0f, and [Curves.linear] is used by default.
/// params:
/// * [targetFactor] - the target factor of the exit transition, 0f by default
/// * [alignment] - align the child along the axis that [sizeFactor] is modifying.
///              A value of -1.0 indicates the left. A value of 1.0 indicates the right.
///              A value of 0.0 (the default) indicates the center.
/// * [curve] - the easing curve for this animation, [Curves.linear] by default
ExitTransition shrinkHorizontally({
  double targetFactor = 0.0,
  double alignment = 0.0,
  Curve curve = Curves.linear,
}) {
  final Animatable<double> shrinkTransition =
      Tween<double>(begin: 1.0, end: targetFactor)
          .chain(CurveTween(curve: curve));
  return ExitTransitionImpl(
    TransitionData(
        changeSize: ChangeSize(
            targetFactor, shrinkTransition, Axis.horizontal, alignment)),
  );
}
