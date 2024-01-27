import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class UserService extends ChangeNotifier {
  late User user;
  final String _rpcUrl = Platform.isAndroid
      ? "http://172.17.17.187:7545" /* "http://192.168.1.6:7545" */ /* "http://10.0.2.2:7545" */
      : "127.0.0.1:7545";
  final String _wsUrl = Platform.isAndroid
      ? "ws://  172.17.17.187:7545" /* "ws://192.168.1.6:7545" */ /*  "ws://10.0.2.2:7545" */
      : "ws://127.0.0.1:7545";
  late Web3Client _webclient;
  // ignore: unused_field
  late EthPrivateKey _creds;
  bool isLoading = true;
  final String _privatekey =
      "8a5426c6e4c2182bf7524044dd4644293c90d3db54657d567601d2721e34b563";

  UserService() {
    log("Cosnst");
    init();
  }

  Future<void> init() async {
    log("message");
    _webclient = Web3Client(
      _rpcUrl,
      http.Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );
    log("USER connected: ${await _webclient.getNetworkId()}");
    await getABI();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getABI() async {
  }

  Future<void> getCredentials() async {
    _creds = EthPrivateKey.fromHex(_privatekey);
  }

  Future<void> getDeployedContract() async {
  }
}

class User {}
