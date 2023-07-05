import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:security_test/components/index.dart';
import 'package:security_test/providers/user_service.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  final List<TextEditingController> _list = [
    for (int i = 0; i < 2; i++) TextEditingController()
  ];

  @override
  Widget build(BuildContext context) {
    UserServices userServices = Provider.of(context, listen: false);
    Map<String, dynamic> ganacheData = {};
    userServices.getMapFromLocalStorage("ganacheData").then((value) {
      ganacheData = value;
      log("ganacheData1: $ganacheData");
      _list[0].text = ganacheData["ip"];
      _list[1].text = ganacheData["key"];
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
              onPressed: () async {
                ganacheData = {
                  "ip": _list[0].text,
                  "key": _list[1].text,
                };
                await userServices.saveMapToLocalStorage(
                    "ganacheData", ganacheData);

                log("ganacheData: $ganacheData");
              },
              icon: const Icon(Icons.done))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Column(
            children: <Widget>[
              CustomInputField(
                labelText: "Ganache ip",
                controller: _list[0],
              ),
              const SizedBox(height: 10),
              CustomInputField(
                labelText: "Ganache secret key",
                controller: _list[1],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
