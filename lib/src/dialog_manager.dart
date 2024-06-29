import 'package:dialog_handler/src/utils/_export_.dart';
import 'package:dialog_handler/src/utils/extension.dart';
import 'package:dialog_handler/src/dialog_listener.dart';
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
    return (dMemory.dialogType == DialogType.overlayDialog) ||
        (dMemory.dialogType == DialogType.transparentInteractableDialog);
  }

  void animatedDismissal() {
    if (dialogListener.config != null) {
      if (isOverlayDialog(dialogListener.config!)) {
        dialogListener.config!.dialogOverlayEntry?.remove();
      } else {
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

  // static void timerCountDismissal(List<dynamic> args) {
  //   SendPort sendPort = args[0];
  //   Duration autoDismissalDuration = args[1]["autoDismissalDuration"];
  //   Future.delayed(autoDismissalDuration).then(
  //     (value) {
  //       sendPort.send("execute");
  //     },
  //   );
  // }

  // Future<void> dismissDialogIsolate({
  //   required Duration autoDismissalDuration,
  //   DialogConfig? dialogConfigToDelete,
  // }) async {
  //   ReceivePort receivePort = ReceivePort();
  //   await Isolate.spawn(timerCountDismissal, [
  //     receivePort.sendPort,
  //     {
  //       "autoDismissalDuration": autoDismissalDuration,
  //     },
  //   ]);

  //   receivePort.listen((message) {
  //     if (message == "execute") {
  //       dismissDialog(dialogConfigToDelete: dialogConfigToDelete);
  //     }
  //   });
  // }

  void showDialogContent({
    required Widget widget,
    required DialogConfig dialogConfig,
  }) async {
    switch (dialogConfig.dialogType) {
      case DialogType.bottomSheetDialog:
        // if (dialogConfig.autoDismissalDuration != null) {
        //   await dismissDialogIsolate(
        //     autoDismissalDuration: dialogConfig.autoDismissalDuration!,
        //     dialogConfigToDelete: dialogConfig,
        //   );
        // }
        if (mounted) {
          await showModalBottomSheet(
              context: context,
              builder: (context) {
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

      case DialogType.modalDialog:
        // if (dialogConfig.autoDismissalDuration != null) {
        //   await dismissDialogIsolate(
        //     autoDismissalDuration: dialogConfig.autoDismissalDuration!,
        //     dialogConfigToDelete: dialogConfig,
        //   );
        // }

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
          // await showGeneralDialog(
          //   context: context,
          //   barrierDismissible: false,
          //   transitionDuration: dialogConfig.animationDuration ?? Duration.zero,
          //   transitionBuilder: (
          //     BuildContext context,
          //     Animation<double> primaryAnimation,
          //     Animation<double> secondaryAnimation,
          //     Widget child,
          //   ) =>
          //       CustomAnimatedWidget(
          //     onAutoDismissal: () {
          //       dismissDialog();
          //     },
          //     dialogConfig: dialogConfig,
          //     animation: primaryAnimation,
          //     animationType:
          //         dialogConfig.animationType ?? AnimationType.scaleToPosition,
          //     child: child,
          //   ),
          //   pageBuilder: (context, __, ___) {
          //     return Material(
          //       color: Colors.transparent,
          //       child: InkWell(
          //         onTap: () {
          //           if (dialogConfig.autoDismissalDuration == null) {
          //             dismissDialog();
          //           }
          //         },
          //         child: Stack(
          //           alignment: dialogConfig.dialogAlignment,
          //           children: [
          //             if (dialogConfig.backgroundWidget != null)
          //               dialogConfig.backgroundWidget!,
          //             widget,
          //           ],
          //         ),
          //       ).noShadow,
          //     );
          //   },
          // ).then(
          //   (value) async {
          //     if (value == null) {
          //       if (dialogConfig.autoDismissalDuration == null) {
          //         dismissDialog(
          //           isDialogSelfDismissed: true,
          //         );
          //       }
          //     }
          //   },
          // );
        }

      case DialogType.pageDialog:
        // if (dialogConfig.autoDismissalDuration != null) {
        //   await dismissDialogIsolate(
        //     autoDismissalDuration: dialogConfig.autoDismissalDuration!,
        //     dialogConfigToDelete: dialogConfig,
        //   );
        // }
        if (mounted) {
          await showGeneralDialog(
            context: context,
            barrierDismissible: false,
            pageBuilder: (context, __, ___) {
              return Material(
                color: Colors.black.withOpacity(.45),
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
                            // dialogConfigToDelete: dialogConfig,
                            dialogConfigIndexToDelete: index,
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
      // case DialogType.transparentInteractableDialog:
      //   _overlayEntry = OverlayEntry(
      //     builder: (context) => PopScope(
      //       canPop: false,
      //       onPopInvoked: (didPop) async {
      //         if (didPop) {
      //           return;
      //         }
      //       },
      //       child: Material(
      //         color: Colors.black.withOpacity(.65),
      //         child: InkWell(
      //           child: StandaloneWidget(
      //             widget: Stack(
      //               alignment: dialogConfig.dialogAlignment,
      //               children: [
      //                 if (dialogConfig.backgroundWidget != null)
      //                   dialogConfig.backgroundWidget!,
      //                 widget,
      //               ],
      //             ),
      //             dialogConfig: dialogConfig,
      //             onAutoDismissal: () {
      //               dismissDialog();
      //             },
      //           ),
      //         ).noShadow,
      //       ),
      //     ),
      //   );
      //   if (_overlayEntry != null) {
      //     Overlay.of(context).insert(_overlayEntry!);
      //   }

      // if (dialogConfig.autoDismissalDuration != null) {
      //   await dismissDialogIsolate(
      //     autoDismissalDuration: dialogConfig.autoDismissalDuration!,
      //     dialogConfigToDelete: dialogConfig,
      //   );
      // }

      case DialogType.overlayDialog:
        _overlayEntry = OverlayEntry(
          builder: (_) {
            return Stack(
              alignment: dialogConfig.dialogAlignment,
              children: [
                if (dialogConfig.backgroundWidget != null)
                  dialogConfig.backgroundWidget!,
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      dismissDialog();
                    },
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
                  ).noShadow,
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

      // if (idialogConfig.autoDismissalDuration != null) {
      //   await dismissDialogIsolate(
      //     autoDismissalDuration: idialogConfig.autoDismissalDuration!,
      //     dialogConfigToDelete: idialogConfig,
      //   );
      // }

      default:
        return await showDialog(
          context: context,
          builder: (context) {
            return const Text("Dialog Config does not exist");
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
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
