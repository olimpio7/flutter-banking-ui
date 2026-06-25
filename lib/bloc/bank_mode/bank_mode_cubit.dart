import 'package:flutter_bloc/flutter_bloc.dart';

class BankModeCubit extends Cubit<bool>{
  BankModeCubit() : super(true);

  void toggleMode() => emit(!state);
}