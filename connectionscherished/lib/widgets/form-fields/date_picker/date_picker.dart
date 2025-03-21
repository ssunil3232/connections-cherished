import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/form-fields/freq_picker/freq_dialog_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DatePicker extends StatefulWidget {
  DatePicker(
      {super.key,
      required this.date,
      required this.month,
      required this.year,
      required this.header,
      this.setBirthday = false,
      required this.onChanged});

  int date;
  int month;
  int year;
  bool setBirthday = false;
  String header;
  final Function(DateTime) onChanged;

  @override
  DatePickerState createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  late int maxDays;
  late int currentYear;
  late int currentMonth;
  late int currentDate;

  final List<String> months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  void initState() {
    super.initState();
    setDate();
  }

  void setDate() {
    DateTime now = widget.setBirthday == false ? DateTime.now() : DateTime(2024, 12 , 12);
    currentYear = now.year;
    currentMonth = now.month;
    currentDate = now.day;
    maxDays = _daysInMonth(widget.year, widget.month);
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.header, style: GlobalStyles.textStyles.textH2),
          SizedBox(height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing20)),
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
                    Text('Day', style: GlobalStyles.textStyles.textCaption2),
                    SizedBox(
                      height: 250,
                      width: 70,
                      child: CupertinoPicker(
                        selectionOverlay: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing12)),
                            color: const Color.fromARGB(97, 250, 205, 43),
                          ),
                        ),
                        scrollController: FixedExtentScrollController(initialItem: widget.date - 1),
                        itemExtent: 46,
                        backgroundColor: Colors.transparent,
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            widget.date = index + 1;
                          });
                        },
                        children: [
                          for (int i = 1; i <= (widget.year == currentYear && widget.month == currentMonth ? currentDate : maxDays); i++)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing8)),
                              child: FreqField(
                                field: i,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Month', style: GlobalStyles.textStyles.textCaption2),
                    SizedBox(
                      height: 250,
                      width: 70,
                      child: CupertinoPicker(
                        selectionOverlay: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing12)),
                            color: const Color.fromARGB(97, 250, 205, 43),
                          ),
                        ),
                        scrollController: FixedExtentScrollController(initialItem: widget.month - 1),
                        itemExtent: 46,
                        backgroundColor: Colors.transparent,
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            widget.month = index + 1;
                            maxDays = _daysInMonth(widget.year, widget.month);
                            if (widget.date > maxDays) {
                              widget.date = maxDays;
                            }
                          });
                        },
                        children: [
                          for (int i = 1; i <= (widget.year == currentYear ? currentMonth : 12); i++)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing8)),
                              child: FreqField(
                                field: i,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ]
                ),
                if(widget.setBirthday == false)
                Column(
                  children: [
                    Text('Year', style: GlobalStyles.textStyles.textCaption2),
                    SizedBox(
                      height: 250,
                      width: 70,
                      child: CupertinoPicker(
                        selectionOverlay: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing12)),
                            color: const Color.fromARGB(97, 250, 205, 43),
                          ),
                        ),
                        scrollController: FixedExtentScrollController(initialItem: widget.year - (currentYear - 20)),
                        itemExtent: 46,
                        backgroundColor: Colors.transparent,
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            widget.year = (currentYear - 20) + index;
                            maxDays = _daysInMonth(widget.year, widget.month);
                            if (widget.date > maxDays) {
                              widget.date = maxDays;
                            }
                          });
                        },
                        children: [
                          for (int i = (currentYear - 20); i <= currentYear; i++) // Only allow the current year
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing8)),
                              child: FreqField(
                                field: i,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ]
                )
              ],
            ),
            CustomButtonWidget.secondary(
              onPressed: () {
                widget.onChanged(DateTime(widget.year, widget.month, widget.date));
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
