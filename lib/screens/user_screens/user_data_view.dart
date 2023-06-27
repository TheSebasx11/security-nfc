import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:security_test/components/index.dart';
import 'package:security_test/providers/user_service.dart';
import 'package:security_test/shared/data_example.dart';

import '../../providers/nfc_service.dart';

class UserDataView extends StatelessWidget {
  UserDataView({Key? key}) : super(key: key);

  late List<TextEditingController> _txtControllers;

  @override
  Widget build(BuildContext context) {
    NFCServices nfcService = Provider.of(context);
    UserServices userServices = Provider.of(context);
    _txtControllers = [
      for (int i = 0; i < userServices.person!.toJson().length; i++)
        TextEditingController()
    ];
    log("${generalInfomationData(nfcService.dniTest).entries.toList()[4].value[0].runtimeType}");
    int j = -1;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
            children: userServices.person!.toJson().entries.toList().map((e) {
          j++;
          _txtControllers[j].text = "${e.value == "null" ? "" : e.value}";
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
                : title == "Fecha de Nacimiento"
                    ? TextInputType.datetime
                    : TextInputType.text,
          )
        ],
      ),
    );
  }
}
