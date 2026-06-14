import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/contact/contact_bloc.dart';
import '../pages/add_favorites_page.dart';
import '../pages/initial_page.dart';

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ContactBloc>(),
                    child: const AddFavoritePage(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ),
        const SizedBox(height: 4),
        Text('Novo', style: subText),
      ],
    );
  }
}