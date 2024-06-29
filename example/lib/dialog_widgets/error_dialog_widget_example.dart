import 'package:flutter/material.dart';

class ErrorDialogWidgetExample extends StatelessWidget {
  const ErrorDialogWidgetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Container(
        margin: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 15,
        ),
        child: const Text(
          "An Error occured please try again !!! ",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
