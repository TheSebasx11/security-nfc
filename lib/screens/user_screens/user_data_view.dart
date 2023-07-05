import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:security_test/components/index.dart';
import 'package:security_test/providers/user_service.dart';

class UserDataView extends StatefulWidget {
  const UserDataView({Key? key}) : super(key: key);

  @override
  State<UserDataView> createState() => _UserDataViewState();
}

class _UserDataViewState extends State<UserDataView> {
  DateTime? bornDay;
  late UserServices userServices;
  late Map<String, TextEditingController> _txtControllers;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userServices = Provider.of(context);
  }

  void patchUserPetition(UserServices userServices) async {
    Map texts = {
      "name": "string",
      "lastname": "string",
      "phone": "string",
      "ocupation": "string",
      "sex": "M",
      "marital_status": "S",
      "address": "string",
      "blood_type": "string",
      "height": "string",
      "religion": "string",
      "education": "string",
      "sisben": "string",
      "estrato": "string",
      "birthday": "2023-07-03T19:06:37.879Z",
    };
    int i = -1;
    texts = texts.map((key, val) {
      i++;
      var value = _txtControllers.values.toList()[i].text;

      return MapEntry(key, value);
    });

    userServices.userData = texts;

    // for (var key in userServices.person!.toJson().keys) {
    //   texts[key] = _txtControllers.asMap()[key]!.value.text;
    // }

    // userServices.userData = texts;
    // log("${userServices.userData}");
  }

  @override
  Widget build(BuildContext context) {
    // NFCServices nfcService = Provider.of(context);

    _txtControllers = userServices.person!
        .toJson()
        .map((key, value) => MapEntry(key, TextEditingController()));

    //int j = -1;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(children: [
          ...userServices.person!.toJson().entries.toList().map((e) {
            //      j++;
            _txtControllers[e.key]!.text =
                "${e.value == "null" ? "" : e.value}";
            return customInputTitleField(
                title: e.key,
                textEditingController: _txtControllers[e.key]!,
                numberType: e.value[0].runtimeType == int);
          }).toList()
        ]
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
            onTap: title == "Fecha de Nacimiento"
                ? () async {
                    bornDay = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000, 12),
                      firstDate: DateTime(1970, 1),
                      lastDate: DateTime(2004, 12),
                      helpText: 'Selecciona un dia',
                    );

                    if (bornDay != null) {
                      textEditingController.text =
                          "${bornDay!.year}-${bornDay!.month}-${bornDay!.day}";
                    }
                  }
                : null,
            readOnly: title == "Fecha de Nacimiento",
            onChanged: (p0) {
              patchUserPetition(userServices);
            },
          )
        ],
      ),
    );
  }
}
