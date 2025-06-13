import 'package:dialog_handler/src/utils/_export_.dart';
import 'package:dialog_handler/src/utils/extension.dart';
import 'package:dialog_handler/src/dialog_listener.dart';
import 'package:dialog_handler/src/widgets_wrappers/custom_widget.dart';
import 'package:flutter/material.dart';

import 'dialog_handler.dart';
import 'models/_export_.dart';
import 'widgets_wrappers/custom_animated_widget.dart';

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
    dialogListener.addListener(
      DialogListenerKeys.completedAnimationDismissal.name,
      animatedDismissal,
    );
    _dialogHandler = DialogHandler.instance;
    _dialogHandler.registerDismissDialogListener(dismissDialog);
    _dialogHandler.registerDialogListener(showDialogContent);
  }

  bool isOverlayDialog(DialogConfig dMemory) {
    return (dMemory.dialogType == DialogType.overlayDialog);
  }

  void animatedDismissal() {
    if (dialogListener.config != null) {
      if (isOverlayDialog(dialogListener.config!)) {
        dialogListener.config!.dialogOverlayEntry?.remove();
      } else {
        /// Close Dialog
        /// Return false inorder to handle dialogs clicked on background
        Navigator.of(context).pop(false);
      }
    }
  }

  void _singleDialogDismiss({
    required Map<String, dynamic> dismissalResponseData,
    bool isDialogSelfDismissed = false,
    DialogConfig? dialogConfigToDelete,
    int? dialogConfigIndexToDelete,
  }) {
    DialogStack<DialogConfig> dialogMemory = DialogHandler.dialogMemory();

    DialogConfig? dMemory;

    if (dialogConfigToDelete != null) {
      dMemory = dialogConfigToDelete;
    } else {
      if (dialogConfigIndexToDelete != null && dialogConfigIndexToDelete >= 0) {
        dMemory = dialogMemory.popAtIndex(dialogConfigIndexToDelete);
      } else {
        dMemory ??= dialogMemory.pop();
      }
    }

    if (dMemory != null) {
      if (isOverlayDialog(dMemory)) {
        if (dMemory.dialogOverlayEntry != null) {
          _dialogHandler.returnDialogCompleter(
            responseData: dismissalResponseData,
            dialogCompleterInstance: dMemory.dialogCompleterInstance!,
          );
          if (dMemory.dialogOverlayEntry!.mounted) {
            // dMemory.dialogOverlayEntry?.remove();
            dialogListener.dismissDialog(dMemory);
            // dMemory.dialogOverlayEntry?.remove();
          }
        }
      } else {
        if (Navigator.canPop(context)) {
          _dialogHandler.returnDialogCompleter(
            responseData: dismissalResponseData,
            dialogCompleterInstance:
                dMemory.dialogCompleterInstance!, //dialogInstance
          );
          if (isDialogSelfDismissed == false) {
            dialogListener.dismissDialog(dMemory);
            // Navigator.of(context).pop(false);
          }
        }
      }
    }
  }

  void dismissDialog({
    bool dismissAllDialog = false,
    Map<String, dynamic> dismissalResponseData = const {},
    bool isDialogSelfDismissed = false,
    DialogConfig? dialogConfigToDelete,
    int? dialogConfigIndexToDelete,
  }) {
    DialogStack<DialogConfig> dialogMemory = DialogHandler.dialogMemory();
    int totalAvailableDialogs = dialogMemory.allItems.length;

    if (dismissAllDialog) {
      /// LOOP THROUGH ALL AVAILABLE DIALOG TO DISMISS
      for (int i = 0; i < totalAvailableDialogs; i++) {
        _singleDialogDismiss(
          dismissalResponseData: dismissalResponseData,
          dialogConfigToDelete: dialogConfigToDelete,
          dialogConfigIndexToDelete: dialogConfigIndexToDelete,
        );
      }
    } else {
      if (dialogMemory.allItems.isNotEmpty) {
        _singleDialogDismiss(
          dismissalResponseData: dismissalResponseData,
          isDialogSelfDismissed: isDialogSelfDismissed,
          dialogConfigToDelete: dialogConfigToDelete,
          dialogConfigIndexToDelete: dialogConfigIndexToDelete,
        );
      }
    }
  }

  void showDialogContent({
    required Widget widget,
    required DialogConfig dialogConfig,
  }) async {
    switch (dialogConfig.dialogType) {
      case DialogType.bottomSheetDialog:
        if (mounted) {
          await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                if (dialogConfig.animationType != null) {
                  return CustomAnimatedWidget(
                    widget: widget,
                    dialogConfig: dialogConfig,
                    animationType: dialogConfig.animationType,
                    onDismissal: () {
                      int index = DialogHandler.dialogMemory()
                          .getDialogIndex(value: dialogConfig);
                      dismissDialog(
                        dialogConfigIndexToDelete: index,
                      );
                    },
                  );
                } else {
                  return CustomWidget(
                    widget: widget,
                    dialogConfig: dialogConfig,
                    onDismissal: () {
                      int index = DialogHandler.dialogMemory()
                          .getDialogIndex(value: dialogConfig);
                      dismissDialog(
                        dialogConfigIndexToDelete: index,
                      );
                    },
                  );
                }
              }).then(
            (value) async {
              if (value == null) {
                if (dialogConfig.autoDismissalDuration == null) {
                  dismissDialog(
                    isDialogSelfDismissed: true,
                  );
                }
              }
            },
          );
        }

      case DialogType.customDialog:
        if (mounted) {
          if (dialogConfig.customDialogOnDisplay != null) {
            await dialogConfig.customDialogOnDisplay!(context);
          }
        }

      case DialogType.modalDialog:
        if (mounted) {
          await showGeneralDialog(
            context: context,
            barrierDismissible: false,
            transitionDuration: dialogConfig.animationDuration ?? Duration.zero,
            pageBuilder: (context, __, ___) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (dialogConfig.autoDismissalDuration == null) {
                      dialogListener.dismissDialog(dialogConfig);
                    }
                  },
                  child: Stack(
                    alignment: dialogConfig.dialogAlignment,
                    children: [
                      if (dialogConfig.backgroundWidget != null)
                        dialogConfig.backgroundWidget!,
                      if (dialogConfig.animationType != null)
                        CustomAnimatedWidget(
                          widget: widget,
                          dialogConfig: dialogConfig,
                          animationType: dialogConfig.animationType ??
                              AnimationType.scaleToPosition,
                          onDismissal: () {
                            int index = DialogHandler.dialogMemory()
                                .getDialogIndex(value: dialogConfig);
                            dismissDialog(
                              dialogConfigIndexToDelete: index,
                            );
                          },
                        ),
                      if (dialogConfig.animationType == null)
                        CustomWidget(
                          widget: widget,
                          dialogConfig: dialogConfig,
                          onDismissal: () {
                            int index = DialogHandler.dialogMemory()
                                .getDialogIndex(value: dialogConfig);
                            dismissDialog(
                              dialogConfigIndexToDelete: index,
                            );
                          },
                        )
                    ],
                  ),
                ).noShadow,
              );
            },
          ).then(
            (value) async {
              if (value == null) {
                if (dialogConfig.autoDismissalDuration == null) {
                  dismissDialog(
                    isDialogSelfDismissed: true,
                  );
                }
              }
            },
          );
        }

      case DialogType.pageDialog:
        if (mounted) {
          await showGeneralDialog(
            context: context,
            barrierDismissible: false,
            pageBuilder: (context, __, ___) {
              if (dialogConfig.animationType != null) {
                return Material(
                  color: Colors.black.withValues(alpha: 0.45),
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomAnimatedWidget(
                          widget: widget,
                          dialogConfig: dialogConfig,
                          animationType: dialogConfig.animationType,
                          onDismissal: () {
                            int index = DialogHandler.dialogMemory()
                                .getDialogIndex(value: dialogConfig);
                            dismissDialog(
                              dialogConfigIndexToDelete: index,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Material(
                  color: Colors.black.withValues(alpha: 0.45),
                  child: Column(
                    children: [
                      Expanded(
                          child: CustomWidget(
                        widget: widget,
                        dialogConfig: dialogConfig,
                        onDismissal: () {
                          int index = DialogHandler.dialogMemory()
                              .getDialogIndex(value: dialogConfig);
                          dismissDialog(
                            dialogConfigIndexToDelete: index,
                          );
                        },
                      )),
                    ],
                  ),
                );
              }
            },
          ).then(
            (value) async {
              if (value == null) {
                if (dialogConfig.autoDismissalDuration == null) {
                  dismissDialog(
                    isDialogSelfDismissed: true,
                  );
                }
              }
            },
          );
        }

      case DialogType.overlayDialog:
        _overlayEntry = OverlayEntry(
          builder: (_) {
            return Stack(
              alignment: dialogConfig.dialogAlignment,
              children: [
                if (dialogConfig.backgroundWidget != null)
                  dialogConfig.backgroundWidget!,
                if (dialogConfig.animationType != null)
                  Material(
                    color: Colors.transparent,
                    child: CustomAnimatedWidget(
                      widget: widget,
                      dialogConfig: dialogConfig,
                      animationType: dialogConfig.animationType,
                      onDismissal: () {
                        int index = DialogHandler.dialogMemory()
                            .getDialogIndex(value: dialogConfig);
                        dismissDialog(
                          // dialogConfigToDelete: dialogConfig,
                          dialogConfigIndexToDelete: index,
                        );
                      },
                    ),
                  ),
                if (dialogConfig.animationType == null)
                  Material(
                    color: Colors.transparent,
                    child: CustomWidget(
                      widget: widget,
                      dialogConfig: dialogConfig,
                      onDismissal: () {
                        int index = DialogHandler.dialogMemory()
                            .getDialogIndex(value: dialogConfig);
                        dismissDialog(
                          // dialogConfigToDelete: dialogConfig,
                          dialogConfigIndexToDelete: index,
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        );

        if (_overlayEntry != null) {
          Overlay.of(context).insert(_overlayEntry!);
        }
        DialogConfig idialogConfig =
            dialogConfig.copyWith(dialogOverlayEntry: _overlayEntry);

        DialogHandler.dialogMemory()
            .update(preValue: dialogConfig, newValue: idialogConfig);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
