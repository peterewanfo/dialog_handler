/// `DialogType` for different DialogTypes
///  i.   pageDialog which executes showGeneralDialog with desired widget
///  ii.  bottomSheetDialog which executes showModalBottomSheet with desired widget
///  iii. modalDialog which executes showDialog with desired widget
///  iv.  overlayDialog which executes dialog as overlay
enum DialogType {
  pageDialog,
  bottomSheetDialog,
  modalDialog,
  overlayDialog,
}
