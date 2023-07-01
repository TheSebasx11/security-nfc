import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:security_test/providers/user_service.dart';
import 'package:security_test/screens/user_screens/nfc_create_view.dart';
import '../../models/models.dart';
import '../../providers/nfc_service.dart';
import '../../components/index.dart';

//import 'package:url_launcher/url_launcher.dart';

class NFCHomeScreen extends StatefulWidget {
  const NFCHomeScreen({Key? key}) : super(key: key);

  @override
  State<NFCHomeScreen> createState() => _NFCHomeScreenState();
}

class _NFCHomeScreenState extends State<NFCHomeScreen> {
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final TextEditingController controller3 = TextEditingController();
  bool tData = false;
  bool register = false;
  bool finish = false;
  int cont = 0, cont2 = 0;
  int stage = 0;
  late UserServices userServices;
  late NFCServices nfcService;
  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userServices = Provider.of(context, listen: false);
    nfcService = context.watch<NFCServices>();
  }

  ValueNotifier<String> result = ValueNotifier("");
  String hash = "";

  void _tagRead(void Function(void Function()) stateChanger) async {
    await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      //AsciiCodec ascii = const AsciiCodec();
      result.value = "";
      String msg = """ascii.decode(
          tag.data["ndef"]["cachedMessage"]["records"][0]["payload"],
          allowInvalid: true)""";
      // msg = msg.substring(3);
      //result.value = "${Payload.length}\n";
      msg = tag.data["nfca"]["identifier"].toString();

      result.value = msg.substring(1, msg.length - 1);
      stateChanger(() {
        tData = true;
      });
      log("uid ${result.value}");
      await NfcManager.instance.stopSession();
      log("close session");
    });
  }

  void registerNFC(void Function(void Function()) stateChanger) async {
    log("Registrar NFC");
    await nfcService.registerNFC(
        token: userServices.token,
        userID: userServices.userID,
        nfc_uid: result.value,
        title: controller1.text);

    stateChanger(() {
      register = true;
    });
  }

  void _tagWriting(void Function(void Function()) stateChanger) async {
    log("will write");
    await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        log('Tag is not ndef writable');
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }

      //AsciiCodec ascii = const AsciiCodec();

      NdefMessage message = NdefMessage([
        NdefRecord.createText(
            "aya que saboraya que saboraya que saboraya que saboraya que saboraya que saboraya que saboraya que saboraya que sabor "),
      ]);

      try {
        await ndef.write(message);
        log('Success to "Ndef Write"');

        stateChanger(() {
          finish = true;
        });
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e.toString();
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
    log("ya escribió");
  }

  showNFCRead(BuildContext context) {
    NFCServices nfcServices = Provider.of(context, listen: false);
    //result.value = "No hay lectura";
    result.value = "[4, 78, 160, 66, 182, 40, 128]";
    tData = false;
    //tData = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (_context, setThisState) {
              //  _tagRead(setThisState);

              return loadingMessage(
                  tData
                      ? "Espera mientras creamos el bloque"
                      : 'Escanea el NFC para crearlo en la blockchain',
                  context);
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
                onPressed: tData
                    ? () {
                        //nfcServices.addNFC("${result.value}", "Sebas", "123");
                        nfcServices.addNFC("Sebas", controller1.text);
                        log("Escrito");
                        Navigator.pop(_context);
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Debes leer tu NFC")));
                      },
                child: Text("Aceptar",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18))),
          ],
        );
      },
    );
  }

  Widget loadingMessage(String msg, context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      child: Column(
        children: [
          Text(msg),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          const CircularProgressIndicator.adaptive(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names

    return Scaffold(
      body: nfcService.isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : nfcService.nfcs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "No hay ningun NFC registrado en la Blockchain :(",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                      ),
                      ElevatedButton(
                          onPressed: () => nfcService.fetchNFCs(),
                          child: const Text('Recharge'))
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await nfcService.fetchNFCs(true);
                  },
                  child: ListView.builder(
                    itemCount:
                        nfcService.filteredNFCbyID(userServices.userID).length,
                    itemBuilder: (context, index) {
                      NFC nfc = nfcService
                          .filteredNFCbyID(userServices.userID)[index];
                      return ListTile(
                        title: Text(
                            nfc.title), // Text(nfcService.nfcs[index].NFCID),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(nfc.owner),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            nfcService.deleteNote(nfc.id);
                          },
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () {
              stage = 0;
              finish = false;
              tData = false;
              register = false;
              _tagWriting((p0) {});
            },
            child: const Icon(Icons.delete),
            backgroundColor: Colors.red,
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "btn2",
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.add),
            onPressed: () {
              showCreateNFC(context);
              //_tagRead((p0) {});
              // nfcService.addNFC(userServices.userID, "Titulo");

              // nfcService.registerNFC(
              //     token: userServices.token,
              //     userID: userServices.userID,
              //     nfc_uid: "1");
            },
          ),
        ],
      ),
    );
  }

  // var list = [
  //   customAlertDialog(
  //     title: "Ingresa el nombre de tu NFC para reconocerlo",
  //     children: [
  //       CustomInputField(
  //         controller: controller1,
  //         keyboardType: TextInputType.name,
  //         labelText: "Ingresa el nombre de tu NFC",
  //         errorText: error,
  //       ),
  //     ],
  //     actions: [
  //       TextButton(
  //         onPressed: () {
  //           if (controller1.text.isEmpty) {
  //             error = "Llena el campo";
  //           } else if (controller1.text.length < 4) {
  //             error = "Nombre muy corto";
  //           } else {
  //             error = null;
  //           }
  //           stage = 1;
  //           stateChanger(() {});
  //         },
  //         child: const Text('Ok'),
  //       ),
  //     ],
  //   ),
  //   AlertDialog(
  //       content: loadingMessage("Acerca el NFC para registrarlo", context)),
  // ][stage];

  Widget customAlertDialog({
    required String title,
    required List<Widget> children,
    required List<Widget> actions,
  }) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
      actions: actions,
    );
  }

  Future<dynamic> showCreateNFC(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        String? error;

        return StatefulBuilder(
          builder: (_, stateChanger) {
            // log("tdata $tData, register $register, finish $finish, stage $stage");
            // if (stage == 1 && !tData) {
            //   _tagRead(stateChanger);
            // }
            // if (stage == 2 && !register) {
            //   registerNFC(stateChanger);
            // }

            // if (stage == 3 && !finish) {
            //   _tagWriting(stateChanger);
            // }

            // if (tData) {
            //   stage = 2;
            //   stateChanger(() {});
            //   log("if tData");
            // }

            // if (register) {
            //   log("if register");
            //   stage = 3;
            //   stateChanger(() {});
            // }

            // if (finish) {
            //   log("if finish");
            //   stage = 4;
            //   stateChanger(() {});
            // }

            return customAlertDialog(
              title: "Ingresa el nombre de tu NFC para reconocerlo",
              children: [
                CustomInputField(
                  controller: controller1,
                  keyboardType: TextInputType.name,
                  labelText: "Ingresa el nombre de tu NFC",
                  errorText: error,
                ),
              ],
              actions: [
                TextButton(
                  onPressed: () {
                    if (controller1.text.isEmpty) {
                      error = "Llena el campo";
                    } else if (controller1.text.length < 4) {
                      error = "Nombre muy corto";
                    } else {
                      error = null;
                      Navigator.pop(_);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateNFCView(nfcName: controller1.text)),
                      );
                    }

                    stateChanger(() {});
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
            // AlertDialog(
            //     content: loadingMessage("Acerca el NFC para registrarlo", _)),
            // AlertDialog(
            //   content: loadingMessage("Espera mientras registramos", _),
            // ),
            // AlertDialog(
            //   content: loadingMessage("Acerca el NFC para escribir", _),
            // ),
            // customAlertDialog(title: "Enhorabuena! 🐴", children: [
            //   const Text('Escribimos ya un NFC, ahora es tuyo')
            // ], actions: [
            //   ElevatedButton(
            //       child: const Text('Terminar'),
            //       onPressed: () {
            //         Navigator.pop(_);
            //       })
            // ])
          },
        );
        // return AlertDialog(
        //   title: const Text('Ingresa el nombre de tu NFC para reconocerlo'),
        //   content: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       CustomInputField(
        //         controller: controller1,
        //         keyboardType: TextInputType.name,
        //         labelText: "Ingresa el nombre de tu NFC",
        //         errorText: error,
        //       ),
        //       // TextField(
        //       //   controller: controller1,
        //       //   keyboardType: TextInputType.number,
        //       //   decoration: const InputDecoration(
        //       //     hintText: 'Enter NFC ID',
        //       //   ),
        //       // ),
        //     ],
        //   ),
        //   actions: [
        //     TextButton(
        //       onPressed: () {
        //         if (controller1.text.isEmpty) {
        //           error = "Llena el campo";
        //         } else if (controller1.text.length < 4) {
        //           error = "Nombre muy corto";
        //         } else {
        //           error = null;
        //         }
        //         stage = 2;
        //         stateChanger(() {});
        //       },
        //       child: const Text('Ok'),
        //     ),
        //   ],
        // );
      },
    );
  }
}
