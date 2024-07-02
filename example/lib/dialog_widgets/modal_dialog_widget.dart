import 'package:flutter/material.dart';

class ModalDialogWidget extends StatelessWidget {
  const ModalDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          color: Colors.red,
          height: 300,
          width: double.infinity,
        ),
      ],
    );
  }
}
