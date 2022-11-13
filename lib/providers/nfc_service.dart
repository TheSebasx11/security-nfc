import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import '../models/nfc.dart';

class NFCServices extends ChangeNotifier {
//
  List<NFC> nfcs = [];
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
      "cc68313c5bc322f1505a8c2a0bb0ebd5aa1efb1e421f02ad14bf1da18843ef77";
  late DeployedContract _deployedContract;
  late ContractFunction _createNFC;
  late ContractFunction _deleteNFC;
  late ContractFunction _nfcs;
  late ContractFunction _nfcCount;

//
  NFCServices() {
    init();
  }

  Future<void> init() async {
    _webclient = Web3Client(
      _rpcUrl,
      http.Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );
    log("connected: ${await _webclient.getNetworkId()}");
    await getABI();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getABI() async {
    String abiFile =
        await rootBundle.loadString('build/contracts/NFCContracts.json');
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
    _createNFC = _deployedContract.function('createNFC');
    _deleteNFC = _deployedContract.function('deleteNFC');
    _nfcs = _deployedContract.function('nfcs');
    _nfcCount = _deployedContract.function('nfcCount');
    await fetchNotes();
  }

  Future<void> fetchNotes() async {
    List totalTaskList = await _webclient.call(
      contract: _deployedContract,
      function: _nfcCount,
      params: [],
    );

    int totalTaskLen = totalTaskList[0].toInt();
    nfcs.clear();
    for (var i = 0; i < totalTaskLen; i++) {
      var temp = await _webclient.call(
          contract: _deployedContract,
          function: _nfcs,
          params: [BigInt.from(i)]);
      if (temp[1] != "") {
        nfcs.add(
          NFC(
            id: (temp[0] as BigInt).toInt(),
            NFCID: temp[1],
            owner: temp[2],
            ownerDNI: temp[3],
          ),
        );
      }
    }
    isLoading = false;

    notifyListeners();
  }

  Future<void> addNote(String NFCID, String Owner, String OwnerID) async {
    isLoading = true;
    notifyListeners();
    await _webclient.sendTransaction(
      _creds,
      Transaction.callContract(
        contract: _deployedContract,
        function: _createNFC,
        parameters: [NFCID, Owner, OwnerID],
      ),
    );

    await fetchNotes();
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteNote(int id) async {
    isLoading = true;
    notifyListeners();
    await _webclient.sendTransaction(
      _creds,
      Transaction.callContract(
        contract: _deployedContract,
        function: _deleteNFC,
        parameters: [BigInt.from(id)],
      ),
    );
    await fetchNotes();
    isLoading = false;
    notifyListeners();
    
  }
}
