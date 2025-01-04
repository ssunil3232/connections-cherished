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
  /// Update with more countryCodes if new ones are added
  final String ? countryCode;
  Widget ? suffixIcon;
  bool obscureText;

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
    this.isOptional = false,
    this.isMandatory = false,
    this.obscureText = false
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
            // Text(labelText!, style: GlobalStyles.textStyles.body1.copyWith(color: GlobalStyles.globalTextSubtle)),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: labelText!, style: GlobalStyles.textStyles.body1.copyWith(color: GlobalStyles.globalTextSubtle)),
                  if(isMandatory==true) WidgetSpan(
                    child: Baseline(
                      baseline: 14,
                      baselineType: TextBaseline.alphabetic,
                      child: Text('*', style: GlobalStyles.textStyles.body1.copyWith(color: GlobalStyles.globalTextSubtle)),
                    ),
                  ),
                ],
              ),
            ),
            if(isOptional==true) 
              Padding(
                padding: EdgeInsets.only(left: GlobalStyles.spacingStates.spacing4),
                child: Text("(optional)", style: GlobalStyles.textStyles.caption2.copyWith(color: GlobalStyles.globalTextSubtle)),
              )
          ],),
        if(labelText!= null)
          SizedBox(height: GlobalStyles.spacingStates.spacing4,),
        TextField(
          readOnly: readOnly,
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
          style: GlobalStyles.textStyles.body1,
          decoration: 
            GlobalStyles.inputFieldDecoration.copyWith(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: errorState && controller.text.isNotEmpty,
                fillColor: errorState ? GlobalStyles.globalErrorBg : null,
                hintStyle: GlobalStyles.textStyles.body1.copyWith(color: GlobalStyles.inputPlaceholderText),
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
                    borderSide: BorderSide(width: 1.0, color: GlobalStyles.cardBorderDefault),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                focusedBorder: errorState ?
                  OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0, color: GlobalStyles.globalErrorBorder),
                    borderRadius: BorderRadius.circular(20.0),
                  ) :
                  OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0, color: GlobalStyles.globalTextSubtle),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  suffixIcon: suffixIcon
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
