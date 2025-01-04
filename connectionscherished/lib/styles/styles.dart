import 'package:connectionscherished/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Global App Styles
class GlobalStyles {
  //=============Foundational Colors=================//
  ///Primary Swatch
  static const PrimaryColors primary = PrimaryColors();
  ///Neutral Swatch
  static const NeutralColors neutral = NeutralColors();
  ///Success Swatch
  static const SuccessColors success = SuccessColors();
  ///Warning Swatch
  static const WarningColors warning = WarningColors();
  ///Error Swatch
  static const ErrorColors error = ErrorColors();
  ///Pastel Swatch
  static const PastelColors pastel = PastelColors();
  ///Primary Color Palette
  static const PrimaryColorPalette primaryPalette = PrimaryColorPalette();

  //=============Brand Colors=================//
  static Color brandColor1 = const Color(0xff764374);
  static Color brandColor2 = const Color(0xffAC94BA);

  //=============Severity Colors=================//
  static const Color severeColor = Color(0xffC88EE4);
  static const Color warningColor = Color(0xffE3C1F3);
  static const Color normalColor = Color(0xffECE1F1);

  //=============Global Colors=================//
  static Color globalBgDefault = neutral.neutral0;
  static Color globalBgSubtle = neutral.neutral50;
  static Color globalTextDefault = neutral.neutral950;
  static Color globalTextSubtle = neutral.neutral500;
  static Color globalIconError = error.error600;
  static Color globalIconSuccess = success.success600;
  static Color globalIconDefault = neutral.neutral500;
  static Color inputPlaceholderText = neutral.neutral300;

  //=================Disabled State Colors=====================//
  static Color globalBgDisabled = neutral.neutral50;
  static Color globalTextDisabled = neutral.neutral500;
  static Color globalBorderDisabled = neutral.neutral300;

  //=================Error State Colors=====================//
  static Color globalErrorBg = error.error100;
  static Color globalErrorBorder = error.error600;
  static Color globalErrorText = error.error600;
  static Color globalErrorTextActive = error.error800;

  //=================Success State Colors=====================//
  static Color globalSuccessBg = success.success100;
  static Color globalSuccessBorder = success.success600;
  static Color globalSuccessText = success.success600;

  //=============Card Colors=================//
  static Color cardBgDefault = neutral.neutral0;
  static Color cardBgSelected = const Color.fromARGB(255, 242, 226, 243);
  static Color cardBorderDefault= neutral.neutral300;
  static Color cardBorderSelected= primary.primary600;

  //=============Others=================//
  static Color chatBubbleBgAi = neutral.neutral100;
  static Color chatBubbleBgAuthor = primary.primary300;
  static Color chatFgDefault = neutral.neutral500;
  static Color chatFgActive = neutral.neutral950;
  static Color chatBorderDefault = neutral.neutral400;
  static Color chatBorderActive = neutral.neutral500;
  static Color menuDefault = neutral.neutral500;
  static Color menuActive = neutral.neutral950;
  static Color timeBgDefault = pastel.sky50;
  static Color timeTextDefault = pastel.sky800;
  static Color wordsBgDefault = pastel.mint50;
  static Color wordsTextDefault = pastel.mint800;
  static Color sentencesBgDefault = pastel.lavender50;
  static Color sentencesTextDefault = pastel.lavender800;
  static Color topicBgDefault = pastel.rose50;
  static Color topicTextDefault = pastel.rose800;
  static Color questionsBgDefault = pastel.honey50;
  static Color questionsTextDefault = pastel.honey800;

  static TextStyles textStyles = TextStyles();
  static SpacingStates spacingStates = SpacingStates();

