import 'package:example/dialog_widgets/bottomsheet_dialog_widget.dart';
import 'package:example/dialog_widgets/error_dialog_widget_example.dart';
import 'package:example/dialog_widgets/modal_dialog_widget.dart';
import 'package:example/extension.dart';
import 'package:flutter/material.dart';
import 'package:dialog_handler/dialog_handler.dart';
import 'package:glass_kit/glass_kit.dart';

import 'dialog_widgets/modal_dialog_with_blur_widget.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dialog Handler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Dialog Handler Examples'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DialogManager(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dialog Examples"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),

                const Text(
                  "=============DIALOGS EXAMPLE============",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                /// BOTTOM SHEET DIALOG EXAMPLE
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    await DialogHandler.instance.showDialog(
                      dialogType: DialogType.bottomSheetDialog,
                      widget: InkWell(
                        onTap: () async {
                          await DialogHandler.instance.showDialog(
                            dialogType: DialogType.bottomSheetDialog,
                            widget: Container(
                              height: 200,
                              color: Colors.blue,
                            ),
                          );
                        },
                        child: const BottomSheetDialogWidget(),
                      ),
                    );
                  },
                  child: const Text(
                    'Show BottomSheet Dialog',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                /// MODAL DIALOG EXAMPLE
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    await DialogHandler.instance.showDialog(
                      dialogType: DialogType.modalDialog,
                      widget: const ModalDialogWidget(),
                    );
                  },
                  child: const Text(
                    'Show Modal Dialog',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                /// MODAL DAILOG WITH BLUR BACKGROUND
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    await DialogHandler.instance.showDialog(
                      dialogType: DialogType.modalDialog,
                      widget: const ModalDialogWithBlurWidget(),
                      backgroundWidget: GlassContainer.clearGlass(
                        borderWidth: 0,
                        blur: 7,
                      ),
                    );
                  },
                  child: const Text(
                    'Show Modal Dialog With Background',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                /// FULLPAGE DIALOG
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    await DialogHandler.instance.showDialog(
                      dialogType: DialogType.pageDialog,
                      widget: InkWell(
                        onTap: () {
                          DialogHandler.instance.dismissDialog();
                        },
                        child: Container(
                          color: Colors.red,
                          height: 300,
                          width: double.infinity,
                        ),
                      ).noShadow,
                    );
                  },
                  child: const Text(
                    'Show FullPage Dialog',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "==========DIALOGS WITH ANIMATIONS========",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                /// MODAL DIALOG EXAMPLE WITH ANIMATION: SCALE TO POSITION
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    await DialogHandler.instance.showDialog(
                      dialogType: DialogType.modalDialog,
                      animationType: AnimationType.scaleToPosition,
                      animationDuration: const Duration(milliseconds: 300),
                      widget: const ModalDialogWidget(),
                    );
                  },
                  child: const Text(
                    'Scale To Position Dialog',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                /// MODAL DIALOG EXAMPLE: FROM TOP TO POSITION
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    await DialogHandler.instance.showDialog(
                      dialogType: DialogType.modalDialog,
                      animationType: AnimationType.fromTopToPosition,
                      animationDuration: const Duration(milliseconds: 300),
                      widget: const ModalDialogWidget(),
                    );
                  },
                  child: const Text(
                    'Dialog from Top To CenterPosition',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                /// MODAL DIALOG EXAMPLE: FROM TOP TO POSITION
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    await DialogHandler.instance.showDialog(
                      dialogType: DialogType.modalDialog,
                      animationType: AnimationType.fromTopToPosition,
                      dialogAlignment: Alignment.topCenter,
                      animationDuration: const Duration(milliseconds: 300),
                      widget: const ModalDialogWidget(),
                    );
                  },
                  child: const Text(
                    'Dialog from Top To TopPosition',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                /// MODAL DIALOG EXAMPLE: FROM BOTTOM TO POSITION
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    await DialogHandler.instance.showDialog(
                      dialogType: DialogType.modalDialog,
                      animationType: AnimationType.fromBottomToPosition,
                      animationDuration: const Duration(milliseconds: 300),
                      widget: const ModalDialogWidget(),
                    );
                  },
                  child: const Text(
                    'Dialog from Bottom To Position',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                /// MODAL DIALOG EXAMPLE: FROM LEFT TO POSITION
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    await DialogHandler.instance.showDialog(
                      dialogType: DialogType.modalDialog,
                      animationType: AnimationType.fromLeftToPosition,
                      animationDuration: const Duration(milliseconds: 300),
                      widget: const ModalDialogWidget(),
                    );
                  },
                  child: const Text(
                    'Dialog from Left To Position',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                /// MODAL DIALOG EXAMPLE: FROM RIGHT TO POSITION
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    await DialogHandler.instance.showDialog(
                      dialogType: DialogType.modalDialog,
                      animationType: AnimationType.fromRightToPosition,
                      animationDuration: const Duration(milliseconds: 300),
                      widget: const ModalDialogWidget(),
                    );
                  },
                  child: const Text(
                    'Dialog from Right To Position',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "==========ERROR DIALOGS EXAMPLE========",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                /// ERROR DIALOG EXAMPLE
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    await DialogHandler.instance.showDialog(
                      dialogType: DialogType.modalDialog,
                      animationType: AnimationType.fromTopToPosition,
                      dialogAlignment: Alignment.topCenter,
                      animationDuration: const Duration(milliseconds: 300),
                      widget: const ErrorDialogWidgetExample(),
                    );
                  },
                  child: const Text(
                    'Error Dialog Example',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                /// ERROR DIALOG EXAMPLE
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    await DialogHandler.instance.showDialog(
                      dialogType: DialogType.modalDialog,
                      animationType: AnimationType.fromTopToPositionThenBounce,
                      dialogAlignment: Alignment.topCenter,
                      animationDuration: const Duration(milliseconds: 1200),
                      animationReverseDuration:
                          const Duration(milliseconds: 550),
                      widget: const ErrorDialogWidgetExample(),
                    );
                  },
                  child: const Text(
                    'BOUNCING Error Dialog Example',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                /// ERROR DIALOG EXAMPLE
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    await DialogHandler.instance.showDialog(
                      dialogType: DialogType.overlayDialog,
                      animationType: AnimationType.fromTopToPositionThenBounce,
                      dialogAlignment: Alignment.topCenter,
                      animationDuration: const Duration(milliseconds: 1200),
                      animationReverseDuration:
                          const Duration(milliseconds: 550),
                      widget: const ErrorDialogWidgetExample(),
                      autoDismissalDuration: const Duration(seconds: 2),
                    );
                  },
                  child: const Text(
                    'Interractable Body Dialog Example',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "====AUTO DISMISSAL DIALOGS EXAMPLE====",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                /// ERROR DIALOG EXAMPLE
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    await DialogHandler.instance.showDialog(
                      dialogType: DialogType.modalDialog,
                      animationType: AnimationType.fromTopToPositionThenBounce,
                      dialogAlignment: Alignment.topCenter,
                      animationDuration: const Duration(milliseconds: 400),
                      animationReverseDuration:
                          const Duration(milliseconds: 400),
                      widget: const ErrorDialogWidgetExample(),
                      autoDismissalDuration: const Duration(seconds: 2),
                    );
                  },
                  child: const Text(
                    'Auto Dismissal Dialog Example',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                /// ERROR DIALOG EXAMPLE
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    DialogHandler.instance.showDialog(
                      dialogType: DialogType.modalDialog,
                      animationType: AnimationType.fromTopToPositionThenBounce,
                      dialogAlignment: Alignment.topCenter,
                      animationDuration: const Duration(milliseconds: 300),
                      widget: const ErrorDialogWidgetExample(),
                      autoDismissalDuration: const Duration(seconds: 2),
                    );
                    Future.delayed(const Duration(seconds: 1));
                    DialogHandler.instance.showDialog(
                      dialogType: DialogType.modalDialog,
                      animationType: AnimationType.fromTopToPositionThenBounce,
                      dialogAlignment: Alignment.topCenter,
                      animationDuration: const Duration(milliseconds: 1400),
                      animationReverseDuration:
                          const Duration(milliseconds: 1400),
                      widget: const ErrorDialogWidgetExample(),
                      autoDismissalDuration: const Duration(seconds: 4),
                    );
                  },
                  child: const Text(
                    'Auto Dismissal Nested Dialog Example',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
