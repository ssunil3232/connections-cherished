import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/freq_picker/freq_picker.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FreqField extends StatelessWidget {
  final String label;
  FriendModel friend;
  String fieldVal;
  final Function(PeriodicAlert) onChanged;

  FreqField({super.key, required this.label, required this.fieldVal, required this.friend, required this.onChanged});


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return FreqPicker(
                  years: friend.alert.years,
                  months:friend.alert.months,
                  days: friend.alert.days,
                  onChanged: (PeriodicAlert value) {
                    onChanged(value);
                  }
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric( horizontal: 15.0, vertical: 5.0),
            decoration: BoxDecoration(
              color: GlobalStyles.brandColor2,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              fieldVal,
              style: const TextStyle(color: Colors.white,),
            ),
          ),
        ),
        const SizedBox(width: 4.0,),
        Text(label, style: GlobalStyles.textStyles.caption2.copyWith(color: GlobalStyles.globalTextSubtle)),
        const SizedBox(width: 4.0,),
      ]
    );
  }
}