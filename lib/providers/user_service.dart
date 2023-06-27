import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
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

  Future<void> loginUser(String user, String password) async {
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
    log(response.body);
    if (response.statusCode == 201) {
      Map decodedResponse = jsonDecode(response.body);
      token = decodedResponse["token"];
      userRole =
          Role.values.byName(decodedResponse["user"]["role"].toLowerCase());
      userID = "${decodedResponse["user"]["id"]}";
      await getMyData();
      log("${decodedResponse["token"]}, ${userRole.name}");
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
    log(response.body);
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

  Future signOut() async {
    error = "";
    token = "";
    person = null;
    userID = "";
    userRole = Role.norol;
  }
}
