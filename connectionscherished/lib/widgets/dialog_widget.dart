import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_corner/smooth_corner.dart';

// ignore: must_be_immutable
class DialogWidget extends StatelessWidget {
  DialogWidget({super.key, required this.onResponse, this.customBody, this.showCustomCancel = false, this.header, this.descriptions, this.cancelTitle, this.confirmTitle, this.image, this.isWarning=false, this.customCancelFunction, this.customConfirmFunction});
  String ? header;
  List<String>? descriptions;
  String? cancelTitle;
  String? confirmTitle;
  Function(bool) onResponse;
  bool ? isWarning;
  Widget ? customBody;
  bool ? showCustomCancel = false;
  Function () ? customConfirmFunction;
  Function () ? customCancelFunction;
  ///Image.asset with dimensions
  Image? image;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16)),
      backgroundColor: GlobalStyles.defaultBg,
      shape: SmoothRectangleBorder(
          smoothness: 0.6,
          borderRadius: BorderRadius.circular(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing20)),
        ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(showCustomCancel == true)
          Row(
            children: [
              Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onResponse(false);
                },
                icon: SvgPicture.asset(
                  'assets/icons/close_icon.svg', 
                  width: GlobalStyles.spacingStates.iconSize, 
                  height: GlobalStyles.spacingStates.iconSize
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(
              left: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing24, useWidth: true),
              right: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing24, useWidth: true),
              top: customBody ==null ? GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing24) : 0,
              bottom: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing24)
            ),
            child: customBody ?? Column(
              children: [
                if(header != null)
                  Text(
                    header ?? '',
                    style: GlobalStyles.textStyles.textH3,
                    textAlign: TextAlign.center,
                  ),
                if(header != null)
                  SizedBox(height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: descriptions?.map((description) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16)),
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: GlobalStyles.textStyles.textBody,
                      ),
                    );
                  }).toList() ?? [],
                ),
                if(image != null)
                  Container(
                    padding: EdgeInsets.only(bottom: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing24)),
                    child: image,
                  ),
                CustomButtonWidget.primary(text: confirmTitle ?? 'Yes', onPressed: () {
                  if(customConfirmFunction == null){
                    Navigator.of(context).pop();
                    onResponse(true);
                  }
                  else {
                    customConfirmFunction!();
                    onResponse(true);
                  }
                }),
                if(showCustomCancel == false)
                SizedBox(height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16)),
                if(showCustomCancel == false)
                (isWarning==true)
                ? CustomButtonWidget.tertiaryAlert(text: cancelTitle ?? 'No', onPressed: () {
                  if(customCancelFunction == null){
                    Navigator.of(context).pop();
                    onResponse(false);
                  }
                  else {
                    customCancelFunction!();
                    onResponse(false);
                  }
                })
                : CustomButtonWidget.secondary(text: cancelTitle ?? 'No', onPressed: () {
                  if(customCancelFunction == null){
                    Navigator.of(context).pop();
                    onResponse(false);
                  }
                  else {
                    customCancelFunction!();
                    onResponse(false);
                  }
                }),
              ],
            ),
          )
        ]
      ),
    );
  }
}
