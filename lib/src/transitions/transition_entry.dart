import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class TransitionEntry {
  const TransitionEntry({
  //  required this.effect,
    required this.delay,
    required this.duration,
    required this.curve,
  });

  /// The delay for this entry.
  final Duration delay;

  /// The duration for this entry.
  final Duration duration;

  /// The curve used by this entry.
  final Curve curve;

  /// The effect associated with this entry.
 // final TransitionEffect effect;

  /// The begin time for this entry.
  Duration get begin => delay;

  /// The end time for this entry.
  Duration get end => delay + duration;

  Animation<double> buildAnimation(
    AnimationController controller, {
    Curve? curve,
  }) {
    int ttlT = controller.duration?.inMicroseconds ?? 0;
    int beginT = begin.inMicroseconds, endT = end.inMicroseconds;
    return CurvedAnimation(
      parent: controller,
      curve: Interval(beginT / ttlT, endT / ttlT, curve: curve ?? this.curve),
    );
  }
}
