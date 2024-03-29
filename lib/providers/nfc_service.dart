import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import '../models/nfc.dart';
import '../src/endpoint.dart';

class NFCServices extends ChangeNotifier {
  /*
  Truffle v5.8.3 (core: 5.8.3)
  Ganache v7.8.0
  Solidity - 0.8.19 (solc-js)
  Node v19.9.0
  Web3.js v1.8.2
  Done in 2.73s.
  */
//
  List<NFC> nfcs = [];
  String rpcUrl = Platform.isAndroid
      ? "http://10.0.2.2:7545"
      //? "http://192.168.1.36:7545"
      : "127.0.0.1:7545";
  String wsUrl = Platform.isAndroid
      ? /*"ws://192.168.1.36:7545"*/ "ws://10.0.2.2:7545"
      : "ws://127.0.0.1:7545";
  late Web3Client _webclient;
  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  late EthPrivateKey _creds;
  bool isLoading = true;
  String privatekey =
      "bf8d54885fe16b82b8cfaa1c8d590a656bc8f9ab7ef0d03dc66ee637d6043a13";

  late DeployedContract _deployedContract;
  late ContractFunction _createNFC;
  late ContractFunction _deleteNFC;
  late ContractFunction _nfcs;
  late ContractFunction _nfcCount;

  String tokenFromDatabase = "";

  String dniTest = "";

  setDni(String dni) {
    dniTest = dni;
    notifyListeners();
  }

//
  NFCServices() {
    log("Contratos NFC");

    // init();
  }

  Future<void> init() async {
    try {
      _webclient = Web3Client(
        rpcUrl,
        http.Client(),
        socketConnector: () {
          return IOWebSocketChannel.connect(wsUrl).cast<String>();
        },
      );
      log("NFCS connected: ${await _webclient.getNetworkId()}");
      await getABI();
      await getCredentials();
      await getDeployedContract();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      log("$e");
    }
  }

