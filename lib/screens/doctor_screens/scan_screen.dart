import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';
import 'package:security_test/providers/nfc_service.dart';

import '../screens.dart';

class ScanNFCScreen extends StatefulWidget {
  const ScanNFCScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScanNFCScreenState();
}

class ScanNFCScreenState extends State<ScanNFCScreen> {
  ValueNotifier<dynamic> result = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    //const String generalID = "1005683926";
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Escanea tu NFC para registrar la asistencia",
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge!
                  .copyWith(fontFamily: "EspecialFont"),
            ),
            CircleWaveRoute(
              child: ElevatedButton(
                style: ButtonStyle(
                    fixedSize: const MaterialStatePropertyAll(Size(120, 120)),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(500),
                    ))),
                onPressed: () async => _tagRead(context),
                child: const Text(
                  "NFC",
                  style: TextStyle(fontSize: 20, fontFamily: "EspecialFont"),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    /*Scaffold(
      appBar: AppBar(title: const Text('Read NFC')),
      body: SafeArea(
        child: FutureBuilder<bool>(
          future: NfcManager.instance.isAvailable(),
          builder: (context, ss) {
            //if (ss.data == true) {
            Future.delayed(Duration.zero, () async {
              // _tagRead(context);
              //  Navigate(int.parse(generalID), context);
            });
            return Center(
              child: ElevatedButton(
                onPressed: () => _tagRead(context),
                child: const Text(
                  "Elevated Button",
                ),
              ),
            ); /* Flex(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              direction: Axis.vertical,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    constraints: const BoxConstraints.expand(),
                    decoration: BoxDecoration(border: Border.all()),
                    child: SingleChildScrollView(
                      child: ValueListenableBuilder<dynamic>(
                        valueListenable: result,
                        builder: (context, value, _) {
                          return Text('${value ?? ''}');
                        },
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: GridView.count(
                    padding: const EdgeInsets.all(4),
                    crossAxisCount: 2,
                    childAspectRatio: 4,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    children: [
                      ElevatedButton(
                          child: const Text('Tag Read'),
                          onPressed: () => _tagRead(context)),
                      /* ElevatedButton(
                          //onPressed: _ndefWrite,
                          /* onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                          user: usuario,
                                        )));
                          }*/
                          onPressed: () =>
                              Navigate(int.parse(generalID), context),
                          child: const Text("Go")),*/
                      ElevatedButton(
                          child: const Text('Write DNi'),
                          onPressed: _ndefWrite),
                      /*ElevatedButton(
                            child: const Text('Unlock NFC'),
                            onPressed: _unlock),*/
                    ],
                  ),
                ),
              ],
            ); */
            /*} else {
              return const Center(
                child: Text(
                  "NFC no está disponible",
                  style: TextStyle(fontSize: 35),
                ),
              );
            }*/
          },
        ),
      ),
    );*/
  }

  // ignore: non_constant_identifier_names
  void Navigate(int id, BuildContext context) async {
    showLoaderDialog(context, "Cargando");
    /*  Api().getUserById(id).then((value) {}).then(
      (value) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfile(
              usuario: User.getInstance(),
            ),
          ),
        );
      },
    ); */
  }

  showMessageDialog(BuildContext context, String message, Widget icon) {
    AlertDialog alert = AlertDialog(
      content: Expanded(
        child: Row(
          children: [
            // CircularProgressIndicator(color: theme.primaryColor),
            icon,
            Container(
                width: 200,
                margin: const EdgeInsets.only(left: 10),
                child: Text(
                  message,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showLoaderDialog(BuildContext context, String message) {
    ThemeData theme = Theme.of(context);
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(color: theme.primaryColor),
          Container(
              margin: const EdgeInsets.only(left: 10), child: Text(message)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _tagRead(BuildContext context) async {
    // showLoaderDialog(context, "Escanea tu NFC...");
    /*  showMessageDialog(
      context,
      "Asistencia registrada para estudiante: Sebastian Ricardo Cardenas",
      Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: theme.primaryColor),
          borderRadius: BorderRadius.circular(2000),
        ),
        child: Icon(
          Icons.done,
          color: theme.primaryColor,
          size: 20,
        ),
      ),
    ); */

    showMessageDialog(
      context,
      "El estudiante: Sebastian Ricardo Cardenas ya tiene una asistencia el dia de hoy",
      Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(2000),
        ),
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
          size: 20,
        ),
      ),
    );

    await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      AsciiCodec ascii = const AsciiCodec();

      List<int> payload =
          tag.data["ndef"]["cachedMessage"]["records"][0]["payload"];
      String msg = ascii.decode(
          tag.data["ndef"]["cachedMessage"]["records"][0]["payload"],
          allowInvalid: true);
      msg = (payload.length) > 16 ? msg.substring(4, 15) : msg.substring(3);
      //result.value = "${payload.length}\n";
      result.value = msg;

      Navigator.pop(context);

      Provider.of<NFCServices>(context, listen: false).setDni(msg);
      //log(Provider.of<NFCServices>(context, listen: false).dniTest);

      NfcManager.instance.stopSession();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const DoctorReadScreen()));
    });

    //   Future.delayed(
    //       const Duration(seconds: 3),
    //       () => Navigator.of(context).pushReplacement(
    //           MaterialPageRoute(builder: (context) => const DoctorReadScreen())));
    // }
  }

/*
  void _ndefWriteLock() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);NdefRecord.createText('1003310588'),
      if (ndef == null) {
        result.value = 'Tag is not ndef';
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }

      try {
        //await ndef.writeLock();
        result.value = 'Success to "Ndef Write Lock"';
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }*/
}
