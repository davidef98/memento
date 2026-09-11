import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static const Color transparent = Color(0x00FFFFFF);
  static const Color primaryColor = Color(0xFFFAF8F8);
  static const Color secondaryColor = Color(0xFF2D3036);
  static const Color accentColor1 = Color(0xFFFF3B30);
  static const Color accentColor2 = Color(0xFF388C54);
  static const Color accentColor3 = Color(0xFFFD9627);
  static const Color unselectedItemColor =  Color(0xFF918E94);
  static const Color textFields = Color(0xFFE9E8E9);
  static const Color whiteBackground = Color(0xFFFFFFFF);


  static ThemeData get materialTheme => ThemeData(
    primaryColor: AppThemes.primaryColor,
    scaffoldBackgroundColor: AppThemes.primaryColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: accentColor1,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      dragHandleColor: AppThemes.unselectedItemColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppThemes.primaryColor,
      focusColor: AppThemes.secondaryColor,
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppThemes.secondaryColor,),
        borderRadius: BorderRadius.circular(12),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: AppThemes.secondaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppThemes.secondaryColor,
      selectionColor: AppThemes.secondaryColor.withValues(alpha: 0.5),
      selectionHandleColor: AppThemes.secondaryColor,
    ),
    textTheme: _buildTextTheme(AppThemes.secondaryColor),
  );

  static CupertinoThemeData get cupertinoTheme =>  CupertinoThemeData(
    primaryColor: AppThemes.secondaryColor,
    scaffoldBackgroundColor: AppThemes.primaryColor,
    barBackgroundColor: AppThemes.primaryColor,

    textTheme: CupertinoTextThemeData(
      textStyle: _buildCupertinoTextStyle(AppThemes.secondaryColor),
    ),
  );

  static TextTheme _buildTextTheme(Color color) {
    return const TextTheme(
      bodyLarge: TextStyle(color: AppThemes.secondaryColor),
      bodyMedium: TextStyle(color: AppThemes.secondaryColor),
      displayLarge: TextStyle(color: AppThemes.secondaryColor),
    );
  }

  static TextStyle _buildCupertinoTextStyle(Color color) {
    return const TextStyle(
      color: AppThemes.secondaryColor,
    );
  }
}

class UnifiedTextStyles {

  static TextStyle get scaffoldTitle => GoogleFonts.urbanist(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppThemes.secondaryColor,
  );
  static TextStyle get headline20 => GoogleFonts.urbanist(
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    color: AppThemes.secondaryColor,
  );
  static TextStyle get bodyText16 => GoogleFonts.urbanist(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppThemes.secondaryColor,
  );
  static TextStyle get bodyText15 => GoogleFonts.urbanist(
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    color: AppThemes.secondaryColor,
  );
  static  TextStyle get badge12 => GoogleFonts.urbanist(
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
    color: AppThemes.secondaryColor,
  );
}

