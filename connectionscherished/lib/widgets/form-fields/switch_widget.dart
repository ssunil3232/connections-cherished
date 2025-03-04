import 'package:connectionscherished/styles/styles.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SwitchWidget extends StatefulWidget {
  bool initialState = false;
  final Function(bool) onChange;
  String ? labelText;
  bool isDisabled;

  SwitchWidget({
    super.key,
    this.initialState = false,
    required this.onChange,
    required this.isDisabled,
    this.labelText,
  });

  @override
  _SwitchWidgetState createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {

  @override
  void initState() {
    super.initState();
    setState(() {
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: widget.isDisabled ? null : () {
            setState(() {
              widget.initialState = !widget.initialState;
            });
            widget.onChange(widget.initialState);
          },
          child: AbsorbPointer(
            absorbing: widget.isDisabled,
            child: Switch(
              value: widget.initialState,
              padding: EdgeInsets.all(0),
              inactiveTrackColor: GlobalStyles.defaultTextBg,
              inactiveThumbColor: GlobalStyles.btnBgPrimary,
              activeTrackColor: GlobalStyles.btnBgPrimary,
              activeColor:GlobalStyles.btnBorderPrimary,
              trackOutlineColor: WidgetStatePropertyAll(GlobalStyles.defaultTextBg),
              trackOutlineWidth: WidgetStatePropertyAll(0.5),
              onChanged:(bool value) {
                if(!widget.isDisabled){
                setState(() {
                  widget.initialState = value;
                });
                widget.onChange(value);
                }
              },
            ),
          )
        ),
        if(widget.labelText != null && widget.labelText != '')
        Text(
          widget.labelText!,
          style: GlobalStyles.textStyles.textCaption3
        )
      ]
    );
  }
}