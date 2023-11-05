import 'package:flutter/widgets.dart';

class AppScrollBehavior extends ScrollBehavior {
  const AppScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    // no ripple
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
