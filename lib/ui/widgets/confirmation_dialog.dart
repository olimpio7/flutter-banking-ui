import 'package:flutter/material.dart';
import 'package:flutter_banking_ui/ui/widgets/soft_container.dart';

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
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SoftContainer(
        borderRadius: 20,
        color: Colors.grey[100], 
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style:const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 6)),

            Text(
              message,
              textAlign: TextAlign.center,
            ),

             const Padding(padding: EdgeInsets.symmetric(vertical: 6)),

             Row(
              children: [
                Expanded(
                  child: TextButton(onPressed: () {
                    Navigator.pop(context);
                  }, 
                  child: Text(cancelText), 
                  ) 
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    child: Text(confirmText), 
                  ) 
                )
              ],
             )
          ],
        ),
      ),
    );
  }
}
