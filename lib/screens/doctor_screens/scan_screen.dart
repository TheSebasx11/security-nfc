import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/services.dart';

import '../screens.dart';

class ScanNFCScreen extends StatefulWidget {
  const ScanNFCScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScanNFCScreenState();
}

class ScanNFCScreenState extends State<ScanNFCScreen> {
  late UserServices userServices;
  late NFCServices nfcServices;

  ValueNotifier<dynamic> result = ValueNotifier(null);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userServices = Provider.of(context, listen: false);
    nfcServices = Provider.of(context, listen: false);
  }

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
              "Escanea tu NFC presionando el botón de abajo",
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
  }

  void navigate(int id, BuildContext context) async {
    showLoaderDialog(context, "Cargando");
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
    showLoaderDialog(context, "Escanea tu NFC...");

    Map data = {
      "nfc_payload": 6,
      "nfc_uid": "4, 78, 160, 66, 182, 40, 128",
    };
    await userServices.getUserInfoByLecture(data: data);

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DoctorReadScreen()));

    // await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
    //   AsciiCodec ascii = const AsciiCodec();
    //   result.value = "";
    //   Map data = {};
    //   String uid = "", payload = "";
    //   uid = tag.data["nfca"]["identifier"].toString();
    //   payload = ascii
    //       .decode(tag.data["ndef"]["cachedMessage"]["records"][0]["payload"]);
    //   payload = payload.substring(3);
    //   int payloadInt = int.parse(payload.trim());
    //   log("payload $payloadInt");
    //   uid = uid.substring(1, uid.length - 1);
    //   //log("uid ${result.value}");
    //   data = {
    //     "nfc_payload": payloadInt,
    //     "nfc_uid": uid,
    //   };
    //   log("data $data");
    //   await userServices.getUserInfoByLecture(data: data);

    //   await NfcManager.instance.stopSession();

    //   Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (context) => const DoctorReadScreen()));

    //   // rebuildAllChildren(context);
    // });
  }

  // void _unlock() {
  //   NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
  //     var ndef = Ndef.from(tag);
  //     if (ndef == null || ndef.isWritable) {
  //       result.value = 'Tag is not ndef writable';
  //       NfcManager.instance.stopSession(errorMessage: result.value);
  //       return;
  //     }

  //     try {
  //       //await ndef.Unlock();
  //       NdefFormatable.from(tag)
  //           ?.format(NdefMessage([NdefRecord.createText("Hola Fabian")]));
  //       result.value = 'Success to "Ndef Unlock"';
  //       NfcManager.instance.stopSession();
  //     } catch (e) {
  //       result.value = e;
  //       NfcManager.instance.stopSession(errorMessage: result.value.toString());
  //       return;
  //     }
  //   });
  // }

  // void _ndefWrite() {
  //   NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
  //     var ndef = Ndef.from(tag);
  //     if (ndef == null || ndef.isWritable) {
  //       result.value = 'Tag is not ndef writable';
  //       NfcManager.instance.stopSession(errorMessage: result.value);
  //       return;
  //     }

  //     //AsciiCodec ascii = const AsciiCodec();

  //     NdefMessage message = NdefMessage([
  //       NdefRecord.createText("1005683926"),
  //     ]);

  //     try {
  //       await ndef.write(message);
  //       result.value = 'Success to "Ndef Write"';
  //       NfcManager.instance.stopSession();
  //     } catch (e) {
  //       result.value = e;
  //       NfcManager.instance.stopSession(errorMessage: result.value.toString());
  //       return;
  //     }
  //   });
  // }
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
