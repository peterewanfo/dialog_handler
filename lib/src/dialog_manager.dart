import 'package:dialog_handler/src/utils/_export_.dart';
import 'package:flutter/material.dart';

import 'dialog_handler.dart';
import 'models/_export_.dart';

class DialogManager extends StatefulWidget {
  final Widget child;

  const DialogManager({
    super.key,
    required this.child,
  });

  @override
  State<DialogManager> createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  late DialogHandler _dialogHandler;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _dialogHandler = DialogHandler.instance;
    _dialogHandler.registerDismissDialogListener(dismissDialog);
    _dialogHandler.registerDialogListener(showDialogContent);
  }

  void dismissDialog({
    Map<String, dynamic>? dismissalResult,
  }) {
    DialogStack<DialogConfig> dialogMemory = DialogHandler.dialogMemory();

    DialogConfig? memoryHold = dialogMemory.pop();

    if (memoryHold != null) {
      if (memoryHold.dialogType != DialogType.overlayDialog) {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop(false);
        }
      } else {
        if (_overlayEntry != null) {
          _overlayEntry?.remove();
        }
      }
    }
  }

  void showDialogContent({
    required Widget widget,
    required DialogConfig dialogConfig,
  }) async {
    switch (dialogConfig.dialogType) {
      case DialogType.bottomSheetDialog:
        return await showModalBottomSheet(
            context: context,
            builder: (context) {
              return widget;
            });
      case DialogType.modalDialog:
        return await showDialog(
            context: context,
            builder: (context) {
              return widget;
            });
      case DialogType.pageDialog:
        await showGeneralDialog(
          context: context,
          barrierDismissible: false,
          pageBuilder: (context, __, ___) {
            return Material(
              color: Colors.black.withOpacity(.45),
              child: widget,
            );
          },
        );
      case DialogType.overlayDialog:
        _overlayEntry = OverlayEntry(
          builder: (context) => PopScope(
            canPop: false,
            onPopInvoked: (didPop) async {
              if (didPop) {
                return;
              }
            },
            child:
                Material(color: Colors.black.withOpacity(.65), child: widget),
          ),
        );
        if (_overlayEntry != null) {
          Overlay.of(context).insert(_overlayEntry!);
        }
      default:
        return await showDialog(
          context: context,
          builder: (context) {
            return const Text("Dialog Config does not exist");
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
