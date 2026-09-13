## 1.0.0

* init release

## 1.0.0+1

* added documentation

## 1.0.1

* fixed bug with dialog dismissal delay
* added `autoDismissWithAnimation` parameter to `showDialog` that controls how dialog will be dismissed

## 1.0.1+2

## 1.0.1+3
* fixed bug with dialog dismissal not responsive

* re-fixed bug with dialog dismissal delay
* removed mandatory use of handler's custom animated widget to show new dialog. This cause slight during dialog dismissal

## 1.0.2
* fixed bug with dialog not dismissable using android back button
* added `visibleDialogs` method that returns a list of currently visible dialogs
* updated documentation to include `visibleDialogs` method
* include tests coverage for dialog handler 

## 1.0.3
* added `isDialogVisible` method that returns a boolean indicating whether a dialog with the given valueKey is currently visible
* added `valueKey` parameter to `showDialog` method that is used to identify the dialog
* added `valueKey` parameter to `dismissDialog` method to dismiss dialog by key

* updated documentation to include `isDialogVisible` method
