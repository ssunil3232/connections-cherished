import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';

const uri =
    'mongodb+srv://cherished-connect:connect@cluster0.ad6rqsq.mongodb.net/users?retryWrites=true&w=majority&appName=Cluster0';

class MongoDB {
  // ignore: prefer_typing_uninitialized_variables
  static var db, connections;
  static connect() async {
    db = await Db.create(uri);
    await db.open();
    // ignore: avoid_print
    connections = db.collection('sample');
  }

  static Future<List<Map<String, dynamic>>> getDocuments() async {
    try {
      final users = await connections.find().toList();
      return users;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return Future.value(e as FutureOr<List<Map<String, dynamic>>>?);
    }
  }

  static update(Map<String, dynamic> user) async {
    var filter = {"_id": user['_id']};
    var updateDoc = {"\$set": user};

    try {
      await connections.updateOne(filter, updateDoc, upsert: true);
      return true;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return false;
    }
  }

  static insert(Map<String, dynamic> user) async {
    var userInsert = {"_id": ObjectId(), ...user};
    try {
      await connections.insertOne(userInsert);
      return true;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return false;
    }
  }

  static delete(ObjectId id) async {
    try {
      await connections.remove(where.id(id));
      return true;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return false;
    }
  }
}
