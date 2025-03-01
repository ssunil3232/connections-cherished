import 'package:connectionscherished/models/timezone_model.dart';
import 'package:connectionscherished/services/user_service.dart';
import 'package:connectionscherished/widgets/form-fields/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TimezonePickerWidget extends StatefulWidget {
  Function (TimezoneModel) onChanged;
  TimezonePickerWidget({
    super.key,
    required this.onChanged
  });
  @override
  _TimezonePickerWidgetState createState() => _TimezonePickerWidgetState();
}

class _TimezonePickerWidgetState extends State<TimezonePickerWidget> {
  String? selectedTimezone;
  int localTimeOffset = DateTime.now().timeZoneOffset.inHours;
  final _userService = GetIt.I.get<UserService>();
  // final List<String> allTimezones = tz.timeZoneDatabase.locations.keys.toList();
  List<TimezoneModel> formattedTimezones = [];
  TimezoneModel localTimezone = TimezoneModel(
    location: "", 
    label: "",
    offset_hours: ''
  );

  @override
  void initState() {
    super.initState();
    setLocalTimezone();
    getFormattedTimezones();
  }

  Future<String?> getPublicIP() async {
    try {
      final response = await http.get(Uri.parse('https://api64.ipify.org?format=json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['ip'];
      } else {
        debugPrint('Failed to get public IP: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error getting IP: $e');
      return null;
    }
  }

  Future<void> setLocalTimezone() async {
    selectedTimezone = localTimezone.label;
    String? ip = await getPublicIP();
    if (ip != null) {
      var currentZone = await getTimeZones(param: "ip?ipAddress=$ip");
      if (currentZone != null) {
        int timezoneTimeOffset = (currentZone['standardUtcOffset']['seconds']) ~/ 3600;
        int difference = timezoneTimeOffset - localTimeOffset;
        String offset = difference >= 0 ? "+$difference Hrs" : "$difference Hrs";
        localTimezone.location = currentZone['timeZone'];
        localTimezone.label = "${currentZone['timeZone']}, $offset";
        localTimezone.offset_hours = offset;
        debugPrint('Local Timezone: ${localTimezone.label}');
        selectedTimezone = localTimezone.label;
      }
    }
    widget.onChanged(localTimezone);
    setState(() {});
  }

  Future<dynamic> getTimeZones({String ? param}) async {
    String url = param == null ? 'https://timeapi.io/api/timezone/availabletimezones' : 'https://timeapi.io/api/timezone/$param';
    try {
      // Make a GET request
      http.Response response = await http.get(Uri.parse(url));
      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response body
        String responseBody = response.body;
        var timeData = jsonDecode(responseBody);
        return timeData;
      } else {
        // Handle errors
        debugPrint('Failed to fetch time data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception caught: $e');
    }
  }

  Future<void>getFormattedTimezones() async {
    formattedTimezones = [];
    List<TimezoneModel> allTimezones = await _userService.fetchTimezones();
    debugPrint('Timezones: ${allTimezones.length}');
    for(var zone in allTimezones){
      debugPrint('Timezone: ${zone.label}');
    }

    // var timeData = await getTimeZones();
    // for (var zone in timeData) {
    //   String encodedTimeZone = Uri.encodeComponent(zone);
    //   var currentZone = await getTimeZones(param: "zone?timeZone=$encodedTimeZone");
    //   if (currentZone != null) {
    //     int timezoneTimeOffset = (currentZone['standardUtcOffset']['seconds']) ~/ 3600;
    //     int difference = timezoneTimeOffset - localTimeOffset;
    //     String offset = difference >= 0 ? "+$difference Hrs" : "$difference Hrs";
    //     TimezoneModel _timezoneModel = TimezoneModel(
    //       location: currentZone['timeZone'], 
    //       label: "${currentZone['timeZone']}, $offset",
    //       offset_hours: offset
    //     );
    //     debugPrint('Timezone: ${_timezoneModel.label}');
    //     formattedTimezones.add(_timezoneModel);
    //   }
    // }
    // setState(() {});
  }

  

  // List<TimezoneModel> getFormattedTimezones() {
  //   return allTimezones.map((zone) {
  //     final tz.Location location = tz.getLocation(zone);
  //     final int zoneOffset = location.currentTimeZone.offset ~/ 3600000;
  //     final int difference = zoneOffset - localOffset;
  //     final String sign = difference >= 0 ? "+" : "-";
  //     final String timezone = "$sign${difference.abs()} Hrs";
  //     TimezoneModel _timezoneModel = TimezoneModel(
  //       location: zone, 
  //       label: "$zone, $timezone",
  //       locationTime: tz.TZDateTime.now(location)
  //     );
  //     return _timezoneModel;
  //   }).toList();
  // }

  // void setLocalTimezone() {
  //   for (String zone in allTimezones) {
  //     final tz.Location location = tz.getLocation(zone);
  //     final int zoneOffset = location.currentTimeZone.offset ~/ 3600000;

  //     if (zoneOffset == localOffset) {
  //       setState(() {
  //         selectedTimezone = "$zone, ${zoneOffset >= 0 ? '+' : '-'}${zoneOffset.abs()} Hrs";
  //       });
  //       break;
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // List<TimezoneModel> formattedTimezones = getFormattedTimezones();
    // return CustomDropdownWidget(
    //   buttonHeight: 55,
    //   onChanged:(value) {
    //     setState(() {
    //       selectedTimezone = value;
    //     });
    //     // _updateButtonState();
    //   }, 
    //   dropdownItems: formattedTimezones
    //     .map((TimezoneModel zone) {
    //       return DropdownItems(
    //         value: zone.label,
    //         label: zone.label,
    //         enabledButton: true
    //       );
    //     }).toList(),
    //   initialValue: selectedTimezone,
    //   // buttonWidth: 100,
    // );
    return Text('Timezone Picker');
  }
}