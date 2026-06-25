import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_colors.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);
  static final ThemeCubit instance = ThemeCubit();

  void toggleTheme(bool isDark) {
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}

// VARIÁVEIS GLOBAIS COM TAMANHOS REDUZIDOS (16 e 13)
TextStyle get text {
  final isDark = ThemeCubit.instance.state == ThemeMode.dark;
  return TextStyle(
    fontSize: 16, // Reduzido de 18 para 16
    fontFamily: 'Roble',
    color: isDark ? const Color(0xFFF5F5F7) : Colors.black87,
  );
}

TextStyle get subText {
  final isDark = ThemeCubit.instance.state == ThemeMode.dark;
  return TextStyle(
    fontSize: 13, // Reduzido de 15 para 13
    fontFamily: 'Roble',
    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF757575), // Cinza bem mais nítido
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Roble',
      scaffoldBackgroundColor: AppColors.bgLight,
      cardColor: AppColors.surfaceLight,
      // Garante ícones escuros no modo claro
      iconTheme: const IconThemeData(color: Colors.black87),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Roble',
      scaffoldBackgroundColor: AppColors.bgDark,
      cardColor: AppColors.surfaceDark,
      
      // SOLUÇÃO PARA O BOTÃO ENVIAR/RECEBER: Força contraste total
      iconTheme: const IconThemeData(color: Colors.white),
      primaryIconTheme: const IconThemeData(color: Colors.white),
      
      // Ajusta o esquema de cores para os componentes saberem que o fundo é escuro
      colorScheme: const ColorScheme.dark(
        primary: Colors.blue,
        onPrimary: Colors.white, // Força texto branco sobre botões primários
        surface: AppColors.containerDark,
        onSurface: Colors.white, // Força ícones/textos brancos em superfícies
      ),
    );
  }
}