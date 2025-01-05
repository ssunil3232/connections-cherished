import 'package:connectionscherished/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';

class ButtonStyles {
  // Colors
  static ButtonColors btnColors = ButtonColors();
  // Fonts

  // Primary Button
  static PrimaryButtonStyle primaryBtnStyle = PrimaryButtonStyle();
  static SecondaryButtonStyle secondaryBtnStyle = SecondaryButtonStyle();
  static TertiaryButtonStyle tertiaryBtnStyle = TertiaryButtonStyle();
  static TertiaryAlertButtonStyle tertiaryAlertBtnStyle = TertiaryAlertButtonStyle();
  static PrimaryAlertButtonStyle primaryAlertButtonStyle = PrimaryAlertButtonStyle();

  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    overlayColor: Colors.transparent,
    textStyle: GlobalStyles.textStyles.body2,
    disabledForegroundColor: GlobalStyles.globalTextDisabled,
    disabledBackgroundColor: GlobalStyles.globalBgDisabled,
    foregroundColor: primaryBtnStyle.text,
    backgroundColor: primaryBtnStyle.bgDefault,
    padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.spacing16, horizontal: GlobalStyles.spacingStates.spacing32),
    shape: SmoothRectangleBorder(
        smoothness: 1, 
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        side: BorderSide(color: primaryBtnStyle.border)
      ),
    );

  static ButtonStyle secondaryButton = ElevatedButton.styleFrom(
    overlayColor: Colors.transparent,
    textStyle: GlobalStyles.textStyles.body2,
    disabledForegroundColor: GlobalStyles.globalTextDisabled,
    disabledBackgroundColor: GlobalStyles.globalBgDisabled,
    foregroundColor: secondaryBtnStyle.text,
    backgroundColor: secondaryBtnStyle.bgDefault,
    padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.spacing16, horizontal: GlobalStyles.spacingStates.spacing32),
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        side: BorderSide(color: secondaryBtnStyle.border)
      ),
    );
  
  static ButtonStyle tertiaryButton = TextButton.styleFrom(
    disabledForegroundColor: GlobalStyles.globalTextDisabled,
    foregroundColor: tertiaryBtnStyle.textDefault,
    textStyle: GlobalStyles.textStyles.boldBody1.copyWith(
       color: tertiaryBtnStyle.textDefault,
       decoration: TextDecoration.underline,
       decorationColor: tertiaryBtnStyle.textDefault
      ),
    overlayColor: Colors.transparent,
    padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.spacing8, horizontal: GlobalStyles.spacingStates.spacing8),
    );

  static ButtonStyle tertiaryAlertButton = TextButton.styleFrom(
    disabledForegroundColor: GlobalStyles.globalTextDisabled,
    foregroundColor: tertiaryAlertBtnStyle.textDefault,
    textStyle: GlobalStyles.textStyles.boldBody1.copyWith(
       color: tertiaryAlertBtnStyle.textDefault,
       decoration: TextDecoration.underline,
       decorationColor: tertiaryAlertBtnStyle.textDefault
      ),
    overlayColor: Colors.transparent,
    padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.spacing8, horizontal: GlobalStyles.spacingStates.spacing8),
    );

  static ButtonStyle primaryAlertButton = ElevatedButton.styleFrom(
    overlayColor: Colors.transparent,
    textStyle: GlobalStyles.textStyles.body2,
    disabledForegroundColor: GlobalStyles.globalTextDisabled,
    disabledBackgroundColor: GlobalStyles.globalBgDisabled,
    foregroundColor: primaryAlertButtonStyle.text,
    backgroundColor: primaryAlertButtonStyle.bgDefault,
    padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.spacing16, horizontal: GlobalStyles.spacingStates.spacing32),
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        side: BorderSide(color: primaryAlertButtonStyle.border)
      ),
    );

  static ButtonStyle googleButton = ElevatedButton.styleFrom(
    overlayColor: Colors.transparent,
    textStyle: GlobalStyles.textStyles.boldBody1,
    disabledForegroundColor: GlobalStyles.globalTextDisabled,
    disabledBackgroundColor: GlobalStyles.globalBgDisabled,
    foregroundColor: primaryBtnStyle.text,
    backgroundColor: GlobalStyles.globalBgDefault,
    padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.spacing16, horizontal: GlobalStyles.spacingStates.spacing32),
    shape: SmoothRectangleBorder(
        smoothness: 1,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        side: BorderSide(color: GlobalStyles.globalTextSubtle)
      ),
    );

    static ButtonStyle appleButton = ElevatedButton.styleFrom(
    overlayColor: Colors.transparent,
    textStyle: GlobalStyles.textStyles.boldBody1,
    disabledForegroundColor: GlobalStyles.globalTextDisabled,
    disabledBackgroundColor: GlobalStyles.globalBgDisabled,
    foregroundColor: primaryBtnStyle.text,
    backgroundColor: GlobalStyles.globalBgDefault,
    padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.spacing16, horizontal: GlobalStyles.spacingStates.spacing32),
    shape: SmoothRectangleBorder(
        smoothness: 1,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        side: BorderSide(color: GlobalStyles.globalTextSubtle)
      ),
    );

}

