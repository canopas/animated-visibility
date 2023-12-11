# Flutter Animated Visibility Widget

Animate appearance and disappearance using pre-built effects with the AnimatedVisibility widget.

<img src="https://raw.githubusercontent.com/canopas/animated-visibility-widget/main/gif/gif1.gif" height="540" /> <img src="https://raw.githubusercontent.com/canopas/animated-visibility-widget/main/gif/gif2.gif" height="540" />

# Getting Started
In the pubspec.yaml of your flutter project, add the following dependency:
```
dependencies:
  animated_visibility_widget: <latest_version>
```
In your library add the following import:

```
import 'package:animated_visibility_widget/animated_visibility_widget.dart';
```

### Basic usage
```
      AnimatedVisibility(
        visible: _isShow,
        enter: fadeIn() + scaleIn(),
        exit: fadeOut() + slideOutHorizontally(),
        child: <content to show/hide>,
      );
```

# Demo
[Sample](https://github.com/canopas/animated-visibility-widget/tree/main/example) app demonstrates how simple the usage of the library actually is.

# Bugs and Feedback
For bugs, questions and discussions please use the [Github Issues](https://github.com/canopas/animated-visibility-widget/issues).

# Credits

`animated_visibility` is owned and maintained by the [Canopas team](https://canopas.com/). You can follow them on Twitter at [@canopassoftware](https://twitter.com/canopassoftware) for project updates and releases.

