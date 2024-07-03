import 'dart:async';

import 'package:dialog_handler/dialog_handler.dart';
import 'package:flutter/material.dart';

import '../utils/_export_.dart';

  /// To hold configurations of dialog instance on display.
  ///
  /// [dialogType] to identify the desired dialog type for display
  /// it can either be bottomSheetDialog, modalDialog, overlayDialog and others
  ///
  /// [animationDuration] though nullable, is used to specify duration of a dialog animation on appearance
  ///
  /// [animationReverseDuration] though nullable, is used to specify duration of a dialog animation on dismiss
  ///
  /// [onlyDismissProgrammatically] when false, dialog cannot be dismissed on background click but can only be dismissed programatically
  ///
  /// [autoDismissalDuration] when supplied, specifies the duration of a dialog before it is automatically dismissed.
  /// 
  /// [backgroundWidget] to specify widget to be displayed on dialog background.
  /// 
  /// [animationType] specifies the type of appearance and dismissal animation for a dialog on display
  /// `animationType` can be: fadeFromTopToPosition, fadeFromBottomToPosition, fadeFromLeftToPosition, fadeFromRightToPosition, scaleToPosition, fromRightToPosition,
  /// fromLeftToPosition, fromBottomToPosition, fromTopToPosition, fromTopToPositionThenBounce, fromBottomToPositionThenBounce,
  /// 
class DialogConfig {
  final bool onlyDismissProgrammatically;
  final DialogType dialogType;
  final Completer<Map<String, dynamic>>? dialogCompleterInstance;
  final Widget? backgroundWidget;
  final Duration? animationDuration;
  final Duration? animationReverseDuration;
  final AnimationType? animationType;
  final AlignmentGeometry dialogAlignment;
  final Duration? autoDismissalDuration;
  final OverlayEntry? dialogOverlayEntry;

  DialogConfig({
    required this.onlyDismissProgrammatically,
    required this.dialogType,
    this.dialogCompleterInstance,
    this.backgroundWidget,
    this.animationDuration,
    this.animationReverseDuration,
    this.animationType,
    this.dialogAlignment = AlignmentDirectional.topStart,
    this.autoDismissalDuration,
    this.dialogOverlayEntry,
  });

  factory DialogConfig.initialize({
    required bool onlyDismissProgrammatically,
    required DialogType dialogType,
    Widget? backgroundWidget,
    Duration? animationDuration,
    Duration? animationReverseDuration,
    AnimationType? animationType,
    required AlignmentGeometry dialogAlignment,
    Duration? autoDismissalDuration,
    OverlayEntry? dialogOverlayEntry,
  }) {
    /// Pass a new dialog completer instance when a dialog is created
    return DialogConfig(
      onlyDismissProgrammatically: onlyDismissProgrammatically,
      dialogType: dialogType,
      dialogCompleterInstance: Completer<Map<String, dynamic>>(),
      backgroundWidget: backgroundWidget,
      animationDuration: animationDuration,
      animationReverseDuration: animationReverseDuration,
      animationType: animationType,
      dialogAlignment: dialogAlignment,
      autoDismissalDuration: autoDismissalDuration,
      dialogOverlayEntry: dialogOverlayEntry,
    );
  }

  DialogConfig copyWith({
    bool? onlyDismissProgrammatically,
    DialogType? dialogType,
    Widget? backgroundWidget,
    Duration? animationDuration,
    Duration? animationReverseDuration,
    Completer<Map<String, dynamic>>? dialogCompleterInstance,
    AnimationType? animationType,
    AlignmentGeometry? dialogAlignment,
    Duration? autoDismissalDuration,
    OverlayEntry? dialogOverlayEntry,
  }) {
    /// Pass a new dialog completer instance when a dialog is created
    return DialogConfig(
      onlyDismissProgrammatically:
          onlyDismissProgrammatically ?? this.onlyDismissProgrammatically,
      dialogType: dialogType ?? this.dialogType,
      dialogCompleterInstance:
          dialogCompleterInstance ?? this.dialogCompleterInstance,
      backgroundWidget: backgroundWidget ?? this.backgroundWidget,
      animationDuration: animationDuration ?? this.animationDuration,
      animationReverseDuration: animationReverseDuration ?? this.animationReverseDuration,
      animationType: animationType ?? this.animationType,
      dialogAlignment: dialogAlignment ?? this.dialogAlignment,
      autoDismissalDuration:
          autoDismissalDuration ?? this.autoDismissalDuration,
      dialogOverlayEntry: dialogOverlayEntry ?? this.dialogOverlayEntry,
    );
  }

}
