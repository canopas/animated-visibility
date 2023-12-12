import 'package:animated_visibility/src/animated_transition.dart';
import 'package:animated_visibility/src/transitions/enter_transition.dart';
import 'package:animated_visibility/src/transitions/exit_transition.dart';
import 'package:flutter/widgets.dart';

/// AnimatedVisibility is a widget that animate the appearance and disappearance of its content, as [visible] value changes.
/// Different [EnterTransition]s and [ExitTransition]s can be defined in enter and exit for the appearance and disappearance animation.
/// There are 4 types of [EnterTransition] and [ExitTransition]: Fade, Expand/Shrink, Scale and Slide.
/// The enter transitions can be combined using +. Same for exit transitions.
/// The order of the combination does not matter, as the transition animations will start simultaneously.
/// See [EnterTransition] and [ExitTransition] for details on the four types of transition.
///
/// By default, [AnimatedVisibility] will fade in and out its content.
/// params:
/// * [visible] - whether the content should be visible or not
/// * [child] - the widget to apply animated effects to
/// * [enter] - the enter transition to be used, [fadeIn] by default
/// * [exit] - the exit transition to be used, [fadeOut] by default
/// * [enterDuration] - the duration of the enter transition, 500ms by default
/// * [exitDuration] - the duration of the exit transition, 500ms by default
class AnimatedVisibility extends StatefulWidget {
  static final defaultEnterTransition = fadeIn();
  static final defaultExitTransition = fadeOut();
  static const defaultEnterDuration = Duration(milliseconds: 500);
  static const defaultExitDuration = defaultEnterDuration;

  AnimatedVisibility({
    super.key,
    this.visible = true,
    this.child = const SizedBox.shrink(),
    EnterTransition? enter,
    ExitTransition? exit,
    Duration? enterDuration,
    Duration? exitDuration,
  })  : enter = enter ?? defaultEnterTransition,
        exit = exit ?? defaultExitTransition,
        enterDuration = enterDuration ?? defaultEnterDuration,
        exitDuration = exitDuration ?? defaultExitDuration;

  /// Whether the content should be visible or not.
  final bool visible;

  //// The widget to apply animated effects to.
  final Widget child;

  /// The enter transition to be used, [fadeIn] by default.
  final EnterTransition enter;

  /// The exit transition to be used, [fadeOut] by default.
  final ExitTransition exit;

  /// The duration of the enter transition, 500ms by default.
  final Duration enterDuration;

  /// The duration of the exit transition, 500ms by default.
  final Duration exitDuration;

  @override
  State<AnimatedVisibility> createState() => _AnimatedVisibilityState();
}

class _AnimatedVisibilityState extends State<AnimatedVisibility>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      value: widget.visible ? 1.0 : 0.0,
      duration: widget.enterDuration,
      reverseDuration: widget.exitDuration,
      vsync: this,
    )..addStatusListener((AnimationStatus status) {
        setState(() {});
      });

    super.initState();
  }

  @override
  void didUpdateWidget(AnimatedVisibility oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.visible && widget.visible) {
      _controller.forward();
    } else if (oldWidget.visible && !widget.visible) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return AnimatedTransition(
          animation: _controller,
          enterTransition: widget.enter,
          exitTransition: widget.exit,
          child: child,
        );
      },
      child: Visibility(
        visible: _controller.status != AnimationStatus.dismissed,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
