import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:security_test/components/index.dart';

class UserDataView extends StatelessWidget {
  UserDataView({Key? key}) : super(key: key);

  final Map<String, List> generalInfomationData = {
    "Nombre": ["Sebastian", Icons.abc],
    "Nombre 2": ["Alfonsino", Icons.abc],
    "Apellido": ["Ricardo", Icons.abc],
    "Apellido 2": ["Cardenas", Icons.abc],
    "Cedula": [1003050222, Icons.verified_user],
    "Edad": [19, Icons.numbers],
    "Fecha de nacimiento": ["12/12/2012", Icons.date_range],
    "Altura": ["1.70m", Icons.height],
    "Peso": ["75kg", Icons.line_weight],
    "Sangre": ["A+", Icons.bloodtype],
    "Si": ["Si", Icons.bloodtype],
    "No": ["No", Icons.bloodtype],
  };

  late List<TextEditingController> _txtControllers;

  @override
  Widget build(BuildContext context) {
    _txtControllers = [
      for (int i = 0; i < generalInfomationData.length; i++)
        TextEditingController()
    ];
    log("${generalInfomationData.entries.toList()[4].value[0].runtimeType}");
    int j = -1;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
            children: generalInfomationData.entries.toList().map((e) {
          j++;
          _txtControllers[j].text = "${e.value[0]}";
          return customInputTitleField(
              title: e.key,
              textEditingController: _txtControllers[j],
              numberType: e.value[0].runtimeType == int);
        }).toList()
            //customInputTitleField(title: "Si"),

            ),
      )),
    );
  }

  Widget customInputTitleField(
      {required String title,
      required bool numberType,
      required TextEditingController textEditingController}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          CustomInputField(
            controller: textEditingController,
            keyboardType: numberType
                ? TextInputType.number
                : title == "Fecha de nacimiento"
                    ? TextInputType.datetime
                    : TextInputType.text,
          )
        ],
      ),
    );
  }
}
