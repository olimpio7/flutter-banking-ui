import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/database/dao/my_account_dao.dart';
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
  }
}