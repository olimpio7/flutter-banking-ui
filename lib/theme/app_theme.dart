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
  final isDark = ThemeCubit.instance.state == ThemeMode.dark;
  return TextStyle(
    fontSize: 16,
    fontFamily: 'Roble',
    color: isDark ? const Color(0xFFFFFFFF) : Colors.black87, 
  );
}

TextStyle get subText {
  final isDark = ThemeCubit.instance.state == ThemeMode.dark;
  return TextStyle(
    fontSize: 12,
    fontFamily: 'Roble',
    color: isDark ? const Color(0xFFB0B3B8) : const Color(0xFF757575), 
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
      
      
      iconTheme: const IconThemeData(color: Colors.white),
      
      
      colorScheme: const ColorScheme.dark(
        primary: Colors.blue,
        onPrimary: Colors.white,
        surface: AppColors.containerDark,
        onSurface: Colors.white, 
      ),
      
      
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Color(0xFFB0B3B8)),
      ),
    );
  }
}