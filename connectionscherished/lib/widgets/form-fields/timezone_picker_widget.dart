import 'package:connectionscherished/models/timezone_model.dart';
import 'package:connectionscherished/services/util_service.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/timezone_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:smooth_corner/smooth_corner.dart';

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

  @override
  void dispose() {
    super.dispose();
  }

  initializeTimezone() async {
    if(mounted){
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
    return GestureDetector(
      onTap: widget.isDisabled ? null : () {
        showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing32)),
            ),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
          ),
          backgroundColor: Colors.white,
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (BuildContext context) {
            return TimezoneListPage(
              formattedTimezones: formattedTimezones,
              selectedTimezone: (value){
                setSelectedTimezone(value);
              },
            );
          }
        );
      }, 
      child: SmoothContainer(
        padding: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing12, useWidth: true), vertical: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing12)),
        smoothness: 1,
        color: widget.isDisabled ? GlobalStyles.defaultTextBg : GlobalStyles.defaultBg,
        side: BorderSide(color: widget.isDisabled ? Colors.transparent : GlobalStyles.defaultBorderEnabled),
        borderRadius: BorderRadius.circular(widget.isDisabled ? GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing12) : GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                selectedTimezone?.replaceAll('_', ' ') ?? 'Select timezone',
                style: GlobalStyles.textStyles.textBody,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if(!widget.isDisabled)
            Padding(
              padding: EdgeInsets.only(left: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing8, useWidth: true),),
              child: VariedIcon.varied(Symbols.keyboard_arrow_down_rounded, color: GlobalStyles.primaryText)
            )
          ],
        )
      ),
    );
    
  //   return CustomDropdownWidget(
  //     disabled: widget.isDisabled,
  //     onChanged:(value) {
  //       setSelectedTimezone(value);
  //     }, 
  //     dropdownItems: formattedTimezones
  //       .map((TimezoneModel zone) {
  //         return DropdownItems(
  //           value: zone.location,
  //           label: zone.label,
  //           enabledButton: true
  //         );
  //       }).toList(),
  //     initialValue: selectedTimezone,
  //     menuWidth: 0.8,
  //     menuHeight: 200,
  //   );
  }
}