import 'package:flutter/material.dart';

import '../pages/initial_page.dart';

class TransactionsRecently extends StatelessWidget {
  final String namePayment;
  final String valuePayment;
  final String detailPayment;
  final String? imagePath2;
  final IconData? icon;

  const TransactionsRecently({
    super.key,
    required this.namePayment,
    required this.valuePayment,
    required this.detailPayment,
    this.imagePath2,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[200],
            backgroundImage: imagePath2 != null
                ? AssetImage(imagePath2!)
                : null,
            child: (imagePath2 == null)
                ? Icon(icon ?? Icons.attach_money, color: Colors.black54)
                : null,
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
        ],
      ),
    );
  }
}