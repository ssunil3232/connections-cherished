import 'package:connectionscherished/styles/styles.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomDrawerWidget extends StatelessWidget {
  BottomDrawerWidget({super.key, required this.header, required this.content, this.descriptions, this.heightFactor});
  final String header;
  List<String>? descriptions;
  double? heightFactor;
  Widget content;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
            widthFactor: 1.0,
            heightFactor: heightFactor,
            child: Container(
              padding: EdgeInsets.all(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing52, useWidth: true),
                    height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing4),
                    decoration: BoxDecoration(
                      color: Color(0xFFA9A9A9),
                      borderRadius: BorderRadius.circular(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing4)),
                    ),
                  ),
                ),
                SizedBox(height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing32)),
                Text(header, style: GlobalStyles.textStyles.textH2Bold),
                SizedBox(height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing24)),
                Flexible(
                  child: Scrollbar(
                    thumbVisibility: true,
                    thickness: 3,
                    child: SingleChildScrollView(
                      child: content,
                    ),
                  ),
                ),
                SizedBox(height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing20)),
              ],)));
  }
}

void openBottomSheet(
  {
    required BuildContext context, 
    required String header, 
    required Widget body, 
    List<String>? descriptions, 
    double? heightFactor = 0.7,
  }) {
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing12)),
      ),
    ),
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width,
    ),
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext context) {
      return BottomDrawerWidget(
        content: body,
        header: header,
        descriptions: descriptions ?? [],
        heightFactor: heightFactor
      );
    },
  );
}
