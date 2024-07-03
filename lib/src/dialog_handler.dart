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
  Future<Map<String, dynamic>> showDialog({
    required DialogType dialogType,
    Duration? animationDuration,
    Duration? animationReverseDuration,
    AnimationType? animationType,
    required Widget widget,
    bool? onlyDismissProgrammatically,
    Widget? backgroundWidget,
    AlignmentGeometry dialogAlignment = AlignmentDirectional.center,
    Duration? autoDismissalDuration,
  }) {
    DialogConfig dialogConfig = DialogConfig.initialize(
      onlyDismissProgrammatically: onlyDismissProgrammatically ?? false,
      dialogType: dialogType,
      backgroundWidget: backgroundWidget,
      animationDuration: animationDuration,
      animationReverseDuration: animationReverseDuration,
      animationType: animationType,
      dialogAlignment: dialogAlignment,
      autoDismissalDuration: autoDismissalDuration,
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
    }) dismissDialog,
  ) {
    _dismissDialogListener = dismissDialog;
  }

  Future<void> dismissDialog({
    bool dismissAllDialog = false,
    Map<String, dynamic> dismissalResponseData = const {},
  }) async {
    _dismissDialogListener(
      dismissAllDialog: dismissAllDialog,
      dismissalResponseData: dismissalResponseData,
    );
  }

  void returnDialogCompleter({
    required Map<String, dynamic> responseData,
    required Completer<Map<String, dynamic>> dialogCompleterInstance,
  }) {
    dialogCompleterInstance.complete(responseData);
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
    int index = _list.indexWhere((v) => (v as DialogConfig).dialogCompleterInstance == (value as DialogConfig).dialogCompleterInstance);
    
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
