import 'package:connectionscherished/models/timezone_model.dart';
import 'package:connectionscherished/services/util_service.dart';
import 'package:connectionscherished/widgets/form-fields/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// ignore: must_be_immutable
class TimezonePickerWidget extends StatefulWidget {
  String ? initialTimezone;
  bool isDisabled;
  Function (TimezoneModel) onChanged;
  TimezonePickerWidget({
    super.key,
    required this.onChanged,
    this.initialTimezone,
    this.isDisabled = false
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
    initializeTimezone();
  }

  initializeTimezone() async {
    if(widget.initialTimezone != null && widget.initialTimezone != "") {
      setState(() {
        selectedTimezone = widget.initialTimezone;
      });
      await setSelectedTimezone(widget.initialTimezone!);
    }
    else{
      await setLocalTimezone();
    }
  }

  Future<void> setLocalTimezone() async {
    localTimezone = await _utilService.getLocalTimezone();
    if(mounted) {
      setState(() {
        selectedTimezone = localTimezone.location;
      });
    }
    widget.onChanged(localTimezone);
  }

  setSelectedTimezone(String timezoneName) async {
    TimezoneModel timezone = await _utilService.getTimezone(timezoneName);
    if(mounted){
      setState(() {
        selectedTimezone = timezone.location;
      });
    }
    widget.onChanged(timezone);
  }

  Future<void>getFormattedTimezones() async {
    formattedTimezones = [];
    formattedTimezones = await _utilService.fetchTimezones();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropdownWidget(
      disabled: widget.isDisabled,
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
    );
  }
}