  Future<void> getABI() async {
    String abiFile =
        await rootBundle.loadString('build/contracts/NFCContracts.json');
    var jsonABI = jsonDecode(abiFile);
    _abiCode = ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'NFCContracts');
    _contractAddress =
        EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
    log("Abi ${_abiCode.name} conAdd $_contractAddress");
  }

  Future<void> getCredentials() async {
    _creds = EthPrivateKey.fromHex(privatekey);
    log("creds ${_creds.address.toString()}");
  }

  Future<void> getDeployedContract() async {
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
    _createNFC = _deployedContract.function('createNFC');
    _deleteNFC = _deployedContract.function('deleteNFC');
    _nfcs = _deployedContract.function('nfcs');
    _nfcCount = _deployedContract.function('nfcCount');
    //_blockNum = _deployedContract.function("getBlockNumber");
    log("Create ${_createNFC.name}");
    await fetchNFCs();
  }

  Future getHash() async {
    final blockNumber = await _webclient.getBlockNumber();

    final blockHash = await getBlockHash(blockNumber);
    //var response = await _webclient
    //     .call(contract: _deployedContract, function: _blockNum, params: []);
    // log("$response");
    log('Hash del bloque: $blockHash');
    return blockHash;
  }

  Future createNBlocks(int n) async {
    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < n; i++) {
      // await Future.delayed(const Duration(seconds: 1), () => log("Esperé"));
      await addConstNFC();
    }
    log("Executed function in: ${stopwatch.elapsed.toString()}");
    stopwatch.stop();
  }

  Future addConstNFC() async {
    final stopwatch = Stopwatch()..start();
    try {
      await _webclient.sendTransaction(
        _creds,
        Transaction.callContract(
          contract: _deployedContract,
          function: _createNFC,
          parameters: [
            "owner",
          ],
        ),
      );
    } catch (e) {
      log("$e");
    }
    log("Executed addGenericNFC in: ${stopwatch.elapsed}");
    stopwatch.stop();
  }

  Future<String> getBlockHash(int blockNumber) async {
    final apiUrl = rpcUrl; // La URL de la API de Ganache

    // Construye la solicitud HTTP para obtener los detalles del bloque
    final request = http.Request('POST', Uri.parse(apiUrl));
    request.headers.addAll({'Content-Type': 'application/json'});
    request.body = jsonEncode({
      'jsonrpc': '2.0',
      'method': 'eth_getBlockByNumber',
      'params': ['0x${blockNumber.toRadixString(16)}', true],
      'id': 1,
    });

    // Realiza la solicitud HTTP
    final response = await http.post(request.url,
        headers: request.headers, body: request.body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final result = jsonResponse['result'];
      final blockHash = result['hash'];
      return blockHash;
    } else {
      throw Exception(
          'Error al obtener el hash del bloque: ${response.statusCode}');
    }
  }

  Future<void> fetchNFCs([bool refresh = false]) async {
    final stopwatch = Stopwatch()..start();
    if (refresh) {
      isLoading = true;
      notifyListeners();
    }

    try {
      var totalTaskList = await _webclient.call(
        contract: _deployedContract,
        function: _nfcCount,
        params: [],
      );

      // log("total task ${totalTaskList.length}");
      int totalTaskLen = totalTaskList[0].toInt();
      nfcs.clear();
      //     var temp =
      await _webclient.call(
        contract: _deployedContract,
        function: _nfcs,
        params: [BigInt.from(totalTaskLen - 1)],
      );
      //log("temp G $temp");
      for (int i = 0; i < totalTaskLen; i++) {
        var temp = await _webclient.call(
            contract: _deployedContract,
            function: _nfcs,
            params: [BigInt.from(i)]);
        //log("temp P $temp");
        if (temp[1] != "") {
          nfcs.add(
            NFC(
              id: (temp[0] as BigInt).toInt(),
              owner: temp[1],
              title: temp[2],
            ),
          );
        }
      }
    } catch (e) {
      log("$e");
    }

    isLoading = false;

    notifyListeners();
    log("Executed fetchNFCs in: ${stopwatch.elapsed.toString()}");
    stopwatch.stop();
  }

  List filteredNFCbyID(String id) {
    List filteredNFCs = nfcs.where((element) => element.owner == id).toList();

    return filteredNFCs;
  }

  // ignore: non_constant_identifier_names
  Future<String> addNFC(String owner, String title) async {
    final stopwatch = Stopwatch()..start();
    isLoading = true;
    notifyListeners();
    try {
      await _webclient.sendTransaction(
        _creds,
        Transaction.callContract(
          contract: _deployedContract,
          function: _createNFC,
          parameters: [
            owner,
            title,
          ],
        ),
      );
    } catch (e) {
      log("$e");
    }

    log("Executed addNFCs in: ${stopwatch.elapsed}");
    stopwatch.stop();
    await fetchNFCs();
    isLoading = false;
    notifyListeners();
    return await getHash();
  }

  Future<void> deleteNote(int id) async {
    final stopwatch = Stopwatch()..start();
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
    await fetchNFCs();
    isLoading = false;
    notifyListeners();
    log("Executed deleteNFCs in: ${stopwatch.elapsed.toString()}");
    stopwatch.stop();
  }

  Future registerNFC(
      {required String token,
      required String userID,
      required String title,
      // ignore: non_constant_identifier_names
      required String nfc_uid}) async {
    var response = await http.post(
      Uri.parse(getRegisterNFCRoute(id: userID)),
      body: {
        "nfc_uid": nfc_uid,
        "blockchain_hash": await addNFC(userID, title),
      },
      headers: {
        // "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    log("register NFC${response.body}");
    tokenFromDatabase = "${jsonDecode(response.body)["nfc_id"]}";
  }

  Future<String?> sendUIDAndHash(String uId, String hash) async {
    http.Response response = await http.post(
        Uri.parse("http://localhost:3000/api/register_nfc"),
        body: jsonEncode({"nfc_uid": uId, "hash": hash}));

    /*
      {
        "encrypted_code" : "0xagask8959kasd"
      }
    */

    if (response.statusCode == 201) {
      String code = jsonDecode(response.body)["encrypted_code"];
      return code;
    } else {
      return null;
    }
  }
}
