import 'package:flutter/material.dart';

import '../dialog_handler.dart';

final DialogListener dialogListener = DialogListener();

class DialogListener {
  // final List<VoidCallback> _listeners = [];
  final Map<String, VoidCallback> _listeners = {};
  late DialogConfig? config;

  void dismissDialog(DialogConfig iconfig) {
    config = iconfig;
    _notifyListeners(DialogListenerKeys.dismissDialog.name);
  }

  void animatedDismissalCompleted() {
    _notifyListeners(DialogListenerKeys.completedAnimationDismissal.name);
    config = null;
  }

  void addListener(String key, VoidCallback listener) {
    _listeners[key] = listener;
    // _listeners.add(listener);
  }

  void removeListener(String key) {
    _listeners.remove(key);
    // _listeners.remove(listener);
  }

  void _notifyListeners(String key) {
    if (_listeners.containsKey(key)) {
      _listeners[key]!();
    }
    // for (final listener in _listeners) {
    //   listener();
    // }
  }
}