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

TextStyle get text {
  return const TextStyle(
    fontSize: 16,
    fontFamily: 'Roble',
  );
}

TextStyle get subText {
  return const TextStyle(
    fontSize: 12,
    fontFamily: 'Roble',
    color: Colors.grey, 
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
    return ThemeData.dark().copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDark,
      cardColor: AppColors.surfaceDark,
      
      iconTheme: const IconThemeData(color: Colors.white),
      
      colorScheme: const ColorScheme.dark(
        primary: Colors.blue,
        onPrimary: Colors.white,
        surface: AppColors.containerDark,
        onSurface: Colors.white, 
      ),
      
      textTheme: ThemeData.dark().textTheme.copyWith(
        titleLarge: const TextStyle(color: Colors.white, fontFamily: 'Roble'),
        bodyLarge: const TextStyle(color: Colors.white, fontFamily: 'Roble'),
        bodyMedium: const TextStyle(color: Color(0xFFB0B3B8), fontFamily: 'Roble'),
      ).apply(fontFamily: 'Roble'),
    );
  }
}