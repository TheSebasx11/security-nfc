import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../providers/nfc_service.dart';

import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final TextEditingController controller3 = TextEditingController();
  bool tData = false;
  int cont = 0;
  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
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
    //result.value = "No hay lectura";
    result.value = "ID unico del NFC";
    //tData = false;
    tData = true;
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
                    if (tData) ...[
                      const Text(
                        "¿Desea escribir esta información?",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                      const SizedBox(height: 10)
                    ],
                    ValueListenableBuilder(
                      valueListenable: result,
                      builder: (context, value, _) {
                        return Center(
                          child: Text("$value",
                              style: TextStyle(
                                  fontSize: tData ? 18 : 22,
                                  fontWeight: tData
                                      ? FontWeight.normal
                                      : FontWeight.bold)),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    if (tData) ...[
                      RichText(
                          text: const TextSpan(children: [
                        TextSpan(
                          text: "Owner: ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "Sebas",
                          style: TextStyle(fontSize: 18),
                        )
                      ])),
                      /* Text(
                        "Owner: Sebas",
                        style: TextStyle(fontSize: 18),
                      ), */
                      const SizedBox(height: 10),
                      RichText(
                          text: const TextSpan(children: [
                        TextSpan(
                          text: "OwnerID: ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "***",
                          style: TextStyle(fontSize: 18),
                        )
                      ])),
                      /* Text(
                        "OwnerID: 123",
                        style: TextStyle(fontSize: 18),
                      ), */
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
              child: const Text(
                "Cerrar",
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
            TextButton(
                onPressed: () {
                  if (tData) {
                    //nfcServices.addNFC("${result.value}", "Sebas", "123");
                    nfcServices.addNFC("1", "Sebas", "123");
                    log("Escrito");
                    Navigator.pop(_context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Debes leer tu NFC")));
                  }
                },
                child: Text("Aceptar",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18))),
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
        title: GestureDetector(
          onTap: () async {
            if (cont == 10) {
              var url = "https://www.youtube.com/watch?v=gN5hj3vXMX8";

              await launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,

                //universalLinksOnly: true,
              );
              cont = 0;
            }
            cont++;
            log("a $cont");
          },
          child: const Text('Your NFC cards'),
        ),
      ),
      body: nfcService.isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : nfcService.nfcs.isEmpty
              ? const Center(
                  child: Text(
                    "No hay ningun NFC registrado en la Blockchain :(",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await nfcService.fetchNFCs(true);
                  },
                  child: ListView.builder(
                    itemCount: nfcService.nfcs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: const Text(
                            "NFC ID"), // Text(nfcService.nfcs[index].NFCID),
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
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
        onPressed: () {
          //showCreateNFC(context, nfcService);
          //showNFCRead(context);
          nfcService.addNFC("NFCID", "Owner", "OwnerID");
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
                controller: controller1,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter NFC ID',
                ),
              ),
              TextField(
                controller: controller2,
                decoration: const InputDecoration(
                  hintText: "Enter Owner's name",
                ),
              ),
              TextField(
                controller: controller3,
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
                nfcService.addNFC(
                    controller1.text, controller2.text, controller3.text);
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
