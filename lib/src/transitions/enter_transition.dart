import 'package:animated_visibility/src/transitions/transition_data.dart';
import 'package:flutter/material.dart';

/// EnterTransition defines how an AnimatedVisibility Widget appears on screen as it becomes visible.
/// The 4 categories of EnterTransitions available are:
/// * 1. fade: [fadeIn]
/// * 2. scale: [scaleIn]
/// * 3. slide: [slideIn], [slideInHorizontally], [slideInVertically]
/// * 4. expand: [expandHorizontally], [expandVertically]
///
/// [EnterTransitionNone] can be used when no enter transition is desired.
///
/// Different EnterTransitions can be combined using plus operator
@immutable
abstract class EnterTransition {
  TransitionData get data;

  /// Combines different enter transitions.
  /// * [enter]- another EnterTransition to be combined
  EnterTransition operator +(EnterTransition enter) {
    return EnterTransitionImpl(
      TransitionData(
        opacity: data.opacity ?? enter.data.opacity,
        slide: data.slide ?? enter.data.slide,
        changeSize: data.changeSize ?? enter.data.changeSize,
        scale: data.scale ?? enter.data.scale,
      ),
    );
  }
}

@immutable
class EnterTransitionImpl extends EnterTransition {
  @override
  final TransitionData data;

  EnterTransitionImpl(this.data);
}

/// This can be used when no enter transition is desired.
class EnterTransitionNone extends EnterTransition {
  static final EnterTransitionNone instance = EnterTransitionNone._();

  EnterTransitionNone._();

  @override
  TransitionData get data => const TransitionData();
}

///This fades in the content of the transition, from the specified starting alpha (i.e. initialAlpha) to 1f.
///initialAlpha defaults to 0f, and [Curves.linear] is used by default.
/// Params:
/// * [curve] - the easing curve for this animation, [Curves.linear] by default
/// * [initialAlpha] - the starting alpha of the enter transition, 0f by default
EnterTransition fadeIn({
  double initialAlpha = 0.0,
  Curve curve = Curves.linear,
}) {
  final Animatable<double> fadeInTransition = Tween<double>(
    begin: initialAlpha,
    end: 1.0,
  ).chain(CurveTween(curve: curve));

  return EnterTransitionImpl(
    TransitionData(opacity: fadeInTransition),
  );
}

/// This slides in the content of the transition, from the specified initial offset (i.e. initialOffset) to [Offset.zero].
/// The offset is defined in terms of fractions of the transition's size.
///
/// By default, the content will slide in from the bottom right corner of the transition, and [Curves.linear] is used by default.
///
/// The direction of the slide can be controlled by configuring the initialOffset.
/// A positive x value means sliding from right to left, whereas a negative x value will slide the content to the right.
/// Similarly positive and negative y values correspond to sliding up and down, respectively.
/// If the sliding is only desired horizontally or vertically, instead of along both axis, consider using [slideInHorizontally] or [slideInVertically].
/// Params:
/// * [curve] - the easing curve for this animation, [Curves.linear] by default
/// * [initialOffset] - the starting offset of the enter transition, [Offset(1.0, 1.0)] by default
EnterTransition slideIn({
  Offset initialOffset = const Offset(1.0, 1.0),
  Curve curve = Curves.linear,
}) {
  final slideTransition =
      Tween(begin: initialOffset, end: const Offset(0.0, 0.0))
          .chain(CurveTween(curve: curve));
  return EnterTransitionImpl(
    TransitionData(slide: Slide(initialOffset, slideTransition)),
  );
}

/// This scales in the content of the transition, from the specified initial scale (i.e. initialScale) to 1f.
/// By default, the content will scale in from the center of the transition, and [Curves.linear] is used by default.
///
/// The scaling will change the visual of the content, but will not affect the layout size.
/// [scaleIn] can be combined with [expandHorizontally]/[expandVertically] to coordinate layout size change while scaling.
///
/// Note: Scale is applied before slide.
/// This means when using slideIn/slideOut with scaleIn/scaleOut, the amount of scaling needs to be taken into account when sliding.
/// For example, if the content is scaled by 0.5, then the slide offset needs to be doubled to achieve the same visual effect.
///
/// Params:
/// * [curve] - the easing curve for this animation, [Curves.linear] by default
/// * [initialScale] - the starting scale of the enter transition, 0f by default
/// * [alignment] - the alignment of the content when scaling, [Alignment.center] by default

