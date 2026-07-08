import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../viewmodels/contact/contact_bloc.dart';
import '../widgets/edit_contact_dialog.dart';
import '../../theme/app_theme.dart';

class AddFavoriteButton extends StatelessWidget {
  const AddFavoriteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: BoxBorder.all(color: Color(0xFF9E9E9E), width: .2),
          ),

          child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<ContactBloc>(),
                  child: const ContactDialog(contact: null),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
              size: 15,
              color: Color(0xFF9E9E9E),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text('Novo', style: subText),
      ],
    );
  }
}