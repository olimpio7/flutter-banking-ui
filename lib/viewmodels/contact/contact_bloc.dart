import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drift/drift.dart' as drift;
import '../../data/app_database.dart';

import '../../repositories/contact_dao.dart';
import '../../repositories/transaction_dao.dart';
import 'contact_event.dart';
import 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactDao _dao;
  final TransactionDao _transactionDao;

  ContactBloc(this._dao, this._transactionDao) : super(ContactLoadingState()) {
    on<LoadContactsEvent>((event, emit) async{
      emit(ContactLoadingState());
      
      try {
        final contacts = await _dao.getAllContacts();
        
        emit(ContactLoadedState(contacts: contacts));
      } catch (e) {
        emit(ContactErrorState('Erro ao carregar contatos: $e'));
        }
    },
  );
    on<CreateContactEvent>((event, emit) async {
      emit(ContactLoadingState());
      
      try {
        await _dao.insertContact(event.contact);
        add(LoadContactsEvent());
      } catch (e) {
        emit(ContactErrorState('Erro ao criar contato: $e'));
      }
    },
    );

    on<UpdateContactEvent>((event, emit) async {
      emit(ContactLoadingState());
      
      try {
        await _dao.updateContact(event.contact);
        add(LoadContactsEvent());
      } catch (e) {
        emit(ContactErrorState('Erro ao atualizar contato: $e'));
      }
    },
    );

    on<DeleteContactEvent>((event, emit) async {
  emit(ContactLoadingState());

  try {

    final hasTransactions =
        await _transactionDao
            .hasTransactionsForContact(
              event.contact.id,
            );

    if (hasTransactions) {

      emit(
        ContactErrorState(
          'Não é possível excluir este favorito porque existem transações vinculadas.',
        ),
      );

      add(LoadContactsEvent());

      return;
    }

    await _dao.deleteContact(event.contact);

    add(LoadContactsEvent());

  } catch (e) {
    emit(
      ContactErrorState(
        'Erro ao excluir contato: $e',
      ),
    );
  }
});

    on<SubmitContactEvent>((event, emit) async {
      final name = event.name.trim();
      if (name.isEmpty) {
        emit(ContactValidationError('O nome não pode ser vazio.'));
        return;
      }

      emit(ContactLoadingState());
      try {
        if (event.originalContact != null) {
          await _dao.updateContact(event.originalContact!.copyWith(
            name: name,
            avatar: drift.Value(event.avatarPath),
          ));
        } else {
          await _dao.insertContact(ContactsCompanion.insert(
            name: name,
            avatar: drift.Value(event.avatarPath),
          ));
        }
        emit(ContactSubmitSuccess());
        add(LoadContactsEvent());
      } catch (e) {
        emit(ContactErrorState('Erro ao salvar contato: $e'));
      }
    });
  }

}