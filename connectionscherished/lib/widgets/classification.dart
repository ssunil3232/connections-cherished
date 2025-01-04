import 'package:connectionscherished/styles/styles.dart';
import 'package:flutter/material.dart';

class Classification extends StatelessWidget {
  const Classification({super.key});

  static const colorClasses = [
    {'text': 'It’s been a long time mate', 'color': GlobalStyles.severeColor},
    {'text': 'We should catch up soon', "color": GlobalStyles.warningColor},
    {'text': 'It was great catching up', "color": GlobalStyles.normalColor}
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (var item in colorClasses)
          SizedBox(
              height: 20,
              child: Row(children: [
                Container(width: 15,height: 15,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: item['color'] as Color),
                ),
                Text(item['text'] as String, style: GlobalStyles.textStyles.caption2)
              ])),
      ],
    );
  }
}
