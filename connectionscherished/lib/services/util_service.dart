import 'dart:convert';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectionscherished/models/timezone_model.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class UtilService {
  final _firestore = GetIt.I.get<FirebaseFirestore>();
  final timezoneCollection = "timezones";

  // to get list of timezones from firestore
  Future<List<TimezoneModel>> fetchTimezones() async {
    List<TimezoneModel> timezones = [];
    try {
      QuerySnapshot snapshot = await _firestore.collection(timezoneCollection).get();
      for (var doc in snapshot.docs) {
        timezones.add(TimezoneModel.fromMap(doc.data() as Map<String, dynamic>));
      }
    } catch (e) {
      print("Error fetching timezones: $e");
    }
    return timezones;
  }

  // to get timezone by location from firestore
  Future<TimezoneModel> getTimezone(String zoneName) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
        .collection(timezoneCollection)
        .where('location', isEqualTo: zoneName)
        .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        return TimezoneModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        print('No document found with location: $zoneName');
        return TimezoneModel(location: "Unknown", label: "Unknown", offset_hours: "UTC(+00:00)");
      }
    } catch (e) {
      print("Error fetching timezone: $e");
      return TimezoneModel(location: "Unknown", label: "Unknown", offset_hours: "UTC(+00:00)");
    }
  }

  // to get local IP address
  Future<String?> getPublicIP() async {
    try {
      final response = await http.get(Uri.parse('https://api64.ipify.org?format=json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['ip'];
      } else {
        print('Failed to get public IP: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting IP: $e');
      return null;
    }
  }

  // to get list of timezones from timeapi.io
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
        print('Failed to fetch time data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception caught: $e');
    }
  }

  // to get detail of timezone from timeapi.io
  Future<dynamic> getTimeZoneDetail(String zoneName) async {
    String encodedTimeZone = Uri.encodeComponent(zoneName);
    String url = 'https://timeapi.io/api/timezone/zone?timeZone=$encodedTimeZone';
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
        print('Failed to fetch time data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception caught: $e');
    }
  }

  // to get local timezone
  Future<TimezoneModel> getLocalTimezone() async {
    String? ip = await getPublicIP();
    if (ip != null) {
      var currentZone = await getTimeZones(param: "ip?ipAddress=$ip");
      if (currentZone != null) {
        TimezoneModel localTimezone = await getTimezone(currentZone['timeZone']);
        return localTimezone;
      }
    }
    return TimezoneModel(location: "Unknown", label: "Unknown", offset_hours: "UTC(+00:00)");
  }

  Future<String> getUserAvatar() async {
    final List<String> imageUrls = [];
    firebase_storage.ListResult avatars = await firebase_storage
        .FirebaseStorage.instance
        .ref('assets/images/avatars')
        .listAll();

    for (firebase_storage.Reference ref in avatars.items) {
      final String url = await ref.fullPath;
      imageUrls.add(url);
    }
    final random = Random();
    final img = imageUrls.removeAt(random.nextInt(imageUrls.length));
    return img;
  }

}