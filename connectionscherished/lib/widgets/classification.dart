import 'package:connectionscherished/styles/styles.dart';
import 'package:flutter/material.dart';

class Classification extends StatelessWidget {
  const Classification({super.key});

  static const colorClasses = [
    {'text': 'It’s been a long time mate', 'color': GlobalStyles.criticalColor},
    {'text': 'We should catch up soon', "color": GlobalStyles.warningColor},
    {'text': 'It was great catching up', "color": GlobalStyles.neutralColor}
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (var item in colorClasses)
          Container(
            padding: EdgeInsets.only(bottom: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing4)),
            child: Row(
              spacing: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing8, useWidth: true),
              children: [
                Container(
                  width: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing20, useWidth: true),
                  height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item['color'] as Color
                  ),
                ),
                Text(item['text'] as String, style: GlobalStyles.textStyles.textCaption2.copyWith(color: GlobalStyles.textSubtle))
              ]
            )
          ),
      ],
    );
  }
}
