import 'package:dialog_handler/dialog_handler.dart';
import 'package:flutter/material.dart';

class BottomSheetDialogWidget extends StatelessWidget {
  const BottomSheetDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        DialogHandler.instance.dismissDialog();
      },
      child: Container(
        color: Colors.pink,
        height: 600,
        width: double.infinity,
        child: Text(
            'is dialog visible:  ${DialogHandler.instance.isDialogVisible(const ValueKey<String>("bottomSheetDialog"))}'),
      ),
    );
  }
}
