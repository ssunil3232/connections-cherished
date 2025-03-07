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

  //New colour scheme
  //============= Global Colors =================//
  static const Color defaultBg = Color(0xFFFFFFFF); // default-bg
  static Color defaultTextBg = neutral.neutral50; // default-text-bg
  static const Color defaultBorder = Color(0xFFB1BBC8); // default-border
  static const Color defaultBorderEnabled = Color(0xFFB1BBC8); // default-border-enabled
  static const Color primaryText = Color(0xFF343A46); // primary-text
  static Color textSubtle = neutral.neutral500; // text-subtle
  static Color textDisabled = neutral.neutral500; // text-disabled
  static Color inputPlaceholderText = neutral.neutral300; // input-placeholder-text

  //============= Navigation Colors =================//
  static const Color topNavBg = Color(0xFFE6F9F7); // top-nav-bg
  static const Color bottomNavBg = Color(0xFFFFF7E9); // bottom-nav-bg

  //============= Button Colors =================//
  static const Color btnBgPrimary = Color(0xFFFCDE85); // btn-bg-primary
  static const Color btnBorderPrimary = Color(0xFFF99C07); // btn-border-primary
  static const Color btnBgSecondary = Color(0xFFFFF3C6); // btn-bg-secondary
  static const Color btnBorderSecondary = Color(0xFFF99C07); // btn-border-secondary
  static const Color btnBgDisabled = Color(0xFFF6F7F9); // btn-bg-disabled
  static const Color btnBorderDisabled = Color(0xFFB1BBC8); // btn-border-disabled
  static const Color btnBgTertiary = Color(0xFFE5FCCE); // btn-bg-tertiary
  static const Color btnBorderError = Color(0xFF9C1818); // btn-border-error
  static const Color btnBgError = Color(0xFFDC1E1E); // btn-bg-error

  //============= Warning Colors =================//
  static const Color warningColor = Color(0xFFE3D3FF); // warning-color
  static const Color criticalColor = Color(0xFFC09DFF); // critical-color
  static const Color neutralColor = Color(0xFFF6F1FF); // neutral-color

  //=================Error State Colors=====================//
  static Color globalErrorBg = error.error100;
  static Color globalErrorBorder = error.error600;
  static Color globalErrorText = error.error600;
  static Color globalErrorTextActive = error.error800;

  //=================Success State Colors=====================//
  static Color globalSuccessBg = success.success100;
  static Color globalSuccessBorder = success.success600;
  static Color globalSuccessText = success.success600;

  static TextStyles textStyles = TextStyles();
  static SpacingStates spacingStates = SpacingStates();


  static final InputDecoration inputFieldDecoration = InputDecoration(
    floatingLabelStyle: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.textSubtle),
    labelStyle: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.inputPlaceholderText),
    hintStyle: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.inputPlaceholderText),
    errorStyle: GlobalStyles.textStyles.textCaption2.copyWith(color: GlobalStyles.globalErrorText),
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
      borderSide: BorderSide(width: 2.0, color: GlobalStyles.defaultBorderEnabled),
      borderRadius: BorderRadius.circular(20.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1.0, color: GlobalStyles.defaultBorder),
      borderRadius: BorderRadius.circular(20.0),
    ),
  );

  static final InputDecorationTheme dropdownFieldDecoration = InputDecorationTheme(
    floatingLabelStyle: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.textSubtle),
    labelStyle: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.inputPlaceholderText),
    hintStyle: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.inputPlaceholderText),
    errorStyle: GlobalStyles.textStyles.textCaption2.copyWith(color: GlobalStyles.globalErrorText),
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
      borderSide: BorderSide(width: 2.0, color: GlobalStyles.defaultBorderEnabled),
      borderRadius: BorderRadius.circular(20.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1.0, color: GlobalStyles.defaultBorder),
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

  //New Text Styles
  TextStyle get titleHeader => GoogleFonts.mynerve(
    fontSize: isSmallScreen ? 28 : 32,
    fontWeight: FontWeight.w400,
    color: GlobalStyles.primaryText,
  );

  TextStyle get textH1 => GoogleFonts.nunito(
    fontSize: isSmallScreen ? 28 : 32,
    fontWeight: FontWeight.w600,
    color: GlobalStyles.primaryText
  );

  TextStyle get textH2 => GoogleFonts.nunito(
    fontSize: isSmallScreen ? 22 : 24,
    fontWeight: FontWeight.w400,
    height: isSmallScreen ? (20 / 22) : (22 / 24),
    color: GlobalStyles.primaryText,
  );

  TextStyle get textH2Bold => GoogleFonts.nunito(
    fontSize: isSmallScreen ? 22 : 24,
    fontWeight: FontWeight.w600,
    height: isSmallScreen ? (20 / 22) : (22 / 24),
    color: GlobalStyles.primaryText
  );

  TextStyle get textH3 => GoogleFonts.nunito(
    fontSize: isSmallScreen ? 20 : 22,
    fontWeight: FontWeight.w400,
    height: isSmallScreen ? (18 / 20) : (20 / 22),
    color: GlobalStyles.primaryText,
  );

  TextStyle get textH3Varaint => GoogleFonts.mynerve(
    fontSize: isSmallScreen ? 22 : 24,
    fontWeight: FontWeight.w400,
    height: isSmallScreen ? (24 / 22) : (26 / 24),
    color: GlobalStyles.primaryText,
  );

  TextStyle get textBody => GoogleFonts.nunito(
    fontSize: isSmallScreen ? 16 : 18,
    fontWeight: FontWeight.w400,
    height: isSmallScreen ? (20 / 16) : (22 / 18),
    color: GlobalStyles.primaryText,
  );

  TextStyle get textCaption1=> GoogleFonts.nunito(
    fontSize: isSmallScreen ? 14 : 16,
    fontWeight: FontWeight.w400,
    color: GlobalStyles.primaryText,
  );

  TextStyle get textCaption2 => GoogleFonts.nunito(
    fontSize: isSmallScreen ? 12 : 14,
    fontWeight: FontWeight.w400,
    color: GlobalStyles.primaryText,
  );

  TextStyle get textCaption3 => GoogleFonts.nunito(
    fontSize: isSmallScreen ? 10 : 12,
    fontWeight: FontWeight.w400,
    height: isSmallScreen ? (12 / 10) : (14 / 12),
    color: GlobalStyles.primaryText,
  );

  TextStyle get textButtonPrimary => GoogleFonts.nunito(
    fontSize: isSmallScreen ? 16 : 18,
    fontWeight: FontWeight.w700,
    color: GlobalStyles.primaryText,
  );

  TextStyle get textButtonSecondary => GoogleFonts.nunito(
    fontSize: isSmallScreen ? 16 : 18,
    fontWeight: FontWeight.w400,
    color: GlobalStyles.primaryText,
  );

  TextStyle get textButtonTertiary => GoogleFonts.nunito(
    fontSize: isSmallScreen ? 12 : 14,
    fontWeight: FontWeight.w400,
    height: isSmallScreen ? (14 / 12) : (16 / 14),
    color: GlobalStyles.primaryText,
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
  final double spacing36 = 36;
  final double spacing40 = 40;
  final double spacing44 = 44;
  final double spacing48 = 48;
  final double spacing52 = 52;
  final double spacing56 = 56;
  final double spacing60 = 60;
  final double spacing64 = 64;

}