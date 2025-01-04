import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DialogWidget extends StatelessWidget {
  DialogWidget({super.key, required this.onResponse, required this.header, this.descriptions, this.cancelTitle, this.confirmTitle, this.image, this.isWarning=false, this.customCancelFunction, this.customConfirmFunction});
  final String header;
  List<String>? descriptions;
  String? cancelTitle;
  String? confirmTitle;
  Function(bool) onResponse;
  bool ? isWarning;
  Function () ? customConfirmFunction;
  Function () ? customCancelFunction;
  ///Image.asset with dimensions
  Image? image;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(GlobalStyles.spacingStates.spacing16),
      backgroundColor: GlobalStyles.globalBgDefault,
      shape: RoundedRectangleBorder(
          // smoothness: 0.6,
          borderRadius: BorderRadius.circular(20.0),
        ),
      child: Container(
        padding: EdgeInsets.all(GlobalStyles.spacingStates.spacing24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                if(image != null)
                  Container(
                    padding: EdgeInsets.only(bottom: GlobalStyles.spacingStates.spacing24),
                    child: image,
                  ),
                Text(
                  header,
                  style: GlobalStyles.textStyles.heading3,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: GlobalStyles.spacingStates.spacing16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: descriptions?.map((description) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: GlobalStyles.spacingStates.spacing16),
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: GlobalStyles.textStyles.body1.copyWith(color: GlobalStyles.globalTextSubtle),
                      ),
                    );
                  }).toList() ?? [],
                ),
                SizedBox(height: GlobalStyles.spacingStates.spacing24),
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
                SizedBox(height: GlobalStyles.spacingStates.spacing16),
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
                : CustomButtonWidget.tertiary(text: cancelTitle ?? 'No', onPressed: () {
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
          ],
        ),
      ),
    );
  }
}
