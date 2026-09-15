import 'package:dialog_handler/dialog_handler.dart';
import 'package:flutter/material.dart';

/// Dialog body for the liquid glass examples. It has no background colour so
/// the glass surface drawn by the handler shows through.
class LiquidGlassDialogWidget extends StatelessWidget {
  final bool isBottomSheet;

  const LiquidGlassDialogWidget({super.key, this.isBottomSheet = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isBottomSheet ? double.infinity : 300,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
      child: SafeArea(
        top: false,
        bottom: isBottomSheet,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.water_drop_outlined, size: 40),
            const SizedBox(height: 12),
            const Text(
              'Liquid Glass',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'The content behind this dialog is blurred and shows through the glass.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => DialogHandler.instance.dismissDialog(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
