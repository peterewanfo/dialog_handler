# Dialog Handler

[![pub package](https://img.shields.io/pub/v/dialog_handler.svg)](https://pub.dev/packages/dialog_handler)

A Flutter package that simplifies showing, tracking and dismissing every kind of dialog — modals, bottom sheets, full page dialogs and overlays — **without passing `BuildContext` around**.

Call `showDialog(...)` from a view model, a repository, an interceptor or anywhere else in your business layer, `await` the result, and get the user's response back as data.

---

## Table of contents

- [Why use Dialog Handler](#why-use-dialog-handler)
- [Installation](#installation)
- [Setup](#setup)
- [Quick start](#quick-start)
- [Dialog types](#dialog-types)
- [`showDialog` parameters](#showdialog-parameters)
- [Returning data from a dialog](#returning-data-from-a-dialog)
- [Dismissing dialogs](#dismissing-dialogs)
- [Identifying and tracking dialogs](#identifying-and-tracking-dialogs)
- [Android back button](#android-back-button)
- [Animations](#animations)
- [Auto dismissal](#auto-dismissal)
- [Liquid glass](#liquid-glass)
- [Nested dialogs](#nested-dialogs)
- [Recipes](#recipes)
- [Using a service locator](#using-a-service-locator)
- [Testing](#testing)
- [API reference](#api-reference)
- [Behaviour notes and limitations](#behaviour-notes-and-limitations)
- [Compatibility](#compatibility)
- [Contributing](#contributing)

---

## Why use Dialog Handler

As an app grows and dialogs multiply, you need one consistent way to handle them. Reach for this package when:

- You want to show a dialog **from your business layer** without injecting `BuildContext` from the view.
- You want your dialogs and overlays to **appear animated** instead of plain.
- After a dialog is dismissed you want to **return a response to the caller**.
- You need **nested dialogs** — opening a dialog from a dialog without closing the previous one.
- You want to **auto dismiss** a dialog after a `Duration`.
- You want to **ask whether a given dialog is on screen**, or dismiss one specific dialog out of several.
- You need to **easily mock dialogs in tests**.

---

## Installation

```bash
flutter pub add dialog_handler
```

Or add it to `pubspec.yaml` directly:

```yaml
dependencies:
  dialog_handler: ^1.0.3
```

Then import it:

```dart
import 'package:dialog_handler/dialog_handler.dart';
```

---

## Setup

Wrap your app's content in a `DialogManager`. This is **required** — `DialogHandler` does nothing until a `DialogManager` has registered itself.

`DialogManager` must sit **below** `MaterialApp`, because it needs a `Navigator` and an `Overlay` from the widget tree above it.

```dart
import 'package:dialog_handler/dialog_handler.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DialogManager(
        child: const HomePage(),
      ),
    );
  }
}
```

> **Tip:** to make every route dialog-aware, use `MaterialApp.builder` instead:
>
> ```dart
> MaterialApp(
>   builder: (context, child) => DialogManager(child: child!),
>   home: const HomePage(),
> )
> ```

`DialogManager` registers itself with the `DialogHandler.instance` singleton in `initState`, so the last one mounted wins. Mount exactly one.

---

## Quick start

Any widget can be a dialog body. No mixin, no base class:

```dart
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

Show it:

```dart
await DialogHandler.instance.showDialog(
  dialogType: DialogType.modalDialog,
  widget: const SampleDialogWidget(),
);
```

Dismiss it from anywhere:

```dart
await DialogHandler.instance.dismissDialog();
```

---

## Dialog types

`dialogType` selects how the dialog is put on screen. Each type is backed by a different Flutter primitive, which is what determines the features it supports.

| `DialogType` | Backed by | `backgroundWidget` | `dialogAlignment` | Notes |
|---|---|---|---|---|
| `modalDialog` | `showGeneralDialog` | ✅ | ✅ | Blocks interaction with the page. Tapping the background dismisses it. |
| `pageDialog` | `showGeneralDialog` | ❌ | ❌ | Full page dialog over a fixed 45% black scrim. |
| `bottomSheetDialog` | `showModalBottomSheet` | ❌ | ❌ | Scroll controlled, transparent background. |
| `overlayDialog` | `Overlay` + `OverlayEntry` | ✅ | ✅ | **The page stays interactive.** Use for toasts, banners and snack style messages. |
| `customDialog` | Your own callback | ❌ | ❌ | Hands you a `BuildContext` so you can present any third party dialog while still tracking it. |

`overlayDialog` is the one to reach for when the user should still be able to use the screen behind the dialog. Everything else pushes a route.

---

## `showDialog` parameters

```dart
Future<Map<String, dynamic>> showDialog({
  required DialogType dialogType,
  required Widget widget,
  ValueKey<String>? valueKey,
  AnimationType? animationType,
  Duration? animationDuration,
  Duration? animationReverseDuration,
  bool? onlyDismissProgrammatically,
  Widget? backgroundWidget,
  AlignmentGeometry dialogAlignment = AlignmentDirectional.center,
  Duration? autoDismissalDuration,
  bool? autoDismissWithAnimation,
  Function(BuildContext context)? customDialogOnDisplay,
  bool? enableLiquidGlass,
  LiquidGlassSettings? liquidGlassSettings,
})
```

| Parameter | Type | Default | What it does |
|---|---|---|---|
| `dialogType` | `DialogType` | **required** | Which presentation to use. See [Dialog types](#dialog-types). |
| `widget` | `Widget` | **required** | The dialog body. |
| `valueKey` | `ValueKey<String>?` | random | Identifies this dialog. Used by `isDialogVisible` and by `dismissDialog(valueKey: ...)`. A unique random key is generated when omitted. |
| `animationType` | `AnimationType?` | `null` | Entry animation. When `null` the widget is shown with no wrapper animation. See [Animations](#animations). |
| `animationDuration` | `Duration?` | `1200ms` | Forward animation duration. Also used as the route transition duration for `modalDialog` (which is otherwise `Duration.zero`). |
| `animationReverseDuration` | `Duration?` | `animationDuration` | Reverse animation duration. |
| `onlyDismissProgrammatically` | `bool?` | `false` | When `true`, the Android back button will not dismiss this dialog. See [Behaviour notes](#behaviour-notes-and-limitations). |
| `backgroundWidget` | `Widget?` | `null` | Rendered behind the dialog body — a blur, a scrim, an image. `modalDialog` and `overlayDialog` only. |
| `dialogAlignment` | `AlignmentGeometry` | `AlignmentDirectional.center` | Where the body sits in its `Stack`. `modalDialog` and `overlayDialog` only. |
| `autoDismissalDuration` | `Duration?` | `null` | Hold the dialog this long after the entry animation, then dismiss it. Requires `animationType`. |
| `autoDismissWithAnimation` | `bool?` | `null` | Currently has no effect. See [Behaviour notes](#behaviour-notes-and-limitations). |
| `customDialogOnDisplay` | `Function(BuildContext)?` | `null` | `customDialog` only — called with a valid context so you can present your own dialog. |
| `enableLiquidGlass` | `bool?` | `DialogManager.enableLiquidGlass` (`false`) | Draws the dialog body on a liquid glass surface. No effect on `customDialog`. See [Liquid glass](#liquid-glass). |
| `liquidGlassSettings` | `LiquidGlassSettings?` | `DialogManager.liquidGlassSettings` | Shape, blur, saturation, tint, rim light and shadows of the glass. |

Returns a `Future<Map<String, dynamic>>` that completes when the dialog is dismissed.

---

## Returning data from a dialog

This is the feature that makes the package worth using from a business layer. `showDialog` returns a future; `dismissDialog` resolves it.

```dart
// Caller — e.g. inside a view model, with no BuildContext in sight.
final Map<String, dynamic> response = await DialogHandler.instance.showDialog(
  dialogType: DialogType.modalDialog,
  widget: const ConfirmDeleteDialog(),
);

if (response['confirmed'] == true) {
  await repository.deleteAccount();
}
```

```dart
// Inside the dialog widget.
ElevatedButton(
  onPressed: () {
    DialogHandler.instance.dismissDialog(
      dismissalResponseData: const {'confirmed': true},
    );
  },
  child: const Text('Delete'),
);
```

Dismissals that carry no data resolve the future with `const {}`.

---

## Dismissing dialogs

```dart
// Dismiss the top-most dialog.
await DialogHandler.instance.dismissDialog();

// Dismiss it and return data to the caller.
await DialogHandler.instance.dismissDialog(
  dismissalResponseData: {'status': 'cancelled'},
);

// Dismiss one specific dialog, wherever it is in the stack.
await DialogHandler.instance.dismissDialog(
  valueKey: const ValueKey<String>('session-expired'),
);

// Dismiss everything.
await DialogHandler.instance.dismissDialog(dismissAllDialog: true);
```

`valueKey` takes precedence over `dismissAllDialog`. If no visible dialog carries the key, nothing happens — pair it with `isDialogVisible` when the outcome matters.

> **Note:** dismissing by key from the middle of the stack works fully for `overlayDialog`. For the route backed types there is a caveat — see [Behaviour notes](#behaviour-notes-and-limitations).

---

## Identifying and tracking dialogs

Give a dialog a key when you want to address it later:

```dart
const sessionKey = ValueKey<String>('session-expired');

DialogHandler.instance.showDialog(
  dialogType: DialogType.overlayDialog,
  valueKey: sessionKey,
  widget: const SessionExpiredBanner(),
);
```

Then ask about it from anywhere:

```dart
// Is this specific dialog on screen?
if (DialogHandler.instance.isDialogVisible(sessionKey)) {
  return; // don't stack a duplicate
}

// What is on screen right now?
final List<DialogConfig> visible = DialogHandler.instance.visibleDialogs();
print('${visible.length} dialog(s) showing');
print(visible.map((c) => c.valueKey.value).toList());
```

A dialog created without a `valueKey` still gets one — a random key of the form `dialog_<timestamp>_<random>` — so `DialogConfig.valueKey` is never null and every dialog is always uniquely addressable.

A common guard against duplicate dialogs:

```dart
Future<void> showSessionExpired() async {
  if (DialogHandler.instance.isDialogVisible(sessionKey)) return;

  await DialogHandler.instance.showDialog(
    dialogType: DialogType.overlayDialog,
    valueKey: sessionKey,
    widget: const SessionExpiredBanner(),
  );
}
```

---

## Android back button

`DialogManager` wraps its child in a `PopScope`. While any dialog is visible the back gesture is intercepted and dismisses the top-most dialog instead of popping the route.

Opt a dialog out with `onlyDismissProgrammatically: true` — the back button will then leave it alone, and only an explicit `dismissDialog()` call closes it:

```dart
await DialogHandler.instance.showDialog(
  dialogType: DialogType.overlayDialog,
  widget: const BlockingProgressDialog(),
  onlyDismissProgrammatically: true,
);
```

---

## Animations

Set `animationType` to wrap the dialog body in an entry animation.

| `AnimationType` | Effect |
|---|---|
| `scaleToPosition` | Scales up while fading in |
| `fadeFromTopToPosition` | Fades in while sliding down a short distance |
| `fadeFromBottomToPosition` | Fades in while sliding up from off screen |
| `fadeFromLeftToPosition` | Fades in while sliding a short distance from the left |
| `fadeFromRightToPosition` | Fades in while sliding a short distance from the right |
| `fromTopToPosition` | Slides in from off screen top |
| `fromBottomToPosition` | Slides in from off screen bottom |
| `fromLeftToPosition` | Slides in from off screen left |
| `fromRightToPosition` | Slides in from off screen right |
| `fromTopToPositionThenBounce` | Slides in from the top with an elastic bounce |
| `fromBottomToPositionThenBounce` | Slides in from the bottom with an elastic bounce |

```dart
await DialogHandler.instance.showDialog(
  dialogType: DialogType.modalDialog,
  animationType: AnimationType.fromTopToPositionThenBounce,
  animationDuration: const Duration(milliseconds: 1200),
  animationReverseDuration: const Duration(milliseconds: 550),
  dialogAlignment: Alignment.topCenter,
  widget: const ErrorBanner(),
);
```

> ⚠️ **Important:** a dialog with an `animationType` but **no** `autoDismissalDuration` currently animates in and then immediately animates back out and closes itself. Pair `animationType` with `autoDismissalDuration` for banner style dialogs, and leave `animationType` unset for dialogs that must stay until the user acts. See [Behaviour notes](#behaviour-notes-and-limitations).

---

## Auto dismissal

Give a dialog a lifetime. After the entry animation completes, it waits `autoDismissalDuration`, then animates out and dismisses itself:

```dart
await DialogHandler.instance.showDialog(
  dialogType: DialogType.overlayDialog,
  animationType: AnimationType.fromTopToPositionThenBounce,
  dialogAlignment: Alignment.topCenter,
  animationDuration: const Duration(milliseconds: 1200),
  animationReverseDuration: const Duration(milliseconds: 550),
  autoDismissalDuration: const Duration(seconds: 2),
  widget: const ErrorBanner(),
);
```

`autoDismissalDuration` requires an `animationType` — the timer is driven by the animation controller, so a dialog with no animation will not auto dismiss.

Because `overlayDialog` leaves the page interactive, the combination above gives you a toast: it appears over the content, the user keeps scrolling, and it disappears on its own.

---

## Liquid glass

Set `enableLiquidGlass: true` to draw the dialog body on a liquid glass surface: the content behind it is blurred and made more colourful, with a light tint, a soft sheen and a bright rim where light catches the edge. It is off by default and needs no extra dependency.

```dart
await DialogHandler.instance.showDialog(
  dialogType: DialogType.modalDialog,
  enableLiquidGlass: true,
  widget: const Padding(
    padding: EdgeInsets.all(24),
    child: Text('Hello from behind the glass'),
  ),
);
```

The glass only shows through where your widget is transparent, so **don't give the dialog body an opaque background colour**. It sits inside the entry animation, so it animates in and out with the dialog.

Customise it with `LiquidGlassSettings`:

```dart
await DialogHandler.instance.showDialog(
  dialogType: DialogType.bottomSheetDialog,
  enableLiquidGlass: true,
  liquidGlassSettings: const LiquidGlassSettings(
    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    blur: 24,
    tintColor: Color(0x33FFFFFF),
  ),
  widget: const MySheet(),
);
```

| `LiquidGlassSettings` field | Default | What it does |
|---|---|---|
| `borderRadius` | `BorderRadius.circular(24)` | Shape of the glass. Round only the top corners for bottom sheets. |
| `blur` | `18` | Backdrop blur sigma. |
| `saturation` | `1.6` | Saturation multiplier for the backdrop. `1` disables it. |
| `tintColor` | `Color(0x1FFFFFFF)` | Translucent colour over the backdrop. Use a dark tint for dark themes. |
| `borderWidth` | `1.2` | Width of the rim. `0` removes it. |
| `highlightOpacity` | `0.6` | Strength of the rim light and sheen, `0`–`1`. |
| `lightSource` | `Alignment.topLeft` | Side the light comes from. |
| `shadows` | soft drop shadow | Painted outside the glass only, so they never darken it. |

To turn it on for every dialog, set the default on `DialogManager`. A dialog can still opt out with `enableLiquidGlass: false`:

```dart
DialogManager(
  enableLiquidGlass: true,
  liquidGlassSettings: const LiquidGlassSettings(blur: 20),
  child: const HomePage(),
)
```

The `LiquidGlass` widget is exported too, if you want the same surface elsewhere:

```dart
LiquidGlass(
  settings: const LiquidGlassSettings(),
  child: const Padding(padding: EdgeInsets.all(16), child: Text('Glass')),
)
```

> **Note:** the effect is built from a backdrop blur and painted highlights. It gives a glass look but does not bend the content behind it like a real lens. Backdrop blurs cost GPU time, so avoid stacking many glass dialogs at once on low end devices.

---

## Nested dialogs

Dialogs stack. Opening a second dialog does not close the first, and each `showDialog` future resolves independently:

```dart
DialogHandler.instance.showDialog(
  dialogType: DialogType.modalDialog,
  widget: const FirstDialog(),
);

// From inside FirstDialog — the first stays open behind this one.
DialogHandler.instance.showDialog(
  dialogType: DialogType.modalDialog,
  widget: const SecondDialog(),
);
```

`dismissDialog()` closes the top-most one, `dismissDialog(valueKey: ...)` closes a specific one, and `dismissDialog(dismissAllDialog: true)` clears the stack.

---

## Recipes

### Blurred background

`backgroundWidget` renders behind the dialog body. Combined with a blur widget — for example from [`glass_kit`](https://pub.dev/packages/glass_kit) — you get a frosted backdrop:

```dart
await DialogHandler.instance.showDialog(
  dialogType: DialogType.modalDialog,
  widget: const ModalDialogWithBlurWidget(),
  backgroundWidget: GlassContainer.clearGlass(
    borderWidth: 0,
    blur: 7,
  ),
);
```

### A toast that doesn't block the page

```dart
DialogHandler.instance.showDialog(
  dialogType: DialogType.overlayDialog,
  animationType: AnimationType.fadeFromTopToPosition,
  dialogAlignment: Alignment.topCenter,
  animationDuration: const Duration(milliseconds: 300),
  autoDismissalDuration: const Duration(seconds: 2),
  widget: const Text('Saved'),
);
```

### Wrapping a third party dialog

`customDialog` lets you keep using someone else's dialog widget while still tracking it in `visibleDialogs()`:

```dart
DialogHandler.instance.showDialog(
  dialogType: DialogType.customDialog,
  widget: const SizedBox(), // unused for customDialog
  customDialogOnDisplay: (context) {
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      topRadius: const Radius.circular(24),
      builder: (context) => const MySheet(),
    );
  },
);
```

### Showing a dialog after another is dismissed

```dart
DialogHandler.instance.showDialog(
  dialogType: DialogType.overlayDialog,
  widget: const Center(child: Text('Working…')),
);

await Future.delayed(const Duration(seconds: 2));
await DialogHandler.instance.dismissDialog();

final result = await DialogHandler.instance.showDialog(
  dialogType: DialogType.bottomSheetDialog,
  widget: NewDeviceVerificationDialog(
    onOkayPressed: () => DialogHandler.instance.dismissDialog(
      dismissalResponseData: const {'verified': true},
    ),
    onCancelPressed: () => DialogHandler.instance.dismissDialog(
      dismissalResponseData: const {'verified': false},
    ),
  ),
);
```

---

## Using a service locator

Registering the singleton with a service locator such as [`get_it`](https://pub.dev/packages/get_it) keeps your business layer free of direct references to the package, which makes it trivial to swap in a fake during tests:

```dart
import 'package:get_it/get_it.dart';
import 'package:dialog_handler/dialog_handler.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<DialogHandler>(() => DialogHandler.instance);
}
```

```dart
class CheckoutViewModel {
  Future<void> confirm() async {
    final response = await locator<DialogHandler>().showDialog(
      dialogType: DialogType.modalDialog,
      animationType: AnimationType.fromTopToPosition,
      animationDuration: const Duration(milliseconds: 300),
      widget: const ConfirmPurchaseDialog(),
    );

    if (response['confirmed'] == true) {
      await payment.charge();
    }
  }
}
```

---

## Testing

`DialogHandler.instance` and its dialog stack are process wide singletons, so drain the stack between tests to keep them independent:

```dart
setUp(() {
  final memory = DialogHandler.dialogMemory();
  while (memory.isNotEmpty) {
    memory.pop();
  }
});
```

A widget test then looks like this:

```dart
testWidgets('shows and dismisses a dialog', (tester) async {
  const key = ValueKey<String>('my-dialog');

  await tester.pumpWidget(
    MaterialApp(
      home: DialogManager(
        child: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => DialogHandler.instance.showDialog(
                dialogType: DialogType.overlayDialog,
                valueKey: key,
                widget: const Text('Hello'),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
  expect(DialogHandler.instance.isDialogVisible(key), isTrue);

  await DialogHandler.instance.dismissDialog(valueKey: key);
  await tester.pumpAndSettle();
  expect(DialogHandler.instance.isDialogVisible(key), isFalse);
});
```

---

## API reference

### `DialogHandler`

| Member | Signature | Description |
|---|---|---|
| `instance` | `static DialogHandler` | The shared singleton. |
| `showDialog` | `Future<Map<String, dynamic>> showDialog({...})` | Shows a dialog. Resolves when it is dismissed. See [parameters](#showdialog-parameters). |
| `dismissDialog` | `Future<void> dismissDialog({bool dismissAllDialog, Map<String, dynamic> dismissalResponseData, ValueKey<String>? valueKey})` | Dismisses the top-most dialog, one dialog by key, or all of them. |
| `visibleDialogs` | `List<DialogConfig> visibleDialogs()` | The configs of every dialog currently on screen, bottom of the stack first. |
| `isDialogVisible` | `bool isDialogVisible(ValueKey<String> valueKey)` | Whether a dialog carrying that key is on screen. |
| `dialogMemory` | `static DialogStack<DialogConfig> dialogMemory()` | The underlying stack. Useful in tests. |
| `returnDialogCompleter` | `void returnDialogCompleter({required Map<String, dynamic> responseData, required Completer<Map<String, dynamic>> dialogCompleterInstance})` | Completes a dialog's future. Called internally. |

### `DialogManager`

| Member | Description |
|---|---|
| `DialogManager({required Widget child, bool enableLiquidGlass = false, LiquidGlassSettings? liquidGlassSettings})` | Wraps your app, registers the show and dismiss listeners, and hosts the `PopScope` that handles the Android back button. `enableLiquidGlass` and `liquidGlassSettings` set the liquid glass defaults for every dialog. |

### `DialogConfig`

The record of one dialog. You mostly receive these from `visibleDialogs()`.

| Field | Type | Description |
|---|---|---|
| `valueKey` | `ValueKey<String>` | Never null — randomly generated when the caller omits one. |
| `dialogType` | `DialogType` | How the dialog is presented. |
| `onlyDismissProgrammatically` | `bool` | Whether the back button skips this dialog. |
| `dialogCompleterInstance` | `Completer<Map<String, dynamic>>?` | Completed on dismissal with the response data. |
| `backgroundWidget` | `Widget?` | Backdrop widget. |
| `animationDuration` | `Duration?` | Forward animation duration. |
| `animationReverseDuration` | `Duration?` | Reverse animation duration. |
| `animationType` | `AnimationType?` | Entry animation. |
| `dialogAlignment` | `AlignmentGeometry` | Alignment within the stack. |
| `autoDismissalDuration` | `Duration?` | Lifetime before self dismissal. |
| `autoDismissWithAnimation` | `bool?` | Currently unused. |
| `dialogOverlayEntry` | `OverlayEntry?` | Set once an `overlayDialog` is on screen. |
| `customDialogOnDisplay` | `Function(BuildContext)?` | Presenter callback for `customDialog`. |
| `enableLiquidGlass` | `bool?` | Whether the body is drawn on liquid glass. `null` uses the `DialogManager` default. |
| `liquidGlassSettings` | `LiquidGlassSettings?` | Liquid glass appearance. `null` uses the `DialogManager` default. |

`DialogConfig` also exposes `copyWith(...)`, the `DialogConfig.initialize(...)` factory, and `DialogConfig.randomValueKey()`. `copyWith` preserves `valueKey` unless you explicitly pass a new one, so a dialog keeps its identity for its whole life.

### `DialogStack<T>`

| Member | Description |
|---|---|
| `isEmpty` / `isNotEmpty` | Whether any dialog is recorded. |
| `push(T value)` | Adds a dialog. |
| `pop()` | Removes and returns the top-most dialog, or `null`. |
| `popAtIndex(index)` | Removes and returns the dialog at `index`. |
| `peek` | The top-most dialog without removing it. |
| `allItems` | The backing list. |
| `getDialogIndex({required T value})` | Index of a config, matched on its completer instance. |
| `update({required T preValue, required T newValue})` | Replaces a config in place. |

---

## Behaviour notes and limitations

Worth knowing before you hit them:

- **`animationType` without `autoDismissalDuration` self dismisses.** When the entry animation completes and no `autoDismissalDuration` is set, the controller reverses immediately and the dialog closes. A dialog that must wait for the user should currently be shown without an `animationType`.

- **Dismiss by key only fully works for `overlayDialog`.** Route backed dialogs (`modalDialog`, `bottomSheetDialog`, `pageDialog`) are taken off screen by popping the current route, so targeting one that is *not* on top updates the records and completes its future but removes the top-most dialog from view instead. Overlay dialogs can be dismissed by key from any position.

- **`onlyDismissProgrammatically` only guards the back button.** It does not stop a `modalDialog` from being dismissed when the user taps the background.

- **`autoDismissWithAnimation` has no effect.** The code path that reads it is not currently reached. The parameter is kept for source compatibility.

- **`backgroundWidget` and `dialogAlignment` apply to `modalDialog` and `overlayDialog` only.** `pageDialog` draws a fixed 45% black scrim; `bottomSheetDialog` is transparent and positioned by the sheet.

- **One `DialogManager` at a time.** Each one registers itself with the singleton on mount, so the most recently mounted manager receives all dialogs.

- **`DialogManager` needs a `Navigator` and an `Overlay` above it.** Place it below `MaterialApp`, not above.

---

## Compatibility

| | |
|---|---|
| Dart SDK | `>=3.4.0 <4.0.0` |
| Flutter | `>=3.22.0` |
| Platforms | Android, iOS, web, macOS, Windows, Linux |

The Flutter floor comes from `PopScope.onPopInvokedWithResult`, which powers back button handling.

---

## Example

A runnable example covering every dialog type, animation and dismissal mode lives in [`example/`](example/):

```bash
cd example
flutter run
```

---

## Contributing

Issues and pull requests are welcome. If you hit a bug, an example that reproduces it in `example/` is the fastest route to a fix.

Thanks for your time.
