import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/form-fields/freq_picker/freq_picker.dart';
import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';

// ignore: must_be_immutable
class FreqField extends StatelessWidget {
  final String label;
  FriendModel friend;
  String fieldVal;
  bool isDisabled;
  final Function(PeriodicAlert) onChanged;

  FreqField({super.key, required this.label, required this.isDisabled, required this.fieldVal, required this.friend, required this.onChanged});


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: isDisabled ? null : () async {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return FreqPicker(
                  weeks: friend.alert.weeks,
                  months:friend.alert.months,
                  days: friend.alert.days,
                  onChanged: (PeriodicAlert value) {
                    onChanged(value);
                  }
                );
              },
            );
          },
          child: SmoothContainer(
            smoothness: 1,
            width: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing40, useWidth: true),
            height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing32),
            alignment: Alignment.center,
            borderRadius: BorderRadius.circular(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing12)),
            color: isDisabled ? GlobalStyles.defaultTextBg : GlobalStyles.defaultBg,
            side: BorderSide(
              color: isDisabled ? GlobalStyles.defaultTextBg : GlobalStyles.defaultBorderEnabled,
              width: 1,
            ),
            child: Text(
              fieldVal,
              style: GlobalStyles.textStyles.textCaption2,
            ),
          ),
        ),
        SizedBox(width: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing4)),
        Text(label, style: GlobalStyles.textStyles.textCaption2.copyWith(color: GlobalStyles.textSubtle)),
        SizedBox(width: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing4)),
      ]
    );
  }
}