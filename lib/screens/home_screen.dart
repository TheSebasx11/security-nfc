import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../providers/nfc_service.dart';
import '../providers/nfc_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController Controller1 = TextEditingController();
  final TextEditingController Controller2 = TextEditingController();
  final TextEditingController Controller3 = TextEditingController();
  bool tData = false;
  @override
  void dispose() {
    super.dispose();
    Controller1.dispose();
    Controller2.dispose();
    Controller3.dispose();
  }

  ValueNotifier<dynamic> result = ValueNotifier(null);

  void _tagRead(void Function(void Function()) setThisState) {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      AsciiCodec ascii = const AsciiCodec();
      String msg = ascii.decode(
          tag.data["ndef"]["cachedMessage"]["records"][0]["payload"],
          allowInvalid: true);
      msg = msg.substring(3);
      //result.value = "${Payload.length}\n";
      msg = tag.data["nfca"]["identifier"].toString();
      result.value = msg.substring(1, msg.length - 1);
      setThisState(
        () {
          tData = true;
        },
      );
      log("${result.value}");
      NfcManager.instance.stopSession();
    });
  }

  showNFCRead(BuildContext context) {
    NFCServices nfcServices = Provider.of(context, listen: false);
    result.value = "No hay lectura";
    tData = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (_context, setThisState) {
              _tagRead(setThisState);
              return SizedBox(
                height: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (tData)
                      Text(
                        "¿Desea escribir esta información?",
                      ),
                    ValueListenableBuilder(
                      valueListenable: result,
                      builder: (context, value, _) {
                        return Center(
                          child: Text("${value}",
                              style: const TextStyle(fontSize: 16)),
                        );
                      },
                    ),
                    if (tData) ...[
                      Text("Owner: Sebas"),
                      Text("OwnerID: 123"),
                    ]
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(_context);
                setState(() {
                  tData = false;
                });
              },
              child: Text(
                "Cerrar",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
                onPressed: () {
                  if (tData) {
                    nfcServices.addNote("${result.value}", "Sebas", "123");
                    Navigator.pop(_context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Debes leer tu NFC")));
                  }
                },
                child: const Text("Aceptar")),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    NFCServices nfcService = context.watch<NFCServices>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your NFC cards'),
      ),
      body: nfcService.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {},
              child: ListView.builder(
                itemCount: nfcService.nfcs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title:
                        Text("NFC ID"), // Text(nfcService.nfcs[index].NFCID),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(nfcService.nfcs[index].owner),
                        Text(nfcService.nfcs[index].ownerDNI)
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        nfcService.deleteNote(nfcService.nfcs[index].id);
                      },
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          //showCreateNFC(context, nfcService);
          showNFCRead(context);
        },
      ),
    );
  }

  Future<dynamic> showCreateNFC(BuildContext context, NFCServices nfcService) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New NFC'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: Controller1,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter NFC ID',
                ),
              ),
              TextField(
                controller: Controller2,
                decoration: const InputDecoration(
                  hintText: "Enter Owner's name",
                ),
              ),
              TextField(
                controller: Controller3,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Enter Onwer's DNI",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                nfcService.addNote(
                    Controller1.text, Controller2.text, Controller3.text);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
