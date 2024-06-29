import 'package:dialog_handler/dialog_handler.dart';
import 'package:flutter/material.dart';

class FullpageDialogWidget extends StatelessWidget {
  const FullpageDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: 300,
      width: 400,
      child: InkWell(
        onTap: () {
          DialogHandler.instance
              .dismissDialog(dismissalResponseData: {
            "data": "Hello World",
          });
        },
        child: const Text("asdf"),
      ),
    );
  }
}
