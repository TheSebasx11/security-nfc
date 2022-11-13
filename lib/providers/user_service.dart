import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import '../models/nfc.dart';

class UserService with ChangeNotifier {
  late User user;
  final String _rpcUrl = Platform.isAndroid
      ? "http://192.168.1.6:7545" /* "http://10.0.2.2:7545" */ : "127.0.0.1:7545";
  final String _wsUrl = Platform.isAndroid
      ? "ws://192.168.1.6:7545" /*  "ws://10.0.2.2:7545" */ : "ws://127.0.0.1:7545";
  late Web3Client _webclient;
  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  late EthPrivateKey _creds;
  bool isLoading = true;
  final String _privatekey =
      "8a5426c6e4c2182bf7524044dd4644293c90d3db54657d567601d2721e34b563";
  late DeployedContract _deployedContract;

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
    String abiFile = await rootBundle.loadString('build/contracts/Auth.json');
    var jsonABI = jsonDecode(abiFile);
    _abiCode = ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'NFCContracts');
    _contractAddress =
        EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _creds = EthPrivateKey.fromHex(_privatekey);
  }

  Future<void> getDeployedContract() async {
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
  }
}

class User {}
