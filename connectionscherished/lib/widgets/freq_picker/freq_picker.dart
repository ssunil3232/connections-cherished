import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/freq_picker/freq_dialog_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FreqPicker extends StatelessWidget {
  FreqPicker(
      {super.key,
      required this.years,
      required this.months,
      required this.days,
      required this.onChanged});

  int years;
  int months;
  int days;
  final Function(PeriodicAlert) onChanged;

  @override
  Widget build(BuildContext context) {
    PeriodicAlert currFrequency =
        PeriodicAlert(years: years, months: months, days: days);

// Variable to keep track of the selected index
    int selectedYears = currFrequency.years;
    int selectedMonths = currFrequency.months;
    int selectedDays = currFrequency.days;

    if (selectedYears == 0 && selectedMonths == 0 && selectedDays == 0) {
      selectedDays = 1;
    }

    return AlertDialog(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select Alert Frequency', style: GlobalStyles.textStyles.heading4,),
          ],
        ),
        // const Text('Select Frequency'),
        content: SingleChildScrollView(
            // Make the content scrollable to handle overflow
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Years', style: GlobalStyles.textStyles.caption1,),
                Text('Months', style: GlobalStyles.textStyles.caption1,),
                Text('Days', style: GlobalStyles.textStyles.caption1,),
              ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // hours wheel
              SizedBox(
                height: 250,
                width: 70,
                child: CupertinoPicker(
                  scrollController:
                      FixedExtentScrollController(initialItem: selectedYears),
                  itemExtent: 46,
                  backgroundColor: Colors.transparent,
                  onSelectedItemChanged: (int index) {
                    selectedYears = index;
                    if (selectedYears == 0 && selectedMonths == 0 && selectedDays == 0) {
                      selectedDays = 1;
                    }
                  },
                  children: [
                    for (int i = 0; i <= 30; i++)
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0), // Adjust the padding as needed
                          child: FreqField(
                            field: i,
                          ))
                  ],
                ),
              ),

              // minutes wheel
              SizedBox(
                height: 250,
                width: 70,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedMonths,
                  ),
                  itemExtent: 46,
                  backgroundColor: Colors.transparent,
                  onSelectedItemChanged: (int index) {
                    selectedMonths = index;
                    if (selectedYears == 0 && selectedMonths == 0 && selectedDays == 0) {
                      selectedDays = 1;
                    }
                  },
                  children: [
                    for (int i = 0; i <= 30; i++)
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0), // Adjust the padding as needed
                          child: FreqField(
                            field: i,
                          ))
                  ],
                ),
              ),
              // days wheel
              SizedBox(
                height: 250,
                width: 70,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedDays,
                  ),
                  itemExtent: 46,
                  backgroundColor: Colors.transparent,
                  onSelectedItemChanged: (int index) {
                    selectedDays = index;
                  },
                  children: [
                    for (int i = 0; i <= 30; i++)
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0), // Adjust the padding as needed
                          child: FreqField(
                            field: i,
                          ))
                  ],
                ),
              )
            ],
          ),
          CustomButtonWidget.secondary(
            onPressed: () {
              currFrequency = currFrequency.copyWith(
                  days: selectedDays,
                  months: selectedMonths,
                  years: selectedYears);
              onChanged(currFrequency);
              Navigator.of(context).pop();
            },
            text: 'Save',
          )
          // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          //   Expanded(
          //     // Wrap the Container with Expanded
          //     child: Container(
          //       padding: const EdgeInsets.symmetric(horizontal: 10),
          //       child: ElevatedButton(
          //         onPressed: () {
          //           currFrequency = currFrequency.copyWith(
          //               days: selectedDays,
          //               months: selectedMonths,
          //               years: selectedYears);
          //           onChanged(currFrequency);
          //           Navigator.of(context).pop();
          //         },
          //         style: ButtonStyle(
          //           minimumSize: WidgetStateProperty.all(const Size(
          //               double.infinity,
          //               60)), // Ensures the button has a minimum height of 60
          //           shape: WidgetStateProperty.all(
          //             RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(
          //                   10), // Low borderRadius makes the button more rectangular
          //             ),
          //           ),
          //         ),
          //         child: const Text(
          //           'Save',
          //           style: TextStyle(fontSize: 20),
          //         ),
          //       ),
          //     ),
          //   )
          // ]),
        ])));
  }
}