  // Input Text field Decoration
  static final InputDecoration chatFieldDecoration = InputDecoration(
    floatingLabelStyle: GlobalStyles.textStyles.body1.copyWith(color: GlobalStyles.globalTextSubtle),
    labelStyle: GlobalStyles.textStyles.body1.copyWith(color: GlobalStyles.globalTextSubtle),
    hintStyle: GlobalStyles.textStyles.body1.copyWith(color: GlobalStyles.inputPlaceholderText),
    contentPadding: EdgeInsets.all(GlobalStyles.spacingStates.spacing16),
    border: OutlineInputBorder(
      borderSide: BorderSide(width: 1.0, color: GlobalStyles.cardBorderDefault),
      borderRadius: BorderRadius.circular(20.0)),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 2.0, color: Color(0xFFEA4432)),
      borderRadius: BorderRadius.circular(20.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 2.0, color: Color(0xFFEA4432)),
      borderRadius: BorderRadius.circular(20.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2.0, color: GlobalStyles.globalTextSubtle),
      borderRadius: BorderRadius.circular(20.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2.0, color: GlobalStyles.globalTextSubtle),
      borderRadius: BorderRadius.circular(20.0),
    ),
  );

  static final InputDecoration inputFieldDecoration = InputDecoration(
    floatingLabelStyle: GlobalStyles.textStyles.body1.copyWith(color: GlobalStyles.globalTextSubtle),
    labelStyle: GlobalStyles.textStyles.body1.copyWith(color: GlobalStyles.inputPlaceholderText),
    hintStyle: GlobalStyles.textStyles.body1.copyWith(color: GlobalStyles.inputPlaceholderText),
    errorStyle: GlobalStyles.textStyles.caption1.copyWith(color: GlobalStyles.globalErrorText),
    contentPadding: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.spacing16, vertical: 18),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2.0, color: GlobalStyles.globalErrorBorder),
      borderRadius: BorderRadius.circular(20.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1.0, color: GlobalStyles.globalErrorBorder),
      borderRadius: BorderRadius.circular(20.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2.0, color: GlobalStyles.globalTextSubtle),
      borderRadius: BorderRadius.circular(20.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1.0, color: GlobalStyles.cardBorderDefault),
      borderRadius: BorderRadius.circular(20.0),
    ),
  );

  static final InputDecorationTheme dropdownFieldDecoration = InputDecorationTheme(
    floatingLabelStyle: GlobalStyles.textStyles.body1.copyWith(color: GlobalStyles.globalTextSubtle),
    labelStyle: GlobalStyles.textStyles.body1.copyWith(color: GlobalStyles.inputPlaceholderText),
    hintStyle: GlobalStyles.textStyles.body1.copyWith(color: GlobalStyles.inputPlaceholderText),
    errorStyle: GlobalStyles.textStyles.caption1.copyWith(color: GlobalStyles.globalErrorText),
    contentPadding: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.spacing16, vertical: 18),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2.0, color: GlobalStyles.globalErrorBorder),
      borderRadius: BorderRadius.circular(20.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1.0, color: GlobalStyles.globalErrorBorder),
      borderRadius: BorderRadius.circular(20.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2.0, color: GlobalStyles.globalTextSubtle),
      borderRadius: BorderRadius.circular(20.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1.0, color: GlobalStyles.cardBorderDefault),
      borderRadius: BorderRadius.circular(20.0),
    ),
  );
}

class PrimaryColors {
  const PrimaryColors();
  final Color primary50 = const Color(0xFFFFFBEB);
  final Color primary100 = const Color(0xFFFFF3C6);
  final Color primary200 = const Color(0xFFFFE588);
  final Color primary300 = const Color(0xFFffd966);
  final Color primary400 = const Color(0xFFffbe20);
  final Color primary500 = const Color(0xFFf99c07);
  final Color primary600 = const Color(0xFFdd7402);
  final Color primary700 = const Color(0xFFb75106);
  final Color primary800 = const Color(0xFF943d0c);
  final Color primary900 = const Color(0xFF7a330d);
  final Color primary950 = const Color(0xFF461902);
}

