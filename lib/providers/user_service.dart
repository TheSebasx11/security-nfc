import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../src/endpoint.dart';
import '../shared/role_enum.dart';
import '../models/models.dart';

class UserServices with ChangeNotifier {
  String token = "";
  String error = "";
  String userID = "";
  late Person? person;
  Role userRole = Role.norol;

  Future<void> loginUser(String user, String password,
      [bool saveToken = false]) async {
    var response = await http.post(
      Uri.parse(getLoginRoute()),
      body: {
        "email": user,
        "password": password,
      },
      headers: {
        //"Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer token",
      },
    );

    if (response.statusCode == 201) {
      Map decodedResponse = jsonDecode(response.body);
      token = decodedResponse["token"];
      userRole =
          Role.values.byName(decodedResponse["user"]["role"].toLowerCase());
      userID = "${decodedResponse["user"]["id"]}";

      if (saveToken) {
        await saveMapToLocalStorage("credentials", {
          "token": token,
          "rol": userRole.name,
          "userID": userID,
        });
      }
      await getMyData();

      error = "";
    } else {
      error = "${jsonDecode(response.body)["message"]}";
      log(error);
    }
  }

  Future getMyData() async {
    log(getPersonDataRoute(id: userID));
    var response =
        await http.get(Uri.parse(getPersonDataRoute(id: userID)), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });

    person = personFromJson(response.body);

    notifyListeners();
  }

  Future registerPerson(
      {required String name,
      required String dni,
      required String email,
      required String password}) async {
    var response = await http.post(
      Uri.parse(getRegisterRoute()),
      body: {
        "name": name,
        "dni": dni,
        "password": password,
        "email": email,
      },
      headers: {
        //"Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer token",
      },
    );
    log(response.body);
    await loginUser(email, password);
  }

  Future<void> saveStringToLocalStorage(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String> getStringFromLocalStorage(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    return value ??
        ''; // Si no se encuentra el valor, devuelve una cadena vacía
  }

  Future<void> removeKeyFromLocalStorage(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<void> saveMapToLocalStorage(
      String key, Map<String, dynamic> map) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(map);
    await prefs.setString(key, jsonString);
  }

  Future<Map<String, dynamic>> getMapFromLocalStorage(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(key);
    if (jsonString != null) {
      Map<String, dynamic> map = jsonDecode(jsonString);
      return map;
    } else {
      return {};
    }
  }

  Future signOut() async {
    error = "";
    token = "";
    person = null;
    userID = "";
    userRole = Role.norol;
    await removeKeyFromLocalStorage("credentials");
  }
}
