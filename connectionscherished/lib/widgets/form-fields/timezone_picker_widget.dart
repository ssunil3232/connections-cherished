import 'package:connectionscherished/models/timezone_model.dart';
import 'package:connectionscherished/services/util_service.dart';
import 'package:connectionscherished/widgets/form-fields/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// ignore: must_be_immutable
class TimezonePickerWidget extends StatefulWidget {
  String ? initialTimezone;
  Function (TimezoneModel) onChanged;
  TimezonePickerWidget({
    super.key,
    required this.onChanged,
    this.initialTimezone
  });
  @override
  _TimezonePickerWidgetState createState() => _TimezonePickerWidgetState();
}

class _TimezonePickerWidgetState extends State<TimezonePickerWidget> {
  String? selectedTimezone;
  final _utilService = GetIt.I.get<UtilService>();
  List<TimezoneModel> formattedTimezones = [];
  TimezoneModel localTimezone = TimezoneModel(
    location: "", 
    label: "",
    offset_hours: ''
  );

  @override
  void initState() {
    super.initState();
    getFormattedTimezones();
    if(widget.initialTimezone != null && widget.initialTimezone != "") {
      debugPrint('Initial timezone: ${widget.initialTimezone}');
      setState(() {
        selectedTimezone = widget.initialTimezone;
      });
      setSelectedTimezone(selectedTimezone!);
    }
    else{
      setLocalTimezone();
    }
  }

  Future<void> setLocalTimezone() async {
    localTimezone = await _utilService.getLocalTimezone();
    selectedTimezone = localTimezone.label;
    widget.onChanged(localTimezone);
    setState(() {
      selectedTimezone = localTimezone.location;
    });
  }

  setSelectedTimezone(String timezoneName) async {
    TimezoneModel timezone = await _utilService.getTimezone(timezoneName);
    widget.onChanged(timezone);
    setState(() {
      selectedTimezone = timezone.location;
    });
  }

  Future<void>getFormattedTimezones() async {
    formattedTimezones = [];
    formattedTimezones = await _utilService.fetchTimezones();
  }

  @override
  Widget build(BuildContext context) {
    // List<TimezoneModel> formattedTimezones = getFormattedTimezones();
    return CustomDropdownWidget(
      buttonHeight: 55,
      onChanged:(value) {
        setSelectedTimezone(value);
      }, 
      dropdownItems: formattedTimezones
        .map((TimezoneModel zone) {
          return DropdownItems(
            value: zone.location,
            label: zone.label,
            enabledButton: true
          );
        }).toList(),
      initialValue: selectedTimezone,
      menuWidth: 0.8,
      menuHeight: 200,
      // buttonWidth: 100,
    );
  }
}