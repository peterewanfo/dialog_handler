import 'package:flutter/material.dart';

class NewDeviceVerificationDialog extends StatelessWidget {
  final VoidCallback? onOkayPressed;
  final VoidCallback? onCancelPressed;

  const NewDeviceVerificationDialog({
    super.key,
    required this.onOkayPressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'New Device?',
                    style: const TextStyle().copyWith(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: onCancelPressed ?? () => {},
              child: const Text(
                "aaaaaa",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
