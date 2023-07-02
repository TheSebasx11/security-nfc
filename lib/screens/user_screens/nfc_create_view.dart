import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';

import '../../providers/services.dart';

class CreateNFCView extends StatefulWidget {
  final String nfcName;
  const CreateNFCView({Key? key, required this.nfcName}) : super(key: key);

  @override
  State<CreateNFCView> createState() => _CreateNFCViewState();
}

class _CreateNFCViewState extends State<CreateNFCView> {
  late UserServices userServices;
  late NFCServices nfcService;
  ValueNotifier<String> result = ValueNotifier("");
  String hash = "";

  bool tData = false;
  bool register = false;
  bool finish = false;
  int stage = 1;

  int _start = 3;
  late Timer _timer;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancelar el temporizador cuando se destruya el widget
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userServices = Provider.of(context, listen: false);
    nfcService = Provider.of(context, listen: false);
  }

  Future _tagRead(BuildContext context) async {
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
      setState(() {
        tData = true;
      });
      log("uid ${result.value}");
      await NfcManager.instance.stopSession();
      log("close session");
      // rebuildAllChildren(context);
      await registerNFC(context);
    });
  }

  Future registerNFC(BuildContext context) async {
    log("Registrar NFC");
    await nfcService.registerNFC(
        token: userServices.token,
        userID: userServices.userID,
        nfc_uid: result.value,
        title: widget.nfcName);
    setState(() {
      register = true;
    });
    await _tagWriting(context);
    //  rebuildAllChildren(context);
  }

  Future _tagWriting(BuildContext context) async {
    log("will write");
    await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        log('Tag is not ndef writable');
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }
      log("startSession");
      AsciiCodec asciiCodec = const AsciiCodec();
      var bytes = asciiCodec.encode(nfcService.tokenFromDatabase);

      NdefMessage message = NdefMessage([
        NdefRecord.createText("aya que sabor"),
      ]);
      log("startSession222, ${bytes.length}");
      try {
        log("entra al try, ");

        await ndef.write(message);
        log('Success to "Ndef Write"');
        finish = true;
        setState(() {});
        //rebuildAllChildren(context);
        NfcManager.instance.stopSession();
      } catch (e) {
        log("entra al catch, ${e.toString()} ");
        result.value = e.toString();
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
    log("ya escribió");
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

  // void rebuildAllChildren(BuildContext context) {
  //   void rebuild(Element el) {
  //     el.markNeedsBuild();
  //     el.visitChildren(rebuild);
  //   }

  //   (context as Element).visitChildren(rebuild);
  // }

  void refresh(BuildContext context) {
    if (stage == 1 && !tData) {
      Future.delayed(Duration.zero, () async {
        await _tagRead(context);
      });
    }
    if (stage == 2 && !register) {
      Future.delayed(Duration.zero, () async {
        await registerNFC(context);
      });
    }

    if (stage == 3 && !finish) {
      Future.delayed(Duration.zero, () async {
        await _tagWriting(context);
      });
    }

    if (tData) {
      setState(() {
        stage = 2;
      });
      log("if tData");
    }

    if (register) {
      log("if register");

      setState(() {
        stage = 3;
      });
    }

    if (finish) {
      log("if finish");

      setState(() {
        stage = 4;
      });
    }

    if (stage == 4) {
      startTimer();
    }

    if (_start == 0) {
      log("Navigator.of(context).pop(); ");
      Navigator.of(context).pop();
      _start = -1; // Cerrar la vista cuando llegue a 0
    }
  }

  @override
  Widget build(BuildContext context) {
    log("tdata $tData, register $register, finish $finish, stage $stage");
    refresh(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Creation'),
      ),
      body: SafeArea(
        child: Center(
            child: [
          Text(widget.nfcName),
          loadingMessage("Acerca el NFC para leerlo y registrar :)", context),
          loadingMessage(
              "Espera mientras registramos en la blockchain ;)", context),
          loadingMessage(
              "Ahora acerca el NFC para escribirle la información", context),
          Text(
              "NFC registrado! Enhorabuena \n Cerraremos esta pestaña en: $_start")
        ][stage]),
      ),
    );
  }
}
