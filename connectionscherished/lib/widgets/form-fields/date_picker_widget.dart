import 'dart:io';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/util/date_format_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:smooth_corner/smooth_corner.dart';

// ignore: must_be_immutable
class DatePickerWidget extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime) onDateSelected;
  bool disabled;
  String ? labelText;
  bool ? setIntialValue;
  final String placeholderText;

  DatePickerWidget({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
    this.labelText,
    this.disabled = false,
    this.setIntialValue = false,
    this.placeholderText = 'MM/DD/YYYY'
  });

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  final TextEditingController _dateController = TextEditingController();
  bool _isDatePickerVisible = false;
  OverlayEntry? _overlayEntry;
  DateTime ? selectedDate;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedDate = widget.initialDate;
      if(widget.setIntialValue != false){
        _dateController.text = monthDayYearFormatter(widget.initialDate);
      }
    });
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(widget.labelText!= null)
          Text(widget.labelText!, style: GlobalStyles.textStyles.body1.copyWith(color: GlobalStyles.globalTextSubtle)),
        if(widget.labelText!= null)
          SizedBox(height: GlobalStyles.spacingStates.spacing4,),
        GestureDetector(
          onTap: widget.disabled ? null : () {
            FocusScope.of(context).requestFocus(FocusNode());
            (Platform.isIOS) ? _toggleDatePicker() : _selectDate(context);
          },
          child: AbsorbPointer(
            child: TextField(
              controller: _dateController,
              style: GlobalStyles.textStyles.body1,
              keyboardType: TextInputType.datetime,
              decoration: GlobalStyles.inputFieldDecoration.copyWith(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: widget.placeholderText,
                enabledBorder: _isDatePickerVisible ?
                  OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0, color: GlobalStyles.globalTextSubtle),
                    borderRadius: BorderRadius.circular(20.0),
                  ) :
                  OutlineInputBorder(
                    borderSide: BorderSide(width: 1.0, color: GlobalStyles.cardBorderDefault),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
              ),
            ),
          ),
        )
      ]
    );
  }

  void _toggleDatePicker() {
    if (_isDatePickerVisible) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
    setState(() {
      _isDatePickerVisible = !_isDatePickerVisible;
    });
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              _removeOverlay();
              setState(() {
                _isDatePickerVisible = !_isDatePickerVisible;
              });
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Positioned(
          left: offset.dx,
          top: offset.dy + size.height + GlobalStyles.spacingStates.spacing8,
          width: size.width,
          child: Material(
            color: Colors.transparent,
            child: SmoothContainer(
              height: 213,
              color: const Color(0xffF3F4F5),
              borderRadius: BorderRadius.circular(20),
              smoothness: 0.6,
              side: BorderSide(
                color: GlobalStyles.cardBorderDefault
              ),
              child: CupertinoDatePicker(
                backgroundColor: const Color(0xffF3F4F5),
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (pickedDate) {
                  setState(() {
                    selectedDate = pickedDate;
                    _dateController.text = monthDayYearFormatter(pickedDate);
                    widget.onDateSelected(pickedDate);
                  });
                },
                initialDateTime: selectedDate,
                minimumDate: widget.firstDate,
                maximumDate: widget.lastDate,
              ),
            ),
          ),
        ),
      ])
    );
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      helpText: "Select date of birth",
      confirmText: "Confirm",
      builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xffF3F4F5),
            onPrimary: Colors.black,
            onSurface: Colors.black,
          ),
          datePickerTheme: const DatePickerThemeData(
            todayBorder: BorderSide(color: Colors.black, width: 1),
            todayForegroundColor: WidgetStatePropertyAll(Colors.black),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
          ),
        ),
        child: child!,
      );
    },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = monthDayYearFormatter(picked);
        widget.onDateSelected(picked);
      });
    }
  }

  // void _selectDate() {
  //   showModalBottomSheet(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(12.0),
  //       ),
  //     ),
  //     constraints: BoxConstraints(
  //       maxWidth: MediaQuery.of(context).size.width,
  //     ),
  //     backgroundColor: GlobalStyles.globalBgDefault,
  //     useSafeArea: true,
  //     context: context,
  //     builder: (BuildContext builder) {
  //       return FractionallySizedBox(
  //         widthFactor: 1.0,
  //         heightFactor: 0.6,
  //         child: CupertinoDatePicker(
  //           backgroundColor: GlobalStyles.globalBgDefault,
  //           mode: CupertinoDatePickerMode.date,
  //           onDateTimeChanged: (pickedDate) {
  //             setState(() {
  //               _dateController.text = monthDayYearFormatter(pickedDate);
  //               widget.onDateSelected(pickedDate);
  //             });
  //           },
  //           initialDateTime: widget.initialDate,
  //           minimumDate: widget.firstDate,
  //           maximumDate: widget.lastDate,
  //         ),
  //       );
  //     },
  //   );
  // }
}