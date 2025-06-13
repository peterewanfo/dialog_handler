import 'dart:async';
import 'package:flutter/material.dart';

import '../models/_export_.dart';
import '../utils/_export_.dart';
import '../dialog_listener.dart';

class CustomWidget extends StatefulWidget {
  final Widget widget;
  final DialogConfig dialogConfig;
  final Function() onDismissal;
  const CustomWidget({
    super.key,
    required this.widget,
    required this.dialogConfig,
    required this.onDismissal,
  });

  @override
  State<CustomWidget> createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget>
    with SingleTickerProviderStateMixin {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    dialogListener.addListener(
      DialogListenerKeys.dismissDialog.name,
      () {
        dialogListener.animatedDismissalCompleted();
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    dialogListener.removeListener(DialogListenerKeys.dismissDialog.name);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.widget;
  }
}
