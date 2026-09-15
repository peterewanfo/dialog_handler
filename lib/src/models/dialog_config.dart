import 'dart:async';
import 'dart:math';

import 'package:dialog_handler/dialog_handler.dart';
import 'package:flutter/material.dart';

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
/// [valueKey] identifies this dialog instance. It is optional for the caller,
/// and a randomly generated key is assigned when none is supplied, so every
/// config is always uniquely addressable.
///
/// [animationType] specifies the type of appearance and dismissal animation for a dialog on display
/// `animationType` can be: fadeFromTopToPosition, fadeFromBottomToPosition, fadeFromLeftToPosition, fadeFromRightToPosition, scaleToPosition, fromRightToPosition,
/// fromLeftToPosition, fromBottomToPosition, fromTopToPosition, fromTopToPositionThenBounce, fromBottomToPositionThenBounce,
///
class DialogConfig {
  static final Random _random = Random();

  /// Identifies this dialog instance.
  ///
  /// Supplied by the caller, or randomly generated when omitted. Use it to
  /// recognise a specific dialog among [DialogHandler.visibleDialogs].
  final ValueKey<String> valueKey;
  final bool onlyDismissProgrammatically;
  final DialogType dialogType;
  final Completer<Map<String, dynamic>>? dialogCompleterInstance;
  final Widget? backgroundWidget;
  final Duration? animationDuration;
  final Duration? animationReverseDuration;
  final AnimationType? animationType;
  final AlignmentGeometry dialogAlignment;
  final Duration? autoDismissalDuration;
  final bool? autoDismissWithAnimation;
  final OverlayEntry? dialogOverlayEntry;
  final Function(BuildContext context)? customDialogOnDisplay;

  /// Whether the dialog body is drawn on a liquid glass surface.
  ///
  /// When null, the default set on [DialogManager] applies.
  final bool? enableLiquidGlass;

  /// Appearance of the liquid glass surface. When null, the settings set on
  /// [DialogManager] apply, or [LiquidGlassSettings] defaults.
  final LiquidGlassSettings? liquidGlassSettings;

  DialogConfig({
    required this.onlyDismissProgrammatically,
    required this.dialogType,
    ValueKey<String>? valueKey,
    this.dialogCompleterInstance,
    this.backgroundWidget,
    this.animationDuration,
    this.animationReverseDuration,
    this.animationType,
    this.dialogAlignment = AlignmentDirectional.topStart,
    this.autoDismissalDuration,
    this.autoDismissWithAnimation = true,
    this.dialogOverlayEntry,
    this.customDialogOnDisplay,
    this.enableLiquidGlass,
    this.liquidGlassSettings,
  }) : valueKey = valueKey ?? randomValueKey();

  /// Builds the fallback key used when a caller does not supply a [valueKey].
  ///
  /// Combines the current timestamp with a random suffix so keys stay unique
  /// even for dialogs created within the same microsecond.
  static ValueKey<String> randomValueKey() {
    final String timePart =
        DateTime.now().microsecondsSinceEpoch.toRadixString(16);
    final String randomPart =
        _random.nextInt(0xFFFFFFFF).toRadixString(16).padLeft(8, '0');

    return ValueKey<String>('dialog_${timePart}_$randomPart');
  }

  factory DialogConfig.initialize({
    required bool onlyDismissProgrammatically,
    required DialogType dialogType,
    ValueKey<String>? valueKey,
    Widget? backgroundWidget,
    Duration? animationDuration,
    Duration? animationReverseDuration,
    AnimationType? animationType,
    required AlignmentGeometry dialogAlignment,
    bool? enableLiquidGlass,
    LiquidGlassSettings? liquidGlassSettings,
    Duration? autoDismissalDuration,
    bool? autoDismissWithAnimation,
    OverlayEntry? dialogOverlayEntry,
    Function(BuildContext context)? customDialogOnDisplay,
  }) {
    /// Pass a new dialog completer instance when a dialog is created
    return DialogConfig(
      onlyDismissProgrammatically: onlyDismissProgrammatically,
      dialogType: dialogType,
      valueKey: valueKey,
      dialogCompleterInstance: Completer<Map<String, dynamic>>(),
      backgroundWidget: backgroundWidget,
      animationDuration: animationDuration,
      animationReverseDuration: animationReverseDuration,
      animationType: animationType,
      dialogAlignment: dialogAlignment,
      autoDismissalDuration: autoDismissalDuration,
      autoDismissWithAnimation: autoDismissWithAnimation,
      dialogOverlayEntry: dialogOverlayEntry,
      customDialogOnDisplay: customDialogOnDisplay,
      enableLiquidGlass: enableLiquidGlass,
      liquidGlassSettings: liquidGlassSettings,
    );
  }

  DialogConfig copyWith({
    bool? onlyDismissProgrammatically,
    DialogType? dialogType,
    ValueKey<String>? valueKey,
    Widget? backgroundWidget,
    Duration? animationDuration,
    Duration? animationReverseDuration,
    Completer<Map<String, dynamic>>? dialogCompleterInstance,
    AnimationType? animationType,
    AlignmentGeometry? dialogAlignment,
    bool? enableLiquidGlass,
    LiquidGlassSettings? liquidGlassSettings,
    Duration? autoDismissalDuration,
    bool? autoDismissWithAnimation,
    OverlayEntry? dialogOverlayEntry,
    Function(BuildContext context)? customDialogOnDisplay,
  }) {
    /// Pass a new dialog completer instance when a dialog is created
    return DialogConfig(
      onlyDismissProgrammatically:
          onlyDismissProgrammatically ?? this.onlyDismissProgrammatically,
      dialogType: dialogType ?? this.dialogType,
      valueKey: valueKey ?? this.valueKey,
      dialogCompleterInstance:
          dialogCompleterInstance ?? this.dialogCompleterInstance,
      backgroundWidget: backgroundWidget ?? this.backgroundWidget,
      animationDuration: animationDuration ?? this.animationDuration,
      animationReverseDuration:
          animationReverseDuration ?? this.animationReverseDuration,
      animationType: animationType ?? this.animationType,
      dialogAlignment: dialogAlignment ?? this.dialogAlignment,
      autoDismissalDuration:
          autoDismissalDuration ?? this.autoDismissalDuration,
      autoDismissWithAnimation:
          autoDismissWithAnimation ?? this.autoDismissWithAnimation,
      dialogOverlayEntry: dialogOverlayEntry ?? this.dialogOverlayEntry,
      customDialogOnDisplay:
          customDialogOnDisplay ?? this.customDialogOnDisplay,
      enableLiquidGlass: enableLiquidGlass ?? this.enableLiquidGlass,
      liquidGlassSettings: liquidGlassSettings ?? this.liquidGlassSettings,
    );
  }
}
