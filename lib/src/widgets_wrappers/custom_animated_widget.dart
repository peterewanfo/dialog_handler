import 'dart:async';
import 'package:flutter/material.dart';

import '../models/_export_.dart';
import '../utils/_export_.dart';
import '../utils/animations.dart';
import '../dialog_listener.dart';

class CustomAnimatedWidget extends StatefulWidget {
  final Widget widget;
  final AnimationType? animationType;
  final DialogConfig dialogConfig;
  final Function() onDismissal;
  const CustomAnimatedWidget({
    super.key,
    required this.widget,
    required this.dialogConfig,
    required this.onDismissal,
    this.animationType,
  });

  @override
  State<CustomAnimatedWidget> createState() => _CustomAnimatedWidgetState();
}

class _CustomAnimatedWidgetState extends State<CustomAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  Timer? _timer;

  void _reverseAnimationOnDismiss() {
    if (mounted) {
      if (dialogListener.config != null) {
        if (dialogListener.config!.dialogCompleterInstance ==
            widget.dialogConfig.dialogCompleterInstance) {
          if (widget.dialogConfig.autoDismissWithAnimation == true) {
            _animationController.reverse();
            // _animationController.animateBack(0, duration: Duration.zero);
          } else {
            // _animationController.reverse();
            _animationController.animateBack(0, duration: Duration.zero);
          }
          _animationController.addStatusListener(
            (status) {
              if (status == AnimationStatus.dismissed) {
                widget.onDismissal.call();
                dialogListener.animatedDismissalCompleted();
              }
            },
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    dialogListener.addListener(
      DialogListenerKeys.dismissDialog.name,
      _reverseAnimationOnDismiss,
    );

    _animationController = AnimationController(
      vsync: this,
      duration: widget.dialogConfig.animationDuration ??
          const Duration(milliseconds: 1200),
      reverseDuration: widget.dialogConfig.animationReverseDuration,
    );
    _animationController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          if (widget.dialogConfig.autoDismissalDuration != null) {
            _timer = Timer(widget.dialogConfig.autoDismissalDuration!, () {
              if (mounted) {
                if (widget.dialogConfig.autoDismissalDuration != null) {
                  _animationController.reverse();
                }
              }
            });
          }else{
            _animationController.reverse();
          }
        }
        if (status == AnimationStatus.dismissed) {
          _timer?.cancel();
          widget.onDismissal.call();
          dialogListener.animatedDismissalCompleted();
        }
      },
    );

    if (mounted) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    dialogListener.removeListener(DialogListenerKeys.dismissDialog.name);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.animationType) {
      case AnimationType.scaleToPosition:
        return Animations.scaleToPosition(
          _animationController,
          widget.widget,
        );
      case AnimationType.fadeFromLeftToPosition:
        return Animations.fadeFromLeftToPosition(
          _animationController,
          widget.widget,
        );
      case AnimationType.fadeFromRightToPosition:
        return Animations.fadeFromRightToPosition(
          _animationController,
          widget.widget,
        );
      case AnimationType.fadeFromBottomToPosition:
        return Animations.fadeFromBottomToPosition(
          _animationController,
          widget.widget,
        );
      case AnimationType.fadeFromTopToPosition:
        return Animations.fadeFromTopToPosition(
          _animationController,
          widget.widget,
        );
      case AnimationType.fromTopToPosition:
        return Animations.fromTopToPosition(
          _animationController,
          widget.widget,
        );
      case AnimationType.fromLeftToPosition:
        return Animations.fromLeftToPosition(
          _animationController,
          widget.widget,
        );
      case AnimationType.fromRightToPosition:
        return Animations.fromRightToPosition(
          _animationController,
          widget.widget,
        );
      case AnimationType.fromBottomToPosition:
        return Animations.fromBottomToPosition(
          _animationController,
          widget.widget,
        );

      case AnimationType.fromTopToPositionThenBounce:
        return Animations.fromTopToPositionThenBounce(
          _animationController,
          widget.widget,
        );

      case AnimationType.fromBottomToPositionThenBounce:
        return Animations.fromBottomToPositionThenBounce(
          _animationController,
          widget.widget,
        );

      default:
        return widget.widget;
    }
  }
}
