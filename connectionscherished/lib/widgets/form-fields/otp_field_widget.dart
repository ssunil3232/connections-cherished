import 'package:connectionscherished/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

// ignore: must_be_immutable
class OtpFieldWidget extends StatefulWidget {
  String ? labelText;
  final Function(String) onCompleted;
  final Function(bool) inComplete;
  bool processingOtp;

  OtpFieldWidget({
    super.key,
    this.labelText,
    required this.onCompleted,
    required this.inComplete,
    required this.processingOtp
  });

  @override
  _OTPInputFieldState createState() => _OTPInputFieldState();
}

class _OTPInputFieldState extends State<OtpFieldWidget> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  
  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (index) => TextEditingController());
    _focusNodes = List.generate(6, (index) => FocusNode());
  }

  @override
  void dispose() {
    // ignore: avoid_function_literals_in_foreach_calls
    _controllers.forEach((controller) => controller.dispose());
    // ignore: avoid_function_literals_in_foreach_calls
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  void _onTextChanged(String value, int index, BuildContext context) {
    if (value.length == 1 && index < 6 - 1) {
      FocusScope.of(context).nextFocus();
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).previousFocus();
    }
    String otp = _controllers.map((controller) => controller.text).join();
    if (otp.length == 6) {
      widget.onCompleted(otp);
    }
    else {
      widget.inComplete(true);
    }
  }

  bool processingState(){
    if(widget.processingOtp){
      // ignore: avoid_function_literals_in_foreach_calls
      _focusNodes.forEach((focusNode) => focusNode.unfocus());
    }
    return widget.processingOtp;
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Enter verification code', style: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.textSubtle)),
        SizedBox(height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing4)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return Expanded(
              child: Padding(
              padding: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing4, useWidth: true)),
              child: 
              TextField(
                readOnly: processingState(),
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                cursorColor: GlobalStyles.textSubtle,
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9$separator]")),
                ],
                maxLength: 1,
                style: GlobalStyles.textStyles.textBody,
                decoration: GlobalStyles.inputFieldDecoration.copyWith(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  counterText: "",
                  contentPadding: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16, useWidth: true), vertical: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing20))
                ),
                onChanged: (value) => _onTextChanged(value, index, context),
              ),
            ));
          }),
        )
      ]
    );
  }
}
