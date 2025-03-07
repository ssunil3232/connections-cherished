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
            padding: EdgeInsets.only(bottom: GlobalStyles.spacingStates.spacing4),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item['color'] as Color
                  ),
                ),
                SizedBox(width: GlobalStyles.spacingStates.spacing8),
                Text(item['text'] as String, style: GlobalStyles.textStyles.textCaption2.copyWith(color: GlobalStyles.textSubtle))
              ]
            )
          ),
      ],
    );
  }
}
