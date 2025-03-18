import 'dart:convert';
import 'dart:math';
import 'package:connectionscherished/services/providers/profile_img_provider.dart';
import 'package:connectionscherished/widgets/profile/profile_img_name_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectionscherished/models/timezone_model.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

class UtilService {
  final _firestore = GetIt.I.get<FirebaseFirestore>();
  final FirebaseAuth _authService = FirebaseAuth.instance;
  final ProfileImgProvider _imgProvider = GetIt.instance<ProfileImgProvider>();
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

  Future<void> uploadImage(AvatarImgSelection avatar, String id) async {
    if (avatar.imgFile == null) return;
    //String fileName = path.basename(avatar.imgFile!.path);
    String fileName = path.basename(avatar.img);
    String userId = _authService.currentUser?.uid ?? '';
    try {
      await deleteAssociatedImg(id, 'associatedId');
      // Create a reference to the location you want to upload to in Firebase Storage
      final ref = firebase_storage.FirebaseStorage.instance.ref().child('assets/images/uploads/$fileName');

      final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'associatedId': id,
          'userId': userId, //user?.userId ?? '',
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      // Upload the file to Firebase Storage
      firebase_storage.TaskSnapshot snapshot = await ref.putFile(avatar.imgFile!, metadata);

      // Retrieve the download URL after successful upload
      String downloadUrl = await snapshot.ref.getDownloadURL();
      _imgProvider.updateAvatars(avatar.img, downloadUrl);

    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> deleteAssociatedImg(String id, String field) async {
    try {
      // List all files in the directory
      firebase_storage.ListResult result = await firebase_storage.FirebaseStorage.instance
          .ref('assets/images/uploads')
          .listAll();

      // Iterate through each file
      for (firebase_storage.Reference ref in result.items) {
        // Get the metadata of the file
        firebase_storage.FullMetadata metadata = await ref.getMetadata();

        // Check if the associatedID matches the friendId
        if (metadata.customMetadata != null && metadata.customMetadata![field] == id) {
          // Delete the file
          await ref.delete();
        }
      }
    } catch (e) {
      print('Error deleting files: $e');
    }
  }

  Future <Map<String, Map<String,dynamic>>> getAnalytics() async {
    List<Map<String, dynamic>> data = [
      {
        "friendId": "CIfRqrwcjXDnMscPd9sG",
        "data": [
          "2024-12-03", "2024-12-24",
          "2025-01-01", "2025-01-05",
          "2025-02-12", 
          "2025-03-02","2025-03-03","2025-03-11","2025-03-17"
        ]
      },
      {
        "friendId": "OZUTmihqy4BzUlidCllw",
        "data": [
          "2024-12-02", "2024-12-05","2024-12-12","2024-12-20","2024-12-30",
          "2025-01-12", "2025-01-22",
          "2025-02-12", "2025-02-22",
          "2025-03-02","2025-03-03","2025-03-11","2025-03-17", "2025-03-18"
        ]
      },
    ];

    Map<String, Map<String,dynamic>> result = {};

    for (int i = 0; i < data.length; i++) {
      String friendKey = data[i]['friendId'];
      List<dynamic> contactedDates = data[i]['data'];
      Map<String, dynamic> weeklyCounts = getWeeklyCounts(contactedDates);
      Map<String, dynamic> monthlyCounts = getMonthlyCounts(contactedDates);
      Map<String, dynamic> yearlyCounts = getYearlyCounts(contactedDates);;
      result[friendKey] = {"week": weeklyCounts, "month": monthlyCounts, "year": yearlyCounts};
    }
    // debugPrint("Result: ${result.toString()}");
    result = getAllCounts(result);
    return result;
  }

  getAllCounts(Map<String, Map<String,dynamic>> result){
    Map<String, dynamic> allWeeklyCounts = {};
    Map<String, dynamic> allMonthlyCounts = {};
    Map<String, dynamic> allYearlyCounts = {};

    result.forEach((key, value){
      Map<String, dynamic> weeklyCounts = value['week'];
      Map<String, dynamic> monthlyCounts = value['month'];
      Map<String, dynamic> yearlyCounts = value['year'];
      weeklyCounts.forEach((day, count) {
        if (allWeeklyCounts.containsKey(day)) {
          allWeeklyCounts[day] = allWeeklyCounts[day] + count;
        } else {
          allWeeklyCounts[day] = count;
        }
      });

      monthlyCounts.forEach((month, count) {
        if (allMonthlyCounts.containsKey(month)) {
          allMonthlyCounts[month] = allMonthlyCounts[month] + count;
        } else {
          allMonthlyCounts[month] = count;
        }
      });

      yearlyCounts.forEach((year, count) {
        if (allYearlyCounts.containsKey(year)) {
          allYearlyCounts[year] = allYearlyCounts[year] + count;
        } else {
          allYearlyCounts[year] = count;
        }
      });
    });
    result["all"] = 
      {
        "week": allWeeklyCounts,
        "month": allMonthlyCounts,
        "year": allYearlyCounts
      };
    return result;
  }

  getYearlyCounts(List<dynamic> dates){
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int startYear = currentYear - 5;

    Map<String, int> yearlyCounts = {};

    for (int year = startYear; year <= currentYear; year++) {
      yearlyCounts[year.toString()] = 0;
    }

    dates.forEach((date){
      DateTime dateTime = DateTime.parse(date);
      int year = dateTime.year;
      if (yearlyCounts.containsKey(year.toString())) {
        yearlyCounts[year.toString()] = yearlyCounts[year.toString()]! + 1;
      }
    });
    return yearlyCounts;
  }

  getMonthlyCounts(List<dynamic> dates){
    DateTime now = DateTime.now();
    DateTime startOfYear = DateTime(now.year, 1, 1);
    DateTime endOfYear = DateTime(now.year, 12, 31);

    Map<String, int> monthlyCounts = {};

    for (int i = 1; i <= 12; i++) {
      DateTime startOfMonth = DateTime(now.year, i, 1);
      String monthString = DateFormat('MMM').format(startOfMonth);
      monthlyCounts[monthString] = 0;
    }
    dates.forEach((date){
      DateTime dateTime = DateTime.parse(date);
      if (dateTime.isAfter(startOfYear.subtract(Duration(days: 1))) && dateTime.isBefore(endOfYear.add(Duration(days: 1)))) {
        String monthString = DateFormat('MMM').format(dateTime);
        if (monthlyCounts.containsKey(monthString)) {
          monthlyCounts[monthString] = monthlyCounts[monthString]! + 1;
        }
      }
    });
    return monthlyCounts;
  }

  getWeeklyCounts(List<dynamic> dates){
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    Map<String, int> weeklyCounts = {};

    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      String dayString = DateFormat('E').format(day);
      weeklyCounts[dayString] = 0;
    }

    dates.forEach((date){
      DateTime dateTime = DateTime.parse(date);
      if (dateTime.isAfter(startOfWeek.subtract(Duration(days: 1))) && dateTime.isBefore(endOfWeek.add(Duration(days: 1)))) {
        String dayString = DateFormat('E').format(dateTime);
        if (weeklyCounts.containsKey(dayString)) {
          weeklyCounts[dayString] = weeklyCounts[dayString]! + 1;
        }
      }
    });
    return weeklyCounts;
  }

}