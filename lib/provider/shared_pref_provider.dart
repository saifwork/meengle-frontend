import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../data/models/UserModel.dart';

class SharedPrefProvider with ChangeNotifier {
  String userKey = "User";

  UserModel userModel = UserModel();

  UserModel get getUserModel => userModel;

  Future none() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.getString(userKey) != null) {
      final dynamic user = sp.getString(userKey);
      userModel = UserModel.fromJson(jsonDecode(user));
    } else {
      var uuid = const Uuid();
      String userId = uuid.v4();
      UserModel user = UserModel(userId: userId);
      String json = jsonEncode(user);
      sp.setString(userKey, json);
      userModel = user;
    }
    notifyListeners();
  }

  Future getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the userId from SharedPreferences
    String? userId = prefs.getString(userKey);

    if (userId == null) {
      // If no userId exists in sessionStorage, generate a new one
      var uuid = const Uuid();
      String userId = uuid.v4();

      await prefs.setString(userKey, userId);

      // Use the new userId
      userModel = UserModel(userId: userId);
    } else {
      String userId = Uuid().v4();
      // Use the existing userId from sessionStorage
      userModel = UserModel(userId: userId);
    }
    notifyListeners();
  }

  Future<bool> logout() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove(userKey);
    return true;
  }
}