class NeutralColors {
  const NeutralColors();
  final Color neutral0 = const Color(0xFFFFFFFF);
  final Color neutral50 = const Color(0xFFf6f7f9);
  final Color neutral100 = const Color(0xFFeceef2);
  final Color neutral200 = const Color(0xFFd5d9e2);
  final Color neutral300 = const Color(0xFFB1BBC8);
  final Color neutral400 = const Color(0xFF8695aa);
  final Color neutral500 = const Color(0xFF64748b);
  final Color neutral600 = const Color(0xFF526077);
  final Color neutral700 = const Color(0xFF434e61);
  final Color neutral800 = const Color(0xFF3a4252);
  final Color neutral900 = const Color(0xFF343a46);
  final Color neutral950 = const Color(0xFF23272e);
}

class SuccessColors {
  const SuccessColors();
  final Color success50 = const Color(0xFFeffee7);
  final Color success100 = const Color(0xFFdbfdca);
  final Color success200 = const Color(0xFFbafa9c);
  final Color success300 = const Color(0xFF8ef462);
  final Color success400 = const Color(0xFF67e932);
  final Color success500 = const Color(0xFF46cf13);
  final Color success600 = const Color(0xFF32a50b);
  final Color success700 = const Color(0xFF277e0d);
  final Color success800 = const Color(0xFF246411);
  final Color success900 = const Color(0xFF205413);
  final Color success950 = const Color(0xFF0c2f04);
}

class WarningColors {
  const WarningColors();
  final Color warning50 = const Color(0xFFfff7ed);
  final Color warning100 = const Color(0xFFffeed4);
  final Color warning200 = const Color(0xFFffd9a9);
  final Color warning300 = const Color(0xFFffb561);
  final Color warning400 = const Color(0xFFfe9639);
  final Color warning500 = const Color(0xFFfc7713);
  final Color warning600 = const Color(0xFFed5c09);
  final Color warning700 = const Color(0xFFc54409);
  final Color warning800 = const Color(0xFF9c3610);
  final Color warning900 = const Color(0xFF7e2e10);
  final Color warning950 = const Color(0xFF441506);
}

class ErrorColors {
  const ErrorColors();
  final Color error50 = const Color(0xFFfef2f2);
  final Color error100 = const Color(0xFFffe1e1);
  final Color error200 = const Color(0xFFffc9c9);
  final Color error300 = const Color(0xFFfea3a3);
  final Color error400 = const Color(0xFFfc6d6d);
  final Color error500 = const Color(0xFFf34040);
  final Color error600 = const Color(0xFFdc1e1e);
  final Color error700 = const Color(0xFFbd1818);
  final Color error800 = const Color(0xFF9c1818);
  final Color error900 = const Color(0xFF821a1a);
  final Color error950 = const Color(0xFF470808);
}

class PastelColors {
  const PastelColors();
  final Color cyan50 = const Color(0xFFbafae3);
  final Color lime50= const Color(0xFFE5FCCE);
  final Color blue50 = const Color(0xFFCCEEFF);
  final Color tan50 = const Color(0xFFFAE3C6);
  final Color yellow50 = const Color(0xFFFFF2AC);
  final Color violet50 = const Color(0xFFF0DCFF);
  final Color blue500 = const Color(0xFFA3DAF5);
  final Color lime500 = const Color(0xFFCCF5A3);
  final Color cyan500 = const Color(0xFFA3F5D7);
  final Color sky50 = const Color(0xFFE9F2FF);
  final Color sky800 = const Color(0xFF1154B2);
  final Color mint50 = const Color(0xFFE6F9F2);
  final Color mint800 = const Color(0xFF0B794B);
  final Color lavender50 = const Color(0xFFF1E9FF);
  final Color lavender800 = const Color(0xFF5F3BAF);
  final Color rose50 = const Color(0xFFFFEBF3);
  final Color rose800 = const Color(0xFFBE2A61);
  final Color honey50 = const Color(0xFFFFF7E9);
  final Color honey800 = const Color(0xFF9E6502);
}

class PrimaryColorPalette {
  const PrimaryColorPalette();
  final Color primaryBg = const Color(0xFFE3C1F3);
  final Color primaryBgActive = const Color.fromARGB(255, 209, 149, 236);
  final Color primaryBorder = const Color.fromARGB(255, 150, 100, 173);
  final Color secondaryBgActive = const Color(0xFFAB93BA);
  final Color secondaryBg = const Color.fromARGB(255, 242, 233, 248);
}

