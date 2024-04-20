import 'package:dialog_handler/src/models/dialog_config.dart';
import 'package:flutter/material.dart';

class DialogHandler {

  static final instance = DialogHandler();

  static final _dialogMemory = DialogStack<DialogConfig>();
  static DialogStack<DialogConfig> dialogMemory() {
    return _dialogMemory;
  }

  late Function({required Widget widget, required DialogConfig dialogConfig})
      _showDialogListener;

  late Function() _dismissDialogListener;

  /// Register a callback function to show dialog
  void registerDialogListener(
      Function({required Widget widget, required DialogConfig dialogConfig})
          showDialog) {
    _showDialogListener = showDialog;
  }

  void showDialog(
      {required Widget widget, required DialogConfig dialogConfig}) {

    /// Add New Dialog to Stack
    _dialogMemory.push(dialogConfig);

    /// Execute `_showDialogListener` on function call
    _showDialogListener(widget: widget, dialogConfig: dialogConfig);
  }

  /// Register a callback function to dismiss dialog
  void registerDismissDialogListener(Function() dismissDialog) {
    _dismissDialogListener = dismissDialog;
  }

  Future<void> dismissDialog() async {
    _dismissDialogListener();
  }
  
}

class DialogStack<T> {
  final _list = <T>[];

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  void push(T value) => _list.add(value);

  T? pop() => (isEmpty) ? null : _list.removeLast();

  T? get peek => (isEmpty) ? null : _list.last;

  /// To Check Dialog list Content
  @override
  String toString() => _list.toString();
}