class ButtonColors {
  ButtonColors();
  static const PrimaryColors primary = PrimaryColors();
  static const NeutralColors neutral = NeutralColors();
  static const ErrorColors error = ErrorColors();
  static const PrimaryColorPalette pastel = PrimaryColorPalette();
  final Color buttonPrimaryBgDefault = pastel.primaryBg;
  final Color buttonPrimaryBgActive = pastel.primaryBgActive;
  final Color buttonPrimaryText = neutral.neutral950;
  final Color buttonSecondaryBgDefault = pastel.secondaryBg;
  final Color buttonSecondaryBgActive = const Color.fromARGB(255, 209, 171, 233);
  final Color buttonSecondaryText = neutral.neutral950;
  final Color buttonTertiaryTextDefault = const Color.fromARGB(255, 163, 24, 233);
  final Color buttonTertiaryTextActive = const Color.fromARGB(255, 107, 9, 156);
  final Color buttonBorder = pastel.primaryBorder;
  final Color buttonErrorText = neutral.neutral0;
  final Color buttonErrorBgDefault = const Color.fromARGB(255, 233, 112, 112);
  final Color buttonErrorBgActive = const Color.fromARGB(255, 226, 63, 63);
  final Color buttonErrorBorder = error.error800;
}

class PrimaryButtonStyle {
  PrimaryButtonStyle();
  static ButtonColors colors = ButtonColors();

  final Color bgDefault = colors.buttonPrimaryBgDefault;
  final Color bgActive = colors.buttonPrimaryBgActive;
  final Color text = colors.buttonPrimaryText;
  final Color border = colors.buttonBorder;

}

class SecondaryButtonStyle {
  SecondaryButtonStyle();
  static ButtonColors colors = ButtonColors();

  final Color bgDefault = colors.buttonSecondaryBgDefault;
  final Color bgActive = colors.buttonSecondaryBgActive;
  final Color text = colors.buttonSecondaryText;
  final Color border = colors.buttonBorder;
}

class TertiaryButtonStyle {
  TertiaryButtonStyle();
  static ButtonColors colors = ButtonColors();
  final Color textDefault = colors.buttonTertiaryTextDefault;
  final Color textActive = colors.buttonTertiaryTextActive;
}

class TertiaryAlertButtonStyle {
  TertiaryAlertButtonStyle();
  static const ErrorColors error = ErrorColors();
  final Color textDefault = error.error600;
  final Color textActive = error.error800;
}

class PrimaryAlertButtonStyle {
  PrimaryAlertButtonStyle();
  static ButtonColors colors = ButtonColors();
  final Color bgDefault = colors.buttonErrorBgDefault;
  final Color bgActive = colors.buttonErrorBgActive;
  final Color text = colors.buttonErrorText;
  final Color border = colors.buttonErrorBorder;

}