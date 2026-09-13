import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dialog_handler/dialog_handler.dart';

void main() {
  // The dialog memory is a process-wide singleton, and not every case dismisses
  // what it opens, so drain it between tests to keep them order independent.
  setUp(() {
    final DialogStack<DialogConfig> memory = DialogHandler.dialogMemory();
    while (memory.isNotEmpty) {
      memory.pop();
    }
  });

  testWidgets('DialogHandler visibleDialogs list tracking and basic dismissal',
      (WidgetTester tester) async {
    // Verify starting state is empty
    expect(DialogHandler.instance.visibleDialogs(), isEmpty);

    // Build DialogManager widget tree
    await tester.pumpWidget(
      MaterialApp(
        home: DialogManager(
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    DialogHandler.instance.showDialog(
                      dialogType: DialogType.modalDialog,
                      widget: const Text('Test Dialog 1'),
                    );
                  },
                  child: const Text('Open Dialog'),
                );
              },
            ),
          ),
        ),
      ),
    );

    expect(DialogHandler.instance.visibleDialogs(), isEmpty);

    // Tap button to show dialog
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    // Verify dialog appears in visibleDialogs
    final visible = DialogHandler.instance.visibleDialogs();
    expect(visible.length, 1);
    expect(visible[0].dialogType, DialogType.modalDialog);

    // Dismiss dialog using dismissDialog
    await DialogHandler.instance.dismissDialog();
    await tester.pumpAndSettle();

    // Verify visibleDialogs is empty again
    expect(DialogHandler.instance.visibleDialogs(), isEmpty);
  });

  testWidgets(
      'DialogHandler visibleDialogs handles dialogConfigToDelete dismissal properly',
      (WidgetTester tester) async {
    // Verify starting state is empty
    expect(DialogHandler.instance.visibleDialogs(), isEmpty);

    // Build DialogManager widget tree
    await tester.pumpWidget(
      MaterialApp(
        home: DialogManager(
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    DialogHandler.instance.showDialog(
                      dialogType: DialogType.modalDialog,
                      widget: const SizedBox(
                        key: Key('dialog_content'),
                        width: 100,
                        height: 100,
                      ),
                    );
                  },
                  child: const Text('Open Dialog'),
                );
              },
            ),
          ),
        ),
      ),
    );

    // Tap button to show dialog
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    final visible = DialogHandler.instance.visibleDialogs();
    expect(visible.length, 1);

    // Find and tap the InkWell background of the dialog to trigger self dismissal (dialogConfigToDelete)
    // The dialog builder uses InkWell wrapping Stack
    final inkWellFinder = find.byWidgetPredicate(
      (widget) => widget is InkWell && widget.child is Stack,
    );
    expect(inkWellFinder, findsOneWidget);

    await tester.tap(inkWellFinder);
    await tester.pumpAndSettle();

    // Verify visibleDialogs is empty (which proves dialogConfigToDelete removed it from the stack)
    expect(DialogHandler.instance.visibleDialogs(), isEmpty);
  });

  testWidgets(
      'DialogHandler visibleDialogs dismisses overlay dialog on back button',
      (WidgetTester tester) async {
    // Verify starting state is empty
    expect(DialogHandler.instance.visibleDialogs(), isEmpty);

    // Build DialogManager widget tree
    await tester.pumpWidget(
      MaterialApp(
        home: DialogManager(
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    DialogHandler.instance.showDialog(
                      dialogType: DialogType.overlayDialog,
                      widget: const Text('Overlay Dialog Content'),
                    );
                  },
                  child: const Text('Open Overlay Dialog'),
                );
              },
            ),
          ),
        ),
      ),
    );

    // Tap button to show overlay dialog
    await tester.tap(find.text('Open Overlay Dialog'));
    await tester.pumpAndSettle();

    // Verify overlay dialog is visible
    expect(DialogHandler.instance.visibleDialogs().length, 1);

    // Simulate Android system back button click
    final bool didPop = await tester.binding.handlePopRoute();

    // Because canPop is false when overlay is open, handlePopRoute will return true (handled / blocked by PopScope)
    expect(didPop, isTrue);

    await tester.pumpAndSettle();

    // Verify overlay dialog is now dismissed and visibleDialogs is empty
    expect(DialogHandler.instance.visibleDialogs(), isEmpty);
  });

  testWidgets(
      'DialogHandler visibleDialogs does NOT dismiss overlay dialog on back button if onlyDismissProgrammatically is true',
      (WidgetTester tester) async {
    // Verify starting state is empty
    expect(DialogHandler.instance.visibleDialogs(), isEmpty);

    // Build DialogManager widget tree
    await tester.pumpWidget(
      MaterialApp(
        home: DialogManager(
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    DialogHandler.instance.showDialog(
                      dialogType: DialogType.overlayDialog,
                      onlyDismissProgrammatically: true,
                      widget: const Text('Overlay Dialog Content'),
                    );
                  },
                  child: const Text('Open Non-Dismissible Overlay Dialog'),
                );
              },
            ),
          ),
        ),
      ),
    );

    // Tap button to show overlay dialog
    await tester.tap(find.text('Open Non-Dismissible Overlay Dialog'));
    await tester.pumpAndSettle();

    // Verify overlay dialog is visible
    expect(DialogHandler.instance.visibleDialogs().length, 1);

    // Simulate Android system back button click
    final bool didPop = await tester.binding.handlePopRoute();

    // The pop should be handled/intercepted (so didPop is true), but the dialog should NOT be dismissed
    expect(didPop, isTrue);

    await tester.pumpAndSettle();

    // Verify overlay dialog is still visible and not dismissed
    expect(DialogHandler.instance.visibleDialogs().length, 1);
  });

  test('DialogConfig valueKey defaults to a unique randomized key', () {
    final Set<String> generatedKeys = <String>{};

    for (int i = 0; i < 5000; i++) {
      final DialogConfig config = DialogConfig.initialize(
        onlyDismissProgrammatically: false,
        dialogType: DialogType.overlayDialog,
        dialogAlignment: AlignmentDirectional.center,
      );
      generatedKeys.add(config.valueKey.value);
    }

    expect(generatedKeys.length, 5000);
  });

  test('DialogConfig valueKey honours a caller supplied key', () {
    final DialogConfig config = DialogConfig.initialize(
      onlyDismissProgrammatically: false,
      dialogType: DialogType.overlayDialog,
      dialogAlignment: AlignmentDirectional.center,
      valueKey: const ValueKey<String>('my-dialog'),
    );

    expect(config.valueKey, const ValueKey<String>('my-dialog'));
  });

  test('DialogConfig copyWith preserves valueKey unless overridden', () {
    final DialogConfig config = DialogConfig.initialize(
      onlyDismissProgrammatically: false,
      dialogType: DialogType.overlayDialog,
      dialogAlignment: AlignmentDirectional.center,
    );

    // A copy made to attach the overlay entry must keep the same identity.
    final DialogConfig copied = config.copyWith(
      dialogOverlayEntry: OverlayEntry(builder: (_) => const SizedBox()),
    );
    expect(copied.valueKey, config.valueKey);

    final DialogConfig rekeyed = config.copyWith(
      valueKey: const ValueKey<String>('other'),
    );
    expect(rekeyed.valueKey, const ValueKey<String>('other'));
  });

  testWidgets('DialogHandler isDialogVisible tracks a dialog by its valueKey',
      (WidgetTester tester) async {
    expect(DialogHandler.instance.visibleDialogs(), isEmpty);

    const ValueKey<String> dialogKey = ValueKey<String>('tracked-dialog');

    await tester.pumpWidget(
      MaterialApp(
        home: DialogManager(
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    DialogHandler.instance.showDialog(
                      dialogType: DialogType.overlayDialog,
                      widget: const Text('Keyed Dialog'),
                      valueKey: dialogKey,
                    );
                  },
                  child: const Text('Open Dialog'),
                );
              },
            ),
          ),
        ),
      ),
    );

    expect(DialogHandler.instance.isDialogVisible(dialogKey), isFalse);

    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    expect(DialogHandler.instance.isDialogVisible(dialogKey), isTrue);

    // An unrelated key must not match.
    expect(
      DialogHandler.instance
          .isDialogVisible(const ValueKey<String>('some-other-dialog')),
      isFalse,
    );

    await DialogHandler.instance.dismissDialog();
    await tester.pumpAndSettle();

    expect(DialogHandler.instance.isDialogVisible(dialogKey), isFalse);
  });

  testWidgets(
      'DialogHandler dismissDialog removes the dialog matching valueKey',
      (WidgetTester tester) async {
    const ValueKey<String> keyA = ValueKey<String>('dialog-a');
    const ValueKey<String> keyB = ValueKey<String>('dialog-b');
    const ValueKey<String> keyC = ValueKey<String>('dialog-c');

    late Future<Map<String, dynamic>> dialogBResult;

    await tester.pumpWidget(
      MaterialApp(
        home: DialogManager(
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    DialogHandler.instance.showDialog(
                      dialogType: DialogType.overlayDialog,
                      widget: const Text('A'),
                      valueKey: keyA,
                    );
                    dialogBResult = DialogHandler.instance.showDialog(
                      dialogType: DialogType.overlayDialog,
                      widget: const Text('B'),
                      valueKey: keyB,
                    );
                    DialogHandler.instance.showDialog(
                      dialogType: DialogType.overlayDialog,
                      widget: const Text('C'),
                      valueKey: keyC,
                    );
                  },
                  child: const Text('Open Dialogs'),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Dialogs'));
    await tester.pumpAndSettle();

    expect(DialogHandler.instance.visibleDialogs().length, 3);

    // Dismiss the middle dialog, not the top of the stack.
    await DialogHandler.instance.dismissDialog(
      valueKey: keyB,
      dismissalResponseData: const {'dismissed': 'b'},
    );
    await tester.pumpAndSettle();

    expect(DialogHandler.instance.isDialogVisible(keyB), isFalse);
    expect(DialogHandler.instance.isDialogVisible(keyA), isTrue);
    expect(DialogHandler.instance.isDialogVisible(keyC), isTrue);
    expect(DialogHandler.instance.visibleDialogs().length, 2);

    // The dismissed dialog's future resolves with the supplied response data.
    expect(await dialogBResult, const {'dismissed': 'b'});

    // Its widget is gone while the others stay on screen.
    expect(find.text('B'), findsNothing);
    expect(find.text('A'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
  });

  testWidgets('DialogHandler dismissDialog with an unknown valueKey is a no-op',
      (WidgetTester tester) async {
    const ValueKey<String> keyA = ValueKey<String>('only-dialog');

    await tester.pumpWidget(
      MaterialApp(
        home: DialogManager(
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    DialogHandler.instance.showDialog(
                      dialogType: DialogType.overlayDialog,
                      widget: const Text('Only'),
                      valueKey: keyA,
                    );
                  },
                  child: const Text('Open Dialog'),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();
    expect(DialogHandler.instance.visibleDialogs().length, 1);

    await DialogHandler.instance.dismissDialog(
      valueKey: const ValueKey<String>('not-showing'),
    );
    await tester.pumpAndSettle();

    // The visible dialog is untouched.
    expect(DialogHandler.instance.visibleDialogs().length, 1);
    expect(DialogHandler.instance.isDialogVisible(keyA), isTrue);
    expect(find.text('Only'), findsOneWidget);
  });
}
