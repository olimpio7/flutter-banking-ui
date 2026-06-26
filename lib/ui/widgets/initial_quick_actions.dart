import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/contact/contact_bloc.dart';
import '../../bloc/my_account/my_account_bloc.dart';
import '../../bloc/transactions/transaction_bloc.dart';
import '../pages/transaction_form_page.dart';
import 'action_button.dart';

class InitialQuickActions extends StatelessWidget {
  const InitialQuickActions({super.key});

  void _openTransactionForm(BuildContext context, bool isDeposit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<TransactionBloc>()),
            BlocProvider.value(value: context.read<MyAccountBloc>()),
            BlocProvider.value(value: context.read<ContactBloc>()),
          ],
          child: TransactionFormPage(isDeposit: isDeposit),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: ActionButton(
              textAction: 'Enviar',
              icon: Icons.north_east,
              iconRight: true,
              onTap: () => _openTransactionForm(context, false),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
          ),
          Expanded(
            child: ActionButton(
              textAction: 'Receber',
              icon: Icons.south_west,
              onTap: () => _openTransactionForm(context, true),
            ),
          ),
        ],
      ),
    );
  }
}
