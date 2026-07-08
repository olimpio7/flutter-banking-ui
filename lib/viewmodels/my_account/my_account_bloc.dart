import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/app_database.dart';

import '../../repositories/my_account_dao.dart';
import 'my_account_event.dart';
import 'my_account_state.dart';

class MyAccountBloc extends Bloc<MyAccountEvent, MyAccountState>{
  final MyAccountDao _dao;

  MyAccountBloc(this._dao) : super(MyAccountLoadingState()) {
    on<LoadMyAccountEvent>(((event, emit) async {
      emit(MyAccountLoadingState());

      try {
        final account = await _dao.getMyAccount();

        if(account == null){
          emit(MyAccountNotFoundState());
        } else {
          emit(MyAccountLoadedState(account));
        }
      } catch (e) {
        emit(MyAccountErrorState('Erro ao buscar a conta: $e'));
      }
    })
    );

    on<CreateMyAccountEvent>(((event, emit) async {
      emit(MyAccountLoadingState());

      try {
        await _dao.insertMyAccount(event.account);
        add(LoadMyAccountEvent());
      } catch (e) {
        emit(MyAccountErrorState('Erro ao criar a conta: $e'));
      }
    })
    );

    on<UpdateMyAccountEvent>(((event, emit) async {
      emit(MyAccountLoadingState());

      try {
        await _dao.updateMyAccount(event.account);
        add(LoadMyAccountEvent());
      } catch (e) {
        emit(MyAccountErrorState('Erro ao atualizar a conta: $e'));
      }
    })
    );

    on<DeleteMyAccountEvent>(((event, emit) async {
      emit(MyAccountLoadingState());

      try {
        await _dao.deleteMyAccount(event.account);
        add(LoadMyAccountEvent());
      } catch (e) {
        emit(MyAccountErrorState('Erro ao excluir a conta: $e'));
      }
    })
    );

    on<SubmitMyAccountEvent>(((event, emit) async {
      final name = event.name.trim();
      if (name.isEmpty) {
        emit(MyAccountValidationError('Por favor, informe seu nome'));
        return;
      }

      if (event.rawBalance.trim().isEmpty) {
        emit(MyAccountValidationError('Informe o saldo inicial'));
        return;
      }

      final String rawValue = event.rawBalance
          .replaceAll('R\$', '')
          .replaceAll('.', '')
          .replaceAll(',', '.')
          .trim();
          
      final double balance = double.tryParse(rawValue) ?? 0.0;

      final newAccount = MyAccountsCompanion.insert(
        name: name,
        balance: balance,
      );

      emit(MyAccountLoadingState());
      try {
        await _dao.insertMyAccount(newAccount);
        emit(MyAccountSubmitSuccess());
        add(LoadMyAccountEvent());
      } catch (e) {
        emit(MyAccountErrorState('Erro ao criar a conta: $e'));
      }
    }));
  }
}