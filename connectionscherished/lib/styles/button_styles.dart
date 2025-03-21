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
  static TertiaryButtonStyle tertiaryBtnVariantStyle = TertiaryButtonStyle();
  static TertiaryAlertButtonStyle tertiaryAlertBtnStyle = TertiaryAlertButtonStyle();
  static PrimaryAlertButtonStyle primaryAlertButtonStyle = PrimaryAlertButtonStyle();

  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    overlayColor: Colors.transparent,
    textStyle: GlobalStyles.textStyles.textButtonPrimary,
    disabledForegroundColor: GlobalStyles.textDisabled,
    disabledBackgroundColor: GlobalStyles.btnBgDisabled,
    foregroundColor: primaryBtnStyle.text,
    backgroundColor: primaryBtnStyle.bgDefault,
    padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16), horizontal: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing32, useWidth: true)),  
    shape: SmoothRectangleBorder(
        smoothness: 1, 
        borderRadius: BorderRadius.all(Radius.circular(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing20))),
        side: BorderSide(color: primaryBtnStyle.border)
      ),
    );

  static ButtonStyle secondaryButton = ElevatedButton.styleFrom(
    overlayColor: Colors.transparent,
    textStyle: GlobalStyles.textStyles.textButtonPrimary,
    disabledForegroundColor: GlobalStyles.textDisabled,
    disabledBackgroundColor: GlobalStyles.btnBgDisabled,
    foregroundColor: secondaryBtnStyle.text,
    backgroundColor: secondaryBtnStyle.bgDefault,
    padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16), horizontal: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing32, useWidth: true)),
    shape: SmoothRectangleBorder(
        smoothness: 1, 
        borderRadius: BorderRadius.all(Radius.circular(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing20))),
        side: BorderSide(color: secondaryBtnStyle.border)
      ),
    );
  
  static ButtonStyle tertiaryButton = FilledButton.styleFrom(
    overlayColor: Colors.transparent,
    textStyle: GlobalStyles.textStyles.textButtonSecondary,
    disabledForegroundColor: GlobalStyles.textDisabled,
    disabledBackgroundColor: GlobalStyles.btnBgDisabled,
    foregroundColor: tertiaryBtnStyle.textDefault,
    backgroundColor: tertiaryBtnStyle.bgDefault,
    padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing8), horizontal: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing24, useWidth: true)),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16))),
      // side: BorderSide(color: secondaryBtnStyle.border)
    ),
  );

  static ButtonStyle tertiaryVariantButton = FilledButton.styleFrom(
    overlayColor: Colors.transparent,
    textStyle: GlobalStyles.textStyles.textButtonPrimary,
    disabledForegroundColor: GlobalStyles.textDisabled,
    disabledBackgroundColor: GlobalStyles.btnBgDisabled,
    foregroundColor: tertiaryBtnStyle.textDefault,
    backgroundColor: tertiaryBtnStyle.bgVariant,
    padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing8), horizontal: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing24, useWidth: true)),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16))),
      // side: BorderSide(color: secondaryBtnStyle.border)
    ),
  );

  static ButtonStyle tertiaryAlertButton = TextButton.styleFrom(
    disabledForegroundColor: GlobalStyles.textDisabled,
    foregroundColor: tertiaryAlertBtnStyle.textDefault,
    textStyle: GlobalStyles.textStyles.textButtonPrimary.copyWith(
       color: tertiaryAlertBtnStyle.textDefault,
       decoration: TextDecoration.underline,
       decorationColor: tertiaryAlertBtnStyle.textDefault
      ),
    overlayColor: Colors.transparent,
    padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing8), horizontal: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing8, useWidth: true)),
    );

  static ButtonStyle primaryAlertButton = ElevatedButton.styleFrom(
    overlayColor: Colors.transparent,
    textStyle: GlobalStyles.textStyles.textButtonPrimary,
    disabledForegroundColor: GlobalStyles.textDisabled,
    disabledBackgroundColor: GlobalStyles.btnBgDisabled,
    foregroundColor: primaryAlertButtonStyle.text,
    backgroundColor: primaryAlertButtonStyle.bgDefault,
    padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16), horizontal: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing32, useWidth: true)),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing20))),
        side: BorderSide(color: primaryAlertButtonStyle.border)
      ),
    );

  static ButtonStyle googleButton = ElevatedButton.styleFrom(
    overlayColor: Colors.transparent,
    textStyle: GlobalStyles.textStyles.textButtonPrimary,
    disabledForegroundColor: GlobalStyles.textDisabled,
    disabledBackgroundColor: GlobalStyles.btnBgDisabled,
    foregroundColor: primaryBtnStyle.text,
    backgroundColor: GlobalStyles.defaultBg,
    padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16), horizontal: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing32, useWidth: true)),
    shape: SmoothRectangleBorder(
        smoothness: 1,
        borderRadius: BorderRadius.all(Radius.circular(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing20))),
        side: BorderSide(color: GlobalStyles.textSubtle)
      ),
    );

    static ButtonStyle appleButton = ElevatedButton.styleFrom(
    overlayColor: Colors.transparent,
    textStyle: GlobalStyles.textStyles.textButtonPrimary,
    disabledForegroundColor: GlobalStyles.textDisabled,
    disabledBackgroundColor: GlobalStyles.btnBgDisabled,
    foregroundColor: primaryBtnStyle.text,
    backgroundColor: GlobalStyles.defaultBg,
    padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16), horizontal: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing32, useWidth: true)),
    shape: SmoothRectangleBorder(
        smoothness: 1,
        borderRadius: BorderRadius.all(Radius.circular(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing20))),
        side: BorderSide(color: GlobalStyles.textSubtle)
      ),
    );

}

class ButtonColors {
  ButtonColors();
  static const PrimaryColors primary = PrimaryColors();
  static const NeutralColors neutral = NeutralColors();
  static const ErrorColors error = ErrorColors();
  static const PrimaryColorPalette pastel = PrimaryColorPalette();
  //Primary
  final Color buttonPrimaryBgDefault = GlobalStyles.btnBgPrimary;
  final Color buttonPrimaryBgActive = const Color.fromARGB(255, 249, 214, 110);
  final Color buttonPrimaryText = GlobalStyles.primaryText;
  final Color buttonPrimaryBorder = GlobalStyles.btnBorderPrimary;

  //Secondary
  final Color buttonSecondaryBgDefault = GlobalStyles.btnBgSecondary;
  final Color buttonSecondaryBgActive = const Color.fromARGB(255, 245, 228, 168);
  final Color buttonSecondaryText = GlobalStyles.primaryText;
  final Color buttonSecondaryBorder = GlobalStyles.btnBorderSecondary;

  //Tertiary ====> need to create new component
  final Color buttonTertiaryTextDefault = GlobalStyles.primaryText;
  final Color buttonTertiaryTextActive = GlobalStyles.primaryText;//
  final Color buttonTertiaryBgDefault = GlobalStyles.btnBgTertiary;
  final Color buttonTertiaryBgVariant = GlobalStyles.btnBgSecondary;

  final Color buttonErrorText = GlobalStyles.defaultBg;
  final Color buttonErrorBgDefault = GlobalStyles.btnBgError;
  final Color buttonErrorBgActive = const Color.fromARGB(255, 226, 63, 63);//
  final Color buttonErrorBorder = GlobalStyles.btnBorderError;
}

class PrimaryButtonStyle {
  PrimaryButtonStyle();
  static ButtonColors colors = ButtonColors();

  final Color bgDefault = colors.buttonPrimaryBgDefault;
  final Color bgActive = colors.buttonPrimaryBgActive;
  final Color text = colors.buttonPrimaryText;
  final Color border = colors.buttonPrimaryBorder;

}

class SecondaryButtonStyle {
  SecondaryButtonStyle();
  static ButtonColors colors = ButtonColors();

  final Color bgDefault = colors.buttonSecondaryBgDefault;
  final Color bgActive = colors.buttonSecondaryBgActive;
  final Color text = colors.buttonSecondaryText;
  final Color border = colors.buttonSecondaryBorder;
}

class TertiaryButtonStyle {
  TertiaryButtonStyle();
  static ButtonColors colors = ButtonColors();
  final Color textDefault = colors.buttonTertiaryTextDefault;
  final Color textActive = colors.buttonTertiaryTextActive;
  final Color bgDefault = colors.buttonTertiaryBgDefault;
  final Color bgVariant = colors.buttonTertiaryBgVariant;
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