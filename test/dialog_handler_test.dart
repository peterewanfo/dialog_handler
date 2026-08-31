import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dialog_handler/dialog_handler.dart';

void main() {
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
}
