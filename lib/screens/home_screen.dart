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

  @override
  void dispose() {
    super.dispose();
    Controller1.dispose();
    Controller2.dispose();
    Controller3.dispose();
  }

  
   ValueNotifier<dynamic> result = ValueNotifier(null);
   
    void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      NfcManager.instance.stopSession();
    });
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
                    title: Text(nfcService.nfcs[index].NFCID),
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
          showDialog(
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
        },
      ),
    );
  }
}
