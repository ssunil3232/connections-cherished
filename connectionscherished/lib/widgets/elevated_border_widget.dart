import 'package:connectionscherished/styles/button_styles.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ElevatedBorderWidget extends StatelessWidget {
  Widget child; 
  double? width;
  double? height;
  double? elevation;
  Color? borderColor;
  double? smoothness;
  double? radius;
  Color? backgroundColor;
  VoidCallback? state;

  ElevatedBorderWidget({
    required this.child,
    required this.state,
    this.width,
    this.backgroundColor,
    this.height,
    this.elevation,
    this.borderColor,
    this.smoothness,
    this.radius,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        color: backgroundColor ?? GlobalStyles.cardBgDefault,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? 20),
        side: borderColor != null ? BorderSide(width: 1, color: borderColor!): BorderSide.none,
        // smoothness: smoothness ?? 0.6
        ),
        // side: (elevation == 0 ) ? BorderSide(width: 1, color: (state == null) ? GlobalStyles.globalBorderDisabled : borderColor ?? ButtonStyles.btnColors.buttonBorder,): BorderSide.none,
        // color: borderColor ?? ButtonStyles.btnColors.buttonBorder,
        shadows: [
          if(elevation !=0 ) BoxShadow(
            color: (state == null) ? GlobalStyles.globalBorderDisabled : borderColor ?? ButtonStyles.btnColors.buttonBorder,
            offset: Offset(0, elevation ?? GlobalStyles.spacingStates.spacing4),
            blurRadius: 0,
          ),
        ],
      ),
      child: child);
  }
}