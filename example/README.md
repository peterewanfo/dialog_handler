# Dialog Handler — Example App

A runnable Flutter app demonstrating every feature of the [`dialog_handler`](../README.md) package.

## Running it

```bash
cd example
flutter pub get
flutter run
```

The example depends on the local package via a path override, so any change you make in `../lib` is picked up on the next run or hot restart.

## What's in here

The home screen is a single scrolling list of buttons, grouped by the feature each one demonstrates.

### Dialog types

| Button | Demonstrates |
|---|---|
| Show BottomSheet Dialog | An `overlayDialog` that reports its own visibility with `isDialogVisible`, keyed `bottomSheetDialog` |
| Show Modal Dialog | A plain `modalDialog` |
| Show Modal Dialog With Background | `backgroundWidget` with a `glass_kit` blur for a frosted backdrop |
| Show FullPage Dialog | A `pageDialog` that dismisses on tap |

### Animations

Each button shows a `modalDialog` with a different `AnimationType` — `scaleToPosition`, `fromTopToPosition` (centered and top aligned), `fromBottomToPosition`, `fromLeftToPosition` and `fromRightToPosition` — with `animationDuration` and `animationReverseDuration` varied to show their effect.

### Error dialogs

Top aligned banner style dialogs, including a bouncing variant using `fromTopToPositionThenBounce`, and an `overlayDialog` version that leaves the page behind it interactive.

### Auto dismissal

Dialogs that close themselves after `autoDismissalDuration`, including a nested case where a second dialog is opened while the first is still counting down.

### Other

| Button | Demonstrates |
|---|---|
| USING A DIFFERENT DIALOG | `customDialog` wrapping `showCupertinoModalBottomSheet` from `modal_bottom_sheet`, so a third party dialog is still tracked by the handler |
| SHOW A FRESH DIALOG AFTER DISMISS OF PREV DIALOG | Sequencing — dismissing an overlay, then awaiting a bottom sheet that returns data |

## Where to look in the source

| File | Contents |
|---|---|
| [`lib/main.dart`](lib/main.dart) | Every example, and the `DialogManager` that hosts them |
| [`lib/dialog_widgets/`](lib/dialog_widgets/) | The dialog bodies — plain widgets, no base class required |
| [`lib/extension.dart`](lib/extension.dart) | A small `InkWell` helper used to strip splash effects |

## Third party packages used

Only for the demos — none of these are required by `dialog_handler` itself:

- [`glass_kit`](https://pub.dev/packages/glass_kit) — the blurred `backgroundWidget`
- [`modal_bottom_sheet`](https://pub.dev/packages/modal_bottom_sheet) — the `customDialog` demo

## Full documentation

See the [package README](../README.md) for the complete API reference, recipes and behaviour notes.