EnterTransition scaleIn({
  double initialScale = 0.0,
  Alignment alignment = Alignment.center,
  Curve curve = Curves.linear,
}) {
  final Animatable<double> scaleInTransition = Tween<double>(
    begin: initialScale,
    end: 1.0,
  ).chain(CurveTween(curve: curve));

  return EnterTransitionImpl(
    TransitionData(scale: Scale(scaleInTransition, alignment)),
  );
}

/// This slides in the content horizontally, from a starting X defined in terms of fractions of the transition's width.
/// By default, the content will slide in from the right of the transition, and [Curves.linear] is used by default.
///  The direction of the slide can be controlled by configuring the initialOffsetX.
///  A positive value means sliding from right to left, whereas a negative value would slide the content from left to right.
///  Params:
///  * [curve] - the easing curve for this animation, [Curves.linear] by default
///  * [initialOffsetX] - the starting x offset of the enter transition, 1f by default
EnterTransition slideInHorizontally({
  double initialOffsetX = 1.0,
  Curve curve = Curves.linear,
}) {
  return slideIn(initialOffset: Offset(initialOffsetX, 0.0), curve: curve);
}

/// This slides in the content vertically, from a starting offset defined in terms of fractions of the transition's height.
/// By default, the content will slide in from the bottom of the transition, and [Curves.linear] is used by default.
/// The direction of the slide can be controlled by configuring the initialOffsetY.
/// A positive value means sliding from bottom to top, whereas a negative value would slide the content from top to bottom.
/// Params:
/// * [curve] - the easing curve for this animation, [Curves.linear] by default
/// * [initialOffsetY] - the starting y offset of the enter transition, 1f by default
EnterTransition slideInVertically({
  double initialOffsetY = 1.0,
  Curve curve = Curves.linear,
}) {
  return slideIn(initialOffset: Offset(0.0, initialOffsetY), curve: curve);
}

/// This expands the content of the transition, from the specified initial factor (i.e. initialFactor) to 1f in terms of fraction of the transition's height.
/// By default, the content will expand from the center of the transition, and [Curves.linear] is used by default.
/// params:
/// * [initialFactor] - the starting factor of the enter transition, 0f by default
/// * [alignment] - align the child along the axis that [sizeFactor] is modifying.
///               A value of -1.0 indicates the top. A value of 1.0 indicates the bottom.
///               A value of 0.0 (the default) indicates the center.
/// * [curve] - the easing curve for this animation, [Curves.linear] by default
EnterTransition expandVertically({
  double initialFactor = 0.0,
  double alignment = 0.0,
  Curve curve = Curves.linear,
}) {
  final Animatable<double> expandInTransition =
      Tween<double>(begin: initialFactor, end: 1.0)
          .chain(CurveTween(curve: curve));
  return EnterTransitionImpl(
    TransitionData(
        changeSize: ChangeSize(initialFactor = initialFactor,
            expandInTransition, Axis.vertical, alignment)),
  );
}

/// This expands the content of the transition, from the specified initial factor (i.e. initialFactor) to 1f in terms of fraction of the transition's width.
/// By default, the content will expand from the center of the transition, and [Curves.linear] is used by default.
/// params:
/// * [initialFactor] - the starting factor of the enter transition, 0f by default
/// * [alignment] - align the child along the axis that [sizeFactor] is modifying.
///              A value of -1.0 indicates the left. A value of 1.0 indicates the right.
///              A value of 0.0 (the default) indicates the center.
/// * [curve] - the easing curve for this animation, [Curves.linear] by default
EnterTransition expandHorizontally({
  double initialFactor = 0.0,
  double alignment = 0.0,
  Curve curve = Curves.linear,
}) {
  final Animatable<double> expandInTransition =
      Tween<double>(begin: initialFactor, end: 1.0)
          .chain(CurveTween(curve: curve));
  return EnterTransitionImpl(
    TransitionData(
        changeSize: ChangeSize(initialFactor = initialFactor,
            expandInTransition, Axis.horizontal, alignment)),
  );
}
