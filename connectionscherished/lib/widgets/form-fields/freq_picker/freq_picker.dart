import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/form-fields/freq_picker/freq_dialog_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FreqPicker extends StatelessWidget {
  FreqPicker(
      {super.key,
      required this.months,
      required this.weeks,
      required this.days,
      required this.onChanged});

  int weeks;
  int months;
  int days;
  final Function(PeriodicAlert) onChanged;

  @override
  Widget build(BuildContext context) {
    PeriodicAlert currFrequency =
        PeriodicAlert(weeks: weeks, months: months, days: days);

// Variable to keep track of the selected index
    int selectedWeeks = currFrequency.weeks;
    int selectedMonths = currFrequency.months;
    int selectedDays = currFrequency.days;

    if (selectedWeeks == 0 && selectedMonths == 0 && selectedDays == 0) {
      selectedWeeks = 1;
    }

    return AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Set alert frequency', style: GlobalStyles.textStyles.textH2),
          SizedBox(height: GlobalStyles.spacingStates.spacing20),
        ],
      ),
      backgroundColor: GlobalStyles.defaultBg,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text('Months', style: GlobalStyles.textStyles.textCaption2),
                    SizedBox(
                      height: 250,
                      width: 70,
                      child: CupertinoPicker(
                        selectionOverlay: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(97, 250, 205, 43)
                          ),
                        ),
                        scrollController: FixedExtentScrollController(initialItem: selectedMonths),
                        itemExtent: 46,
                        backgroundColor: Colors.transparent,
                        onSelectedItemChanged: (int index) {
                          selectedMonths = index;
                          if (selectedWeeks == 0 && selectedMonths == 0 && selectedDays == 0) {
                            selectedWeeks = 1;
                          }
                        },
                        children: [
                          for (int i = 0; i <= 12; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: FreqField(
                                field: i,
                              )
                            )
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Weeks', style: GlobalStyles.textStyles.textCaption2),
                    SizedBox(
                      height: 250,
                      width: 70,
                      child: CupertinoPicker(
                        selectionOverlay: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(97, 250, 205, 43)
                          ),
                        ),
                        scrollController: FixedExtentScrollController(initialItem: selectedWeeks),
                        itemExtent: 46,
                        backgroundColor: Colors.transparent,
                        onSelectedItemChanged: (int index) {
                          selectedWeeks = index;
                          if (selectedWeeks == 0 && selectedMonths == 0 && selectedDays == 0) {
                            selectedWeeks = 1;
                          }
                        },
                        children: [
                          for (int i = 0; i <= 12; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: FreqField(
                                field: i,
                              )
                            )
                        ],
                      ),
                    ),
                  ]
                ),
                Column(
                  children: [
                    Text('Days', style: GlobalStyles.textStyles.textCaption2),
                    SizedBox(
                      height: 250,
                      width: 70,
                      child: CupertinoPicker(
                        selectionOverlay: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(97, 250, 205, 43)
                          ),
                        ),
                        scrollController: FixedExtentScrollController(initialItem: selectedDays),
                        itemExtent: 46,
                        backgroundColor: Colors.transparent,
                        onSelectedItemChanged: (int index) {
                          selectedDays = index;
                          if (selectedWeeks == 0 && selectedMonths == 0 && selectedDays == 0) {
                            selectedWeeks = 1;
                          }
                        },
                        children: [
                          for (int i = 0; i <= 30; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: FreqField(
                                field: i,
                              )
                            )
                        ],
                      ),
                    ),
                  ]
                )
              ],
            ),
            CustomButtonWidget.secondary(
              onPressed: () {
                currFrequency = currFrequency.copyWith(
                    days: selectedDays,
                    months: selectedMonths,
                    weeks: selectedWeeks);
                onChanged(currFrequency);
                Navigator.of(context).pop();
              },
              text: 'Save',
            )
          ]
        )
      )
    );
  }
}
