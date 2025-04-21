import 'package:connectionscherished/styles/button_styles.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/elevated_border_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:smooth_corner/smooth_corner.dart';

enum ButtonType {primary, secondary, teritary, tertiaryVariant, tertiaryAlert, primaryAlert, appleBtn, googleBtn}
// ignore: must_be_immutable
class CustomButtonWidget extends StatefulWidget {
  String? text; 
  IconData? icon;
  Widget? customIcon;
  IconAlignment? iconAlignment;
  VoidCallback? onPressed;
  double? width;
  double? height;
  bool? isEnabled;
  bool? showIsSaving;
  bool ? showUnderline;

  CustomButtonWidget({
    this.text,
    this.icon,
    this.iconAlignment,
    this.onPressed,
    this.width,
    this.height,
    this.customIcon,
    this.isEnabled = true,
    this.showIsSaving = false,
    this.showUnderline = true,
    super.key
  });

  ButtonStyle style = ButtonStyles.primaryButton;
  Color bgActive = ButtonStyles.primaryBtnStyle.bgActive;
  Color bgDefault = ButtonStyles.primaryBtnStyle.bgDefault;
  Color textDefault = ButtonStyles.primaryBtnStyle.text;
  Color border = ButtonStyles.primaryBtnStyle.border;
  ButtonType btnType = ButtonType.primary;

  // Primary Button
  CustomButtonWidget.primary({super.key, this.customIcon, this.onPressed, this.text, this.icon, this.width, this.height, this.iconAlignment, this.isEnabled, this.showIsSaving})
      : btnType = ButtonType.primary,
        style = ButtonStyles.primaryButton,
        textDefault = ButtonStyles.primaryBtnStyle.text,
        bgDefault = ButtonStyles.primaryBtnStyle.bgDefault,
        border = ButtonStyles.primaryBtnStyle.border,
        bgActive = ButtonStyles.primaryBtnStyle.bgActive;

  // Secondary Button
  CustomButtonWidget.secondary({super.key, this.customIcon, required this.onPressed, this.text, this.icon, this.width, this.height, this.iconAlignment, this.isEnabled, this.showIsSaving})
      : btnType = ButtonType.secondary,
        style = ButtonStyles.secondaryButton,
        textDefault = ButtonStyles.secondaryBtnStyle.text,
        bgDefault = ButtonStyles.secondaryBtnStyle.bgDefault,
        border = ButtonStyles.secondaryBtnStyle.border,
        bgActive = ButtonStyles.secondaryBtnStyle.bgActive;

  // Apple Button
  CustomButtonWidget.appleBtn({super.key, this.customIcon, required this.onPressed, this.text, this.icon, this.width, this.height, this.iconAlignment, this.isEnabled, this.showIsSaving})
      : btnType = ButtonType.appleBtn,
        style = ButtonStyles.appleButton,
        textDefault = ButtonStyles.secondaryBtnStyle.text,
        bgDefault = GlobalStyles.defaultBg,
        border = GlobalStyles.textSubtle,
        bgActive = ButtonStyles.secondaryBtnStyle.bgDefault;

  // Google Button
  CustomButtonWidget.googleBtn({super.key, this.customIcon, required this.onPressed, this.text, this.icon, this.width, this.height, this.iconAlignment, this.isEnabled, this.showIsSaving})
      : btnType = ButtonType.googleBtn,
        style = ButtonStyles.googleButton,
        textDefault = ButtonStyles.secondaryBtnStyle.text,
        bgDefault = GlobalStyles.defaultBg,
        border = GlobalStyles.textSubtle,
        bgActive = ButtonStyles.secondaryBtnStyle.bgDefault;

  // Primary Alert Button
  CustomButtonWidget.primaryAlert({super.key, required this.onPressed, this.text, this.icon, this.width, this.height, this.iconAlignment, this.isEnabled, this.showIsSaving})
      : btnType = ButtonType.primaryAlert,
        style = ButtonStyles.primaryAlertButton,
        textDefault = ButtonStyles.primaryAlertButtonStyle.text,
        bgDefault = ButtonStyles.primaryAlertButtonStyle.bgDefault,
        border = ButtonStyles.primaryAlertButtonStyle.border,
        bgActive = ButtonStyles.primaryAlertButtonStyle.bgActive;

  // Tertiary Button
  CustomButtonWidget.tertiary({super.key, required this.onPressed, required this.text, this.isEnabled, this.showUnderline = true})
      : btnType = ButtonType.teritary,
        style = ButtonStyles.tertiaryButton,
        bgDefault = ButtonStyles.tertiaryBtnStyle.textDefault,
        bgActive = ButtonStyles.tertiaryBtnStyle.textActive;

  // Tertiary Variant Button
  CustomButtonWidget.tertiaryVariant({super.key, required this.onPressed, required this.text, this.isEnabled, this.showUnderline = true})
      : btnType = ButtonType.teritary,
        style = ButtonStyles.tertiaryVariantButton,
        bgDefault = ButtonStyles.tertiaryBtnStyle.textDefault,
        bgActive = ButtonStyles.tertiaryBtnStyle.textActive;
  
  // Tertiary Alert Button
  CustomButtonWidget.tertiaryAlert({super.key, required this.onPressed, required this.text, this.isEnabled, this.showUnderline = true})
      : btnType = ButtonType.tertiaryAlert,
        style = ButtonStyles.tertiaryAlertButton,
        bgDefault = ButtonStyles.tertiaryAlertBtnStyle.textDefault,
        bgActive = ButtonStyles.tertiaryAlertBtnStyle.textActive;

  @override
  _CustomButtonWidgetState createState() => _CustomButtonWidgetState();
}
class _CustomButtonWidgetState extends State<CustomButtonWidget> {

  @override
  Widget build(BuildContext context) {
    widget.width ??= MediaQuery.of(context).size.width;

    final onPressed = widget.isEnabled ?? true ? widget.onPressed : null;

    return (widget.btnType == ButtonType.teritary || widget.btnType == ButtonType.tertiaryVariant || widget.btnType == ButtonType.tertiaryAlert)?
      TextButton(
        onPressed: onPressed,
        style: widget.style.copyWith(
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                 return GlobalStyles.textDisabled;
              }
              if (states.contains(WidgetState.pressed)) {
                return widget.bgActive;
              }
              return widget.bgDefault;
            },
          ),
          textStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (Set<WidgetState> states) {
              Color underlineColor;
              final TextStyle? baseTextStyle = widget.style.textStyle!.resolve({});
              if (states.contains(WidgetState.disabled)) {
                 underlineColor = GlobalStyles.textDisabled;
              }
              else if (states.contains(WidgetState.pressed)) {
                underlineColor = widget.bgActive;
              } else {
                underlineColor = widget.bgDefault;
              }
              return (widget.showUnderline ?? true) ? 
                baseTextStyle!.copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: underlineColor,
                ) : baseTextStyle!;
            },
          ),
        ),
        child: Text(widget.text ?? ''),
      )
      :
      (widget.btnType == ButtonType.appleBtn || widget.btnType == ButtonType.googleBtn)
      ?
      Container(
        padding: EdgeInsets.all(0),
        decoration: ShapeDecoration(
          color: widget.bgDefault,
          shape: CircleBorder(
            side: BorderSide(
              color: widget.border,
              width: 1,
            ),
          ),
          shadows: [
            BoxShadow(
              color: widget.border,
              offset: Offset(0, GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing4)),
              blurRadius: 0,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: widget.style.copyWith(
            elevation: const WidgetStatePropertyAll(0),
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return widget.bgActive;
                }
                if (states.contains(WidgetState.disabled)) {
                  return GlobalStyles.btnBgDisabled;
                }
                return widget.bgDefault;
              },
            ),
            padding: WidgetStatePropertyAll(EdgeInsets.all(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing12))),
            minimumSize: WidgetStatePropertyAll(Size.zero),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
            surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
            splashFactory: NoSplash.splashFactory,
          ),
          child: SvgPicture.asset(
            widget.btnType == ButtonType.appleBtn ? 'assets/icons/apple_icon.svg' : 'assets/icons/google_icon.svg',
            // width: GlobalStyles.spacingStates.iconSize,
            // height: GlobalStyles.spacingStates.iconSize,
          ),
        )
      )
      :
      ElevatedBorderWidget(
        width: widget.width,
        height: widget.height,
        smoothness: 1,
        state: onPressed,
        borderColor: widget.border,
        child: 
        ElevatedButton.icon(
          onPressed: onPressed,
          icon: (widget.customIcon !=null)? widget.customIcon : (widget.icon) != null ? 
                VariedIcon.varied(widget.icon!,
                    color: (onPressed==null) ? GlobalStyles.textDisabled : widget.textDefault)
                : widget.showIsSaving != true ? null : SizedBox(
                  width: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16),
                  height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16, useWidth: true),
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: GlobalStyles.textDisabled,
                  ),
                ),
          iconAlignment: widget.iconAlignment ?? IconAlignment.start,
          style: widget.style.copyWith(
            elevation: const WidgetStatePropertyAll(0),
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return widget.bgActive;
                }
                if (states.contains(WidgetState.disabled)) {
                  return GlobalStyles.btnBgDisabled;
                }
                return widget.bgDefault;
              },
            ),
            foregroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return GlobalStyles.textDisabled;
                }
                return widget.textDefault;
              },
            ),
            shape: WidgetStateProperty.resolveWith<SmoothRectangleBorder>(
              (Set<WidgetState> states) {
                Color border = widget.border;
                if (states.contains(WidgetState.disabled)) {
                  border = GlobalStyles.defaultBorder;
                }
                else {
                  border = widget.border;
                }
                return SmoothRectangleBorder(
                  side: BorderSide( color: border),
                  smoothness: 1,
                  borderRadius: BorderRadius.all(Radius.circular(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing20),)),
                );
              },
            ),
          ),
          label: Text(
              widget.text ?? '',
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              textHeightBehavior: const TextHeightBehavior(leadingDistribution: TextLeadingDistribution.even),
          )
      ));
  }
}