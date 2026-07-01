import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import 'soft_container.dart';
import 'avatar.dart';

class InitialBalanceHeader extends StatelessWidget {
  final MyAccount account;

  const InitialBalanceHeader({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final formattedBalance = AppFormatters.formatNumberOnly(account.balance);
    final parts = formattedBalance.split(',');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: SoftContainer(
                    padding: const EdgeInsets.fromLTRB(1, 1, 12, 1),
                    child: Row(
                      children: [
                        UserAvatar(
                          name: account.name,
                          imagePath: account.imagePath,
                          radius: 25,
                        ),
                        const Padding(padding: EdgeInsets.only(right: 8.0)),
                        Text(account.name, style: text),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SoftContainer(child: Icon(Icons.notifications_none)),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 8.0)),
        Text('Seu Saldo', style: subText),
        Row(
          children: [
            Text(
              "R\$ ${parts[0]},",
              style: text.copyWith(fontSize: 45),
            ),
            Text(parts.length > 1 ? parts[1] : '00', style: subText.copyWith(fontSize: 40)),
          ],
        ),
      ],
    );
  }
}
