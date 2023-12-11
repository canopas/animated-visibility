import 'package:flutter/widgets.dart';

@immutable
class TransitionData {
  final Animatable<double>? opacity;
  final Slide? slide;
  final ChangeSize? changeSize;
  final Scale? scale;

  const TransitionData({
    this.opacity,
    this.slide,
    this.changeSize,
    this.scale,
  });
}

@immutable
class Fade {
  final Animatable<double> animation;

  const Fade(this.animation);
}

@immutable
class Slide {
  final Offset offset;
  final Animatable<Offset> animation;

  const Slide(
    this.offset,
    this.animation,
  );

  Animatable<Offset> updatedAnimation(Offset offset) {
    return Tween<Offset>(
      begin: offset,
      end: offset,
    );
  }
}

@immutable
class ChangeSize {
  final double sizeFactor;
  final Animatable<double> animation;
  final Axis axis;
  final double axisAlignment;

  const ChangeSize(
    this.sizeFactor,
    this.animation,
    this.axis,
    this.axisAlignment,
  );
}

@immutable
class Scale {
  final Animatable<double> animation;
  final Alignment alignment;

  const Scale(this.animation, this.alignment);
}