// Text Styles
// FontWeight values:
// - FontWeight.w400: regular
// - FontWeight.w500: medium
// - FontWeight.w600: semiBold
// - FontWeight.w700: bold
class TextStyles {
  final screenUtil = ScreenUtil();
  bool isSmallScreen = false;

  TextStyles() {
    isSmallScreen = screenUtil.isSmallScreen;
  }

  TextStyle get titular => GoogleFonts.caveat(
    fontSize: isSmallScreen ? 24 : 28,
    fontWeight: FontWeight.w700,
    height: isSmallScreen ? (20 / 16) : (24 / 20),
    color: GlobalStyles.globalTextDefault,
  );

  TextStyle get heading1 => GoogleFonts.quicksand(
    fontSize: isSmallScreen ? 28 : 32,
    fontWeight: FontWeight.w700,
    height: isSmallScreen ? (36 / 28) : (40 / 32),
    color: GlobalStyles.globalTextDefault
  );
  TextStyle get heading2 => GoogleFonts.quicksand(
    fontSize: isSmallScreen ? 24 : 28,
    fontWeight: FontWeight.w700,
    height: isSmallScreen ? (28 / 24) : (32 / 28),
    color: GlobalStyles.globalTextDefault,
  );
  TextStyle get heading3 => GoogleFonts.quicksand(
    fontSize: isSmallScreen ? 20 : 24,
    fontWeight: FontWeight.w700,
    height: isSmallScreen ? (24 / 20) : (28 / 24),
    color: GlobalStyles.globalTextDefault,
  );
  TextStyle get heading4 => GoogleFonts.quicksand(
    fontSize: isSmallScreen ? 16 : 20,
    fontWeight: FontWeight.w600,
    height: isSmallScreen ? (20 / 16) : (24 / 20),
    color: GlobalStyles.globalTextDefault,
  );
  TextStyle get body1 => GoogleFonts.quicksand(
    fontSize: isSmallScreen ? 16 : 18,
    fontWeight: FontWeight.w600,
    height: isSmallScreen ? (18 / 16) : (20 / 18),
    color: GlobalStyles.globalTextDefault,
  );
  TextStyle get boldBody1 => GoogleFonts.quicksand(
    fontSize: isSmallScreen ? 16 : 18,
    fontWeight: FontWeight.w700,
    height: isSmallScreen ? (18 / 16) : (20 / 18),
    color: GlobalStyles.globalTextDefault,
  );
  TextStyle get body2 => GoogleFonts.quicksand(
    fontSize: isSmallScreen ? 14 : 16,
    fontWeight: FontWeight.w400,
    height: isSmallScreen ? (18 / 14) : (20 / 16),
    color: GlobalStyles.globalTextDefault,
  );
  TextStyle get boldBody2 => GoogleFonts.quicksand(
    fontSize: isSmallScreen ? 14 : 16,
    fontWeight: FontWeight.w700,
    height: isSmallScreen ? (18 / 14) : (20 / 16),
    color: GlobalStyles.globalTextDefault,
  );
  TextStyle get caption1 => GoogleFonts.quicksand(
    fontSize: isSmallScreen ? 12 : 14,
    fontWeight: FontWeight.w400,
    height: isSmallScreen ? (14 / 12) : (16 / 14),
    color: GlobalStyles.globalTextDefault,
  );
  TextStyle get caption2 => GoogleFonts.quicksand(
    fontSize: isSmallScreen ? 10 : 12,
    fontWeight: FontWeight.w400,
    height: isSmallScreen ? (14 / 10) : (16 / 12),
    color: GlobalStyles.globalTextDefault,
  );
}

class SpacingStates {
  SpacingStates();

  final double spacing4 = 4;
  final double spacing8 = 8;
  final double spacing12 = 12;
  final double spacing16 = 16;
  final double spacing20 = 20;
  final double spacing24 = 24;
  final double spacing28 = 28;
  final double spacing32 = 32;
  final double spacing48 = 48;
  final double spacing64 = 64;

}