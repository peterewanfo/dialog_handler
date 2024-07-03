import 'package:flutter/material.dart';

class Animations {
  /// fade dialog while dialog slide from right to position
  static Widget fadeFromRightToPosition(
    Animation<double> animation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.2, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.ease,
          ),
        ),
        child: child,
      ),
    );
  }

  /// fade dialog while dialog slide from left to position
  static Widget fadeFromLeftToPosition(
    Animation<double> animation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.2, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.ease,
          ),
        ),
        child: child,
      ),
    );
  }

  /// fade dialog while dialog slide from top to position
  static Widget fadeFromTopToPosition(
    Animation<double> animation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.2),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.ease,
          ),
        ),
        child: child,
      ),
    );
  }

  /// fade dialog while dialog slide from bottom to position
  static Widget fadeFromBottomToPosition(
    Animation<double> animation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.ease,
          ),
        ),
        child: child,
      ),
    );
  }

  /// slide dialog from right to position
  static Widget fromRightToPosition(
    Animation<double> animation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.ease,
        ),
      ),
      child: child,
    );
  }

  /// slide dialog from left to position
  static Widget fromLeftToPosition(
    Animation<double> animation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.ease,
        ),
      ),
      child: child,
    );
  }

  /// slide dialog from top to position
  static Widget fromTopToPosition(
    Animation<double> animation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.ease,
        ),
      ),
      child: child,
    );
  }

  /// slide dialog from bottom to position
  static Widget fromBottomToPosition(
    Animation<double> animation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.ease,
        ),
      ),
      child: child,
    );
  }

  /// slide dialog from top to position then bounce
  static Widget fromTopToPositionThenBounce(
    Animation<double> animation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.elasticOut,
          reverseCurve: Curves.linearToEaseOut,
        ),
      ),
      child: child,
    );
  }

  /// slide dialog from bottom to position then bounce
  static Widget fromBottomToPositionThenBounce(
    Animation<double> animation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.elasticOut,
          reverseCurve: Curves.linearToEaseOut,
        ),
      ),
      child: child,
    );
  }

  /// scale dialog to position
  static Widget scaleToPosition(
    Animation<double> animation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: animation,
      child: FadeTransition(
        opacity: Tween<double>(
          begin: 0.5,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.ease,
          ),
        ),
        child: child,
      ),
    );
  }
}
