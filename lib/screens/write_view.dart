import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class WriteNFCView extends StatefulWidget {
  const WriteNFCView({Key? key}) : super(key: key);

  @override
  State<WriteNFCView> createState() => _WriteNFCViewState();
}

class _WriteNFCViewState extends State<WriteNFCView> {
  ValueNotifier<dynamic> result = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NfcManager Plugin Example')),
      body: SafeArea(
        child: FutureBuilder<bool>(
          future: NfcManager.instance.isAvailable(),
          builder: (context, ss) => ss.data != true
              ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))
              : Flex(
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
                            builder: (context, value, _) =>
                                Text('${value ?? ''}'),
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
                              onPressed: _tagRead),
                          ElevatedButton(
                              child: const Text('Ndef Write'),
                              onPressed: _ndefWrite),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      AsciiCodec ascii = const AsciiCodec();

      List<int> payload =
          tag.data["ndef"]["cachedMessage"]["records"][0]["payload"];
      String msg = ascii.decode(
          tag.data["ndef"]["cachedMessage"]["records"][0]["payload"],
          allowInvalid: true);
      msg = (payload.length) > 16 ? msg.substring(4, 15) : msg.substring(3);
      //result.value = "${payload.length}\n";
      result.value = msg;

      NfcManager.instance.stopSession();
    });
    // NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
    //   result.value = tag.data;

    //   NfcManager.instance.stopSession();
    // });
  }

  void _ndefWrite() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result.value = 'Tag is not ndef writable';
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }

      //AsciiCodec ascii = const AsciiCodec();

      NdefMessage message = NdefMessage([
        NdefRecord.createText("1003050299"),
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
}
