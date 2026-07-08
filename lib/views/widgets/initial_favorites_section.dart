import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../viewmodels/contact/contact_bloc.dart';
import '../../viewmodels/contact/contact_state.dart';
import '../../theme/app_theme.dart';
import '../pages/manage_favorites_page.dart';
import '../pages/transaction_form_page.dart';
import 'add_favorite_button.dart';
import 'favorites.dart';
import 'text_button_action.dart';

class InitialFavoritesSection extends StatelessWidget {
  const InitialFavoritesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Favoritos', style: text),
            TextButtonAction(
              text: 'Gerenciar',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<ContactBloc>(),
                      child: const ManageFavoritesPage(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        BlocBuilder<ContactBloc, ContactState>(
          builder: (context, state) {
            if (state is ContactLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ContactErrorState) {
              return Text(state.message);
            }

            if (state is ContactLoadedState) {
              return SizedBox(
                height: 85,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.contacts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == state.contacts.length) {
                      return const AddFavoriteButton();
                    }

                    final contact = state.contacts[index];

                    return Favorites(
                      name: contact.name,
                      imagePath: contact.avatar,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TransactionFormPage(
                              isDeposit: false,
                              preSelectedContact: contact,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
