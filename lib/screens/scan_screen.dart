import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

class ScanNFCScreen extends StatefulWidget {
  const ScanNFCScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScanNFCScreenState();
}

class ScanNFCScreenState extends State<ScanNFCScreen> {
  ValueNotifier<dynamic> result = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    const String generalID = "1005683926";
    final theme = Theme.of(context);
    return Scaffold(
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
    );
  }

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

  showLoaderDialog(BuildContext context, String Mensaje) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 10), child: Text(Mensaje)),
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

  void _tagRead(BuildContext context) {
    showLoaderDialog(context, "Escanea tu NFC...");
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      AsciiCodec ascii = const AsciiCodec();
      List<int> Payload =
          tag.data["ndef"]["cachedMessage"]["records"][1]["payload"];
      String msg = ascii.decode(
          tag.data["ndef"]["cachedMessage"]["records"][1]["payload"],
          allowInvalid: true);
      msg = (Payload.length) > 16 ? msg.substring(4, 15) : msg.substring(3);
      result.value = "${Payload.length}\n";
      result.value += msg;
      Navigator.pop(context);
      Navigate(int.parse(msg), context);
      NfcManager.instance.stopSession();
    });
  }

  void _unlock() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || ndef.isWritable) {
        result.value = 'Tag is not ndef writable';
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }

      try {
        //await ndef.Unlock();
        NdefFormatable.from(tag)
            ?.format(NdefMessage([NdefRecord.createText("Hola Fabian")]));
        result.value = 'Success to "Ndef Unlock"';
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }

  void _ndefWrite() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || ndef.isWritable) {
        result.value = 'Tag is not ndef writable';
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }

      AsciiCodec ascii = const AsciiCodec();

      NdefMessage message = NdefMessage([
        NdefRecord.createExternal(
            "android.com", "pkg", ascii.encode("com.example.nfc_use")),
        NdefRecord.createText("282858098"),
      ]);

      try {
        await ndef.write(message);
        result.value = 'Success to "Ndef Write"';
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
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
