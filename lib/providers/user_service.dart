import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../src/endpoint.dart';
import '../shared/role_enum.dart';

class UserServices with ChangeNotifier {
  String token = "";
  String error = "";
  late Role userRole;

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

    if (response.statusCode == 201) {
      Map decodedResponse = jsonDecode(response.body);
      token = decodedResponse["token"];
      userRole =
          Role.values.byName(decodedResponse["user"]["role"].toLowerCase());

      log("${decodedResponse["token"]}, ${userRole.name}");
      error = "";
    } else {
      error = "${response.reasonPhrase}";
      log(error);
    }
  }
}
