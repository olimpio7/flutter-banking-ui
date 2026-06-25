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

// VARIÁVEIS GLOBAIS BLINDADAS CONTRA COR ESCURA
TextStyle get text {
  final isDark = ThemeCubit.instance.state == ThemeMode.dark;
  return TextStyle(
    fontSize: 16,
    fontFamily: 'Roble',
    color: isDark ? const Color(0xFFFFFFFF) : Colors.black87, // Branco absoluto no escuro!
  );
}

TextStyle get subText {
  final isDark = ThemeCubit.instance.state == ThemeMode.dark;
  return TextStyle(
    fontSize: 12,
    fontFamily: 'Roble',
    color: isDark ? const Color(0xFFB0B3B8) : const Color(0xFF757575), // Cinza claro prateado e nítido
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Roble',
      scaffoldBackgroundColor: AppColors.bgLight,
      cardColor: AppColors.surfaceLight,
      iconTheme: const IconThemeData(color: Colors.black87),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Roble',
      scaffoldBackgroundColor: AppColors.bgDark,
      cardColor: AppColors.surfaceDark,
      
      // Força todos os ícones do app a ficarem brancos no modo escuro
      iconTheme: const IconThemeData(color: Colors.white),
      
      // Configuração global para garantir que o Flutter use as cores de texto corretas
      colorScheme: const ColorScheme.dark(
        primary: Colors.blue,
        onPrimary: Colors.white,
        surface: AppColors.containerDark,
        onSurface: Colors.white, // Garante que textos automáticos fiquem brancos
      ),
      
      // Garante que os textos padrões do ThemeData também herdem o branco
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Color(0xFFB0B3B8)),
      ),
    );
  }
}