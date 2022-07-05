import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/note_services.dart';
import '../providers/note_services.dart';

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

  @override
  Widget build(BuildContext context) {
    var NFCService = context.watch<NFCServices>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: NFCService.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {},
              child: ListView.builder(
                itemCount: NFCService.nfcs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(NFCService.nfcs[index].NFCID),
                    subtitle: Column(
                      children: [
                        Text(NFCService.nfcs[index].owner),
                        Text(NFCService.nfcs[index].ownerDNI)
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        NFCService.deleteNote(NFCService.nfcs[index].id);
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
                      decoration: const InputDecoration(
                        hintText: "Enter Onwer's DNI",
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      NFCService.addNote(
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
