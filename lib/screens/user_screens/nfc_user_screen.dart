import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/nfc_service.dart';


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
  int cont = 0, cont2 = 0;

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
  }

  ValueNotifier<dynamic> result = ValueNotifier(null);
  String hash = "";


  void secuencia(Function() fun) async {
    Future.delayed(
      const Duration(seconds: 2),
      fun,
    );
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
              secuencia(() async {
                hash = await nfcServices.addNFC("Sebastian Ricardo");
                tData = true;
                setThisState(() {});
                secuencia(() {
                  Navigator.pop(_context);
                });
                //String code = await nfcServices.sendUIDAndHash(result.value, hash) ?? "";
                //writeOnNFC(code);
              });
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
                        nfcServices.addNFC("Sebas");
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
          const CircularProgressIndicator.adaptive(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    NFCServices nfcService = context.watch<NFCServices>();

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
                    itemCount: nfcService.nfcs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: const Text(
                            "NFC ID"), // Text(nfcService.nfcs[index].NFCID),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(nfcService.nfcs[index].owner),
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
        onPressed: 1 == 1
            ? () {
                //nfcService.getHash();
                nfcService.createNBlocks(1000);
              }
            : () {
                //showCreateNFC(context, nfcService);
                showNFCRead(context);
                // cont++;
                // nfcService.addNFC(
                //   "sebabalcar18@gmail.com",
                // );
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
                nfcService.addNFC(controller2.text);
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
