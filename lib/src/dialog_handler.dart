import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../dialog_handler.dart';

class DialogHandler {
  static final instance = DialogHandler();

  static final _dialogMemory = DialogStack<DialogConfig>();
  static DialogStack<DialogConfig> dialogMemory() {
    return _dialogMemory;
  }

  late Function({
    required Widget widget,
    required DialogConfig dialogConfig,
  }) _showDialogListener;

  late Function({
    required bool dismissAllDialog,
    required Map<String, dynamic> dismissalResponseData,
    ValueKey<String>? valueKey,
  }) _dismissDialogListener;

  /// Register a callback function to show dialog
  void registerDialogListener(
      Function({
        required Widget widget,
        required DialogConfig dialogConfig,
      }) showDialog) {
    _showDialogListener = showDialog;
  }

  /// To display a dialog.
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
  /// [valueKey] to identify this dialog instance. When omitted, a randomly
  /// generated key is assigned, so a dialog can always be recognised among
  /// the configs returned by [visibleDialogs].
  ///
  Future<Map<String, dynamic>> showDialog({
    required DialogType dialogType,
    Duration? animationDuration,
    Duration? animationReverseDuration,
    AnimationType? animationType,
    required Widget widget,
    ValueKey<String>? valueKey,
    bool? onlyDismissProgrammatically,
    Widget? backgroundWidget,
    AlignmentGeometry dialogAlignment = AlignmentDirectional.center,
    Duration? autoDismissalDuration,
    bool? autoDismissWithAnimation,
    Function(BuildContext context)? customDialogOnDisplay,
  }) {
    DialogConfig dialogConfig = DialogConfig.initialize(
      onlyDismissProgrammatically: onlyDismissProgrammatically ?? false,
      dialogType: dialogType,
      valueKey: valueKey,
      backgroundWidget: backgroundWidget,
      animationDuration: animationDuration,
      animationReverseDuration: animationReverseDuration,
      animationType: animationType,
      dialogAlignment: dialogAlignment,
      autoDismissalDuration: autoDismissalDuration,
      autoDismissWithAnimation: autoDismissWithAnimation,
      customDialogOnDisplay: customDialogOnDisplay,
    );

    /// Add New Dialog to Stack
    _dialogMemory.push(dialogConfig);

    /// Execute `_showDialogListener` on function call
    _showDialogListener(widget: widget, dialogConfig: dialogConfig);

    return dialogConfig.dialogCompleterInstance!.future;
  }

  /// Register a callback function to dismiss dialog
  void registerDismissDialogListener(
    Function({
      required bool dismissAllDialog,
      required Map<String, dynamic> dismissalResponseData,
      ValueKey<String>? valueKey,
    }) dismissDialog,
  ) {
    _dismissDialogListener = dismissDialog;
  }

  /// To dismiss a dialog currently on display.
  ///
  /// [valueKey] when supplied, dismisses the one dialog carrying that key and
  /// takes precedence over [dismissAllDialog]. Nothing happens when no visible
  /// dialog matches, so pair it with [isDialogVisible] when the outcome
  /// matters.
  ///
  /// Note that for the route backed types (modalDialog, bottomSheetDialog and
  /// pageDialog) only the dialog at the top of the stack can be taken off the
  /// screen, because dismissal pops the current route. Targeting one of those
  /// further down the stack by key updates the records and completes its
  /// future, but removes the topmost dialog from view. Overlay dialogs have no
  /// such limitation and can be dismissed by key from any position.
  ///
  /// [dismissAllDialog] when true, dismisses every dialog on display.
  ///
  /// [dismissalResponseData] is returned to the future handed out by
  /// [showDialog] for the dismissed dialog.
  Future<void> dismissDialog({
    bool dismissAllDialog = false,
    Map<String, dynamic> dismissalResponseData = const {},
    ValueKey<String>? valueKey,
  }) async {
    _dismissDialogListener(
      dismissAllDialog: dismissAllDialog,
      dismissalResponseData: dismissalResponseData,
      valueKey: valueKey,
    );
  }

  void returnDialogCompleter({
    required Map<String, dynamic> responseData,
    required Completer<Map<String, dynamic>> dialogCompleterInstance,
  }) {
    dialogCompleterInstance.complete(responseData);
  }

  /// Returns a list of dialog configurations currently visible on the screen.
  List<DialogConfig> visibleDialogs() {
    return List<DialogConfig>.from(_dialogMemory.allItems);
  }

  /// Whether a dialog carrying [valueKey] is currently visible on the screen.
  ///
  /// Returns true when a config in [visibleDialogs] has a matching key,
  /// otherwise false.
  bool isDialogVisible(ValueKey<String> valueKey) {
    return visibleDialogs().any((config) => config.valueKey == valueKey);
  }
}

/// To keep record of dialogs on display, important for nexted dialogs
///
class DialogStack<T> {
  final _list = <T>[];

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  void push(T value) => _list.add(value);

  T? pop() => (isEmpty) ? null : _list.removeLast();

  T? popAtIndex(index) => (isEmpty) ? null : _list.removeAt(index);

  T? get peek => (isEmpty) ? null : _list.last;

  List<T> get allItems => _list;

  int getDialogIndex({required T value}) {
    int index = _list.indexWhere((v) =>
        (v as DialogConfig).dialogCompleterInstance ==
        (value as DialogConfig).dialogCompleterInstance);

    return index;
  }

  void update({
    required T preValue,
    required T newValue,
  }) {
    int index = _list.indexWhere((v) => v == preValue);

    _list[index] = newValue;
  }

  /// To Check Dialog list Content
  @override
  String toString() => _list.toString();
}
