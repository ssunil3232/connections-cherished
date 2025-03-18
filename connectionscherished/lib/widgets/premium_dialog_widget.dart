import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_corner/smooth_corner.dart';

// ignore: must_be_immutable
class PremiumDialogWidget extends StatelessWidget {
  PremiumDialogWidget({super.key, required this.onResponse});
  Function(bool) onResponse;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(GlobalStyles.spacingStates.spacing16),
      shape: SmoothRectangleBorder(
        smoothness: 0.6,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [GlobalStyles.btnBgSecondary, GlobalStyles.defaultBg],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                    width: 24, 
                    height: 24
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(
                left: GlobalStyles.spacingStates.spacing24,
                right: GlobalStyles.spacingStates.spacing24,
                top: 0,
                bottom: GlobalStyles.spacingStates.spacing24
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.spacing16),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children:[
                          TextSpan(
                            text: "Unlock our",
                            style: GlobalStyles.textStyles.textBody
                          ),
                          TextSpan(
                            text: " premium features ",
                            style: GlobalStyles.textStyles.textH2.copyWith(color: GlobalStyles.btnBorderPrimary, )
                          ),
                          TextSpan(
                            text: "to get the full experience of connections cherished!",
                            style: GlobalStyles.textStyles.textBody
                          ),
                        ],
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/premium-features.gif',
                    width: 200,
                    height: 200,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing8, bottom: GlobalStyles.spacingStates.spacing24),
                    child: Text(
                      "Personalized insights, analytical tracking, recommendations, AI-driven messaging, and more!",
                      textAlign: TextAlign.center,
                      style: GlobalStyles.textStyles.textCaption1,
                    ),
                  ),
                  Text(
                    "3 days free",
                    textAlign: TextAlign.center,
                    style: GlobalStyles.textStyles.textH2Bold,
                  ),
                  Text(
                    "Then \$5.00/month",
                    textAlign: TextAlign.center,
                    style: GlobalStyles.textStyles.textCaption1,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.spacing12),
                    child: CustomButtonWidget.primary(text: 'Try it now!', onPressed: () {
                      Navigator.of(context).pop();
                      onResponse(true);
                    }),
                  ),
                  Text(
                    "No commitment, cancel anytime.",
                    textAlign: TextAlign.center,
                    style: GlobalStyles.textStyles.textCaption3,
                  ),
                ],
              ),
            )
          ]
        ),
      ),
    );
  }
}