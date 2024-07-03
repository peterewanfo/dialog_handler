# Dialog Handler

A Flutter package that helps simplify the use of dialogs. 

# Why use dialog handler?
As your app grows, with multiple dialogs implemented in your app, you will need a way to handle, display and dismiss all variations of dialogs and overlays based on the following cases.

* You want to display dialog directly from your business layer without injecting context from View
* You dont just want your dialog/overlays to appear plain but instead apear animated.
* After you dismiss a dialog, you want to return transaction responses to the dialog caller object.a
* You want nested dialogs (ability to open another dialog from a dialog) without closing the previous dialog.
* You need to easily mock dialogs during test.
* You want to autodismiss a dialog after a Duration

These are use cases that will require you to use this package. Below you will find a handfull of examples that may suite your need.


## Getting Started

Note: It's best to register the instance of Dialog Handler with a service locator, preferrably `GetIt`.

## Installation

Run this command:

With Flutter:


```
flutter pub add dialog_handler
```

This will add a line like this to your package's pubspec.yaml (and run an implicit `flutter pub get`):


```
dependencies:
    dialog_handler: ^1.0.0
```

## Register Dialog Handler Instance

To register Dialog Handler instance using getIt, see below

```
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

locator.registerLazySingleton<DialogHandler>(
    () => DialogHandler.instance,
);

```


## Using Dialog Handler in Details

Let's say I have the widget below to show in a dialog
```
import 'package:flutter/material.dart';

class SampleDialogWidget extends StatelessWidget {
  const SampleDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: 300,
      width: double.infinity,
    );
  }
}
```

To show this a dialog with `SimpleDialogWidget`, see below

```
await locator<DialogHandler>().showDialog(
    dialogType: DialogType.modalDialog,
    animationType: AnimationType.fromTopToPosition,
    animationDuration: const Duration(milliseconds: 300),
    widget: const ModalDialogWidget(),
);
```

`dialogType` can be any of the following:
* bottomSheetDialog
* modalDialog,
* overlayDialog,

`animationType` can be any of the following:
* fadeFromTopToPosition
* fadeFromBottomToPosition,
* fadeFromLeftToPosition,
* fadeFromRightToPosition,
* scaleToPosition,
* fromRightToPosition,
* fromLeftToPosition,
* fromBottomToPosition,
* fromTopToPosition,
* fromTopToPositionThenBounce,
* fromBottomToPositionThenBounce,

`animationDuration` is nullable or a Duration object that controls animation display duration

`animationReverseDuration` is nullable or a Duration object that controls animation reverse duration

`backgroundWidget` is either nullable or widget that will display at the background of any dialog on display. With this, we can build a blur background dialog. example below

```
await locator<DialogHandler>().showDialog(
  dialogType: DialogType.modalDialog,
  widget: const ModalDialogWithBlurWidget(),
  backgroundWidget: GlassContainer.clearGlass(
    borderWidth: 0,
    blur: 7,
  ),
);

```

### Contribution
If you wish to contribute to this boilerplate project, please feel free to submit an issue and/or pull request.

Thanks for your time.