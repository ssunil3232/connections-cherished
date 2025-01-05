import 'package:connectionscherished/styles/button_styles.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/elevated_border_widget.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:smooth_corner/smooth_corner.dart';

enum ButtonType {primary, secondary, teritary, tertiaryAlert, primaryAlert}
// ignore: must_be_immutable
class CustomButtonWidget extends StatefulWidget {
  String? text; 
  IconData? icon;
  IconAlignment? iconAlignment;
  VoidCallback? onPressed;
  double? width;
  double? height;
  bool? isEnabled;
  bool? showIsSaving;

  CustomButtonWidget({
    this.text,
    this.icon,
    this.iconAlignment,
    this.onPressed,
    this.width,
    this.height,
    this.isEnabled = true,
    this.showIsSaving = false,
    super.key
  });

  ButtonStyle style = ButtonStyles.primaryButton;
  Color bgActive = ButtonStyles.primaryBtnStyle.bgActive;
  Color bgDefault = ButtonStyles.primaryBtnStyle.bgDefault;
  Color textDefault = ButtonStyles.primaryBtnStyle.text;
  Color border = ButtonStyles.primaryBtnStyle.border;
  ButtonType btnType = ButtonType.primary;

  // Primary Button
  CustomButtonWidget.primary({super.key, this.onPressed, this.text, this.icon, this.width, this.height, this.iconAlignment, this.isEnabled, this.showIsSaving})
      : btnType = ButtonType.primary,
        style = ButtonStyles.primaryButton,
        textDefault = ButtonStyles.primaryBtnStyle.text,
        bgDefault = ButtonStyles.primaryBtnStyle.bgDefault,
        border = ButtonStyles.primaryBtnStyle.border,
        bgActive = ButtonStyles.primaryBtnStyle.bgActive;

    // Secondary Button
  CustomButtonWidget.secondary({super.key, required this.onPressed, this.text, this.icon, this.width, this.height, this.iconAlignment, this.isEnabled, this.showIsSaving})
      : btnType = ButtonType.secondary,
        style = ButtonStyles.secondaryButton,
        textDefault = ButtonStyles.secondaryBtnStyle.text,
        bgDefault = ButtonStyles.secondaryBtnStyle.bgDefault,
        border = ButtonStyles.secondaryBtnStyle.border,
        bgActive = ButtonStyles.secondaryBtnStyle.bgActive;

      // Primary Alert Button
  CustomButtonWidget.primaryAlert({super.key, required this.onPressed, this.text, this.icon, this.width, this.height, this.iconAlignment, this.isEnabled, this.showIsSaving})
      : btnType = ButtonType.primaryAlert,
        style = ButtonStyles.primaryAlertButton,
        textDefault = ButtonStyles.primaryAlertButtonStyle.text,
        bgDefault = ButtonStyles.primaryAlertButtonStyle.bgDefault,
        border = ButtonStyles.primaryAlertButtonStyle.border,
        bgActive = ButtonStyles.primaryAlertButtonStyle.bgActive;

    // Tertiary Button
  CustomButtonWidget.tertiary({super.key, required this.onPressed, required this.text, this.isEnabled})
      : btnType = ButtonType.teritary,
        style = ButtonStyles.tertiaryButton,
        bgDefault = ButtonStyles.tertiaryBtnStyle.textDefault,
        bgActive = ButtonStyles.tertiaryBtnStyle.textActive;
  
    // Tertiary Alert Button
  CustomButtonWidget.tertiaryAlert({super.key, required this.onPressed, required this.text, this.isEnabled})
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

    return (widget.btnType == ButtonType.teritary || widget.btnType == ButtonType.tertiaryAlert)?
      TextButton(
        onPressed: onPressed,
        style: widget.style.copyWith(
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                 return GlobalStyles.globalTextDisabled;
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
                 underlineColor = GlobalStyles.globalTextDisabled;
              }
              else if (states.contains(WidgetState.pressed)) {
                underlineColor = widget.bgActive;
              } else {
                underlineColor = widget.bgDefault;
              }
              return baseTextStyle!.copyWith(
                decoration: TextDecoration.underline,
                decorationColor: underlineColor,
              );
            },
          ),
        ),
        child: Text(widget.text ?? ''),
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
          icon: (widget.icon) != null ? 
                VariedIcon.varied(widget.icon!,
                    color: (onPressed==null) ? GlobalStyles.globalTextDisabled : widget.textDefault)
                : widget.showIsSaving != true ? null : SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: GlobalStyles.globalTextDisabled,
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
                  return GlobalStyles.globalBgDisabled;
                }
                return widget.bgDefault;
              },
            ),
            foregroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return GlobalStyles.globalTextDisabled;
                }
                return widget.textDefault;
              },
            ),
            shape: WidgetStateProperty.resolveWith<SmoothRectangleBorder>(
              (Set<WidgetState> states) {
                Color border = widget.border;
                if (states.contains(WidgetState.disabled)) {
                  border = GlobalStyles.globalBorderDisabled;
                }
                else {
                  border = widget.border;
                }
                return SmoothRectangleBorder(
                  side: BorderSide( color: border),
                  smoothness: 1,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
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