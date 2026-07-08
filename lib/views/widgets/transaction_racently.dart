import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'avatar.dart';

class TransactionsRecently extends StatelessWidget {
  final String namePayment;
  final String valuePayment;
  final String detailPayment;
  final String? avatar;
  final String? contactName;
  final IconData? icon;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const TransactionsRecently({
    super.key,
    required this.namePayment,
    required this.valuePayment,
    required this.detailPayment,
    this.avatar,
    this.contactName,
    this.icon,
    this.onDelete, 
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          UserAvatar(
            name: contactName ?? namePayment,
            imagePath: avatar,
            radius: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(namePayment, style: text),
                Text(detailPayment, style: subText),
              ],
            ),
          ),


          Text(
            valuePayment,
            style: subText.copyWith(
              color: valuePayment.startsWith('-')
                  ? Colors.red
                  : Colors.green[800],
            ),
          ),
          if (onEdit !=null) ...[
            const SizedBox(width: 8,),
            IconButton(
              onPressed: onEdit, 
              icon: const Icon(Icons.edit, color: Colors.blue),
            ),
          ],
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}