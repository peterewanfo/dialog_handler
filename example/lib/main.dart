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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dialog Handler',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Dialog Handler Examples'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DialogManager(
      child: Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              //
              // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
              // action in the IDE, or press "p" in the console), to see the
              // wireframe for each widget.
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
