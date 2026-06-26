import 'package:flutter/material.dart';
import 'soft_dialog.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirmar',
    this.cancelText = 'Cancelar',
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return SoftDialog(
      title: title,
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(cancelText, style: const TextStyle(color: Colors.grey)),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            onConfirm(); // This was missing in the original code!
            Navigator.pop(context);
          },
          child: Text(confirmText),
        ),
      ],
    );
  }
}
