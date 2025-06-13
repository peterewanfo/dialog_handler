/// `DialogType` difines different Dialog Variations of dialogs
///  i.   pageDialog which executes `showGeneralDialog` with desired widget
///  ii.  bottomSheetDialog which executes `showModalBottomSheet` with desired widget
///  iii. modalDialog which executes `showDialog` with desired widget
///  iv.  overlayDialog which executes an overlay as dialog
enum DialogType {
  pageDialog,
  bottomSheetDialog,
  modalDialog,
  overlayDialog,
  customDialog,
}

/// `AnimationType` Defines Animation transition
/// Note: AnimationType does not apply for bottomSheetDialog Types
enum AnimationType {
  fadeFromTopToPosition,
  fadeFromBottomToPosition,
  fadeFromLeftToPosition,
  fadeFromRightToPosition,
  scaleToPosition,
  fromRightToPosition,
  fromLeftToPosition,
  fromBottomToPosition,
  fromTopToPosition,
  fromTopToPositionThenBounce,
  fromBottomToPositionThenBounce,
}

enum DialogListenerKeys {
  dismissDialog,
  completedAnimationDismissal,
}
