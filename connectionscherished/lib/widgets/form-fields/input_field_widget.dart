import 'package:connectionscherished/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:path/path.dart';

// ignore: must_be_immutable
class InputFieldWidget extends StatelessWidget {
  String ? labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool errorState;
  final bool showErrorText;
  final String errorText;
  final int errorMaxLines;
  final String placeholderText;
  final bool readOnly;
  bool ? isOptional;
  bool ? isMandatory;
  double ? verticalPadding;
  /// Update with more countryCodes if new ones are added
  final String ? countryCode;
  Widget ? suffixIcon;
  Widget ? prefixIcon;
  bool obscureText;
  double ? multilineHeight;

  InputFieldWidget({
    super.key,
    this.labelText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.errorState = false,
    this.errorMaxLines = 4,
    this.placeholderText = '',
    this.countryCode,
    this.readOnly = false,
    this.showErrorText = true,
    this.errorText = 'Invalid input',
    this.suffixIcon,
    this.prefixIcon,
    this.verticalPadding,
    this.isOptional = false,
    this.isMandatory = false,
    this.obscureText = false,
    this.multilineHeight
  });

  // Update if more added
  final countryCodeMapping = {
    "+1": "US",
    "+86": "CN", 
    '+966': "SA",
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(labelText!= null)
          Row(children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: labelText!, style: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.textSubtle)),
                  if(isMandatory==true) WidgetSpan(
                    child: Baseline(
                      baseline: 14,
                      baselineType: TextBaseline.alphabetic,
                      child: Text('*', style: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.textSubtle)),
                    ),
                  ),
                ],
              ),
            ),
            if(isOptional==true) 
              Padding(
                padding: EdgeInsets.only(left: GlobalStyles.spacingStates.spacing4),
                child: Text("(optional)", style: GlobalStyles.textStyles.textCaption2.copyWith(color: GlobalStyles.textSubtle)),
              )
          ],),
        if(labelText!= null)
          SizedBox(height: GlobalStyles.spacingStates.spacing4,),
          SizedBox(
            height: multilineHeight ?? null,
            child: TextField(
              readOnly: readOnly,
              enableSuggestions: false,
              textAlignVertical: keyboardType == TextInputType.multiline ? TextAlignVertical.top : TextAlignVertical.center,
              expands: keyboardType == TextInputType.multiline,
              maxLines: keyboardType == TextInputType.multiline ? null : 1,
              obscureText: obscureText,
              obscuringCharacter: '*',
              inputFormatters: [
                if(keyboardType == TextInputType.number || keyboardType == TextInputType.phone || keyboardType == TextInputType.datetime)
                  FilteringTextInputFormatter.allow(RegExp("[0-9$separator]")),
                if(keyboardType == TextInputType.phone && countryCode!=null)
                  PhoneInputFormatter(
                    defaultCountryCode: countryCodeMapping[countryCode],
                  ),
                if(keyboardType == TextInputType.datetime)
                  DateInputFormatter(),
              ],
              controller: controller,
              keyboardType: keyboardType,
              enabled: !readOnly,
              style: GlobalStyles.textStyles.textBody.copyWith(
                color: readOnly ? GlobalStyles.textSubtle : GlobalStyles.primaryText
              ),
              decoration: GlobalStyles.inputFieldDecoration.copyWith(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: true,
                fillColor: errorState ? GlobalStyles.globalErrorBg : readOnly ? GlobalStyles.btnBgDisabled : GlobalStyles.defaultBg,
                hintStyle: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.inputPlaceholderText),
                alignLabelWithHint: keyboardType == TextInputType.multiline,
                labelText: (keyboardType != TextInputType.phone) ? placeholderText : null,
                hintText: (keyboardType == TextInputType.phone && countryCode!=null)
                          ? PhoneCodes.getPhoneCountryDataByCountryCode(countryCodeMapping[countryCode]!)?.phoneMaskWithoutCountryCode
                          : null,
                errorText: controller.text.isEmpty
                    ? null
                    : !errorState
                        ? null
                        : showErrorText ? errorText : null,
                errorMaxLines: errorMaxLines,
                enabledBorder: errorState ?
                  OutlineInputBorder(
                    borderSide: BorderSide(width: 1.0, color: GlobalStyles.globalErrorBorder),
                    borderRadius: BorderRadius.circular(20.0),
                  ) :
                  OutlineInputBorder(
                    borderSide: BorderSide(width: 1.0, color: GlobalStyles.defaultBorder),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                focusedBorder: errorState ?
                  OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0, color: GlobalStyles.globalErrorBorder),
                    borderRadius: BorderRadius.circular(20.0),
                  ) :
                  OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0, color: GlobalStyles.defaultBorderEnabled),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  suffixIcon: suffixIcon,
                  prefixIcon: prefixIcon,
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.0, color: GlobalStyles.defaultBorder),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.spacing16, vertical: verticalPadding ?? 18),
                  isDense: verticalPadding !=null,
              ),
            )
        )
      ],
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }
    if (text.length == 2 || text.length == 5) {
      text += '/';
    }
    if (text.length > 10) {
      text = text.substring(0, 10);
    }
    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
