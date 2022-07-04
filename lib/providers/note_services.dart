import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import '../models/note.dart';

class NotesServices extends ChangeNotifier {
//
  List<Note> notes = [];
  final String _rpcUrl = "127.0.0.1:7545";
  final String _wsUrl = "ws://127.0.0.1:7545";
  late Web3Client _webclient;
  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  late EthPrivateKey _creds;
  bool isLoading = true;
  final String _privatekey =
      "cc68313c5bc322f1505a8c2a0bb0ebd5aa1efb1e421f02ad14bf1da18843ef77";
  late DeployedContract _deployedContract;
  late ContractFunction _createNote;
  late ContractFunction _deleteNote;
  late ContractFunction _notes;
  late ContractFunction _noteCount;

//
  NotesServices() {
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
    await getABI();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getABI() async {
    String abiFile =
        await rootBundle.loadString('build/contracts/NotesContracts.json');
    var jsonABI = jsonDecode(abiFile);
    _abiCode =
        ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'NotesContracts');
    _contractAddress =
        EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _creds = EthPrivateKey.fromHex(_privatekey);
  }

  Future<void> getDeployedContract() async {
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
    _createNote = _deployedContract.function('createNote');
    _deleteNote = _deployedContract.function('deleteNote');
    _notes = _deployedContract.function('notes');
    _noteCount = _deployedContract.function('noteCount');
    await fetchNotes();
  }

  Future<void> fetchNotes() async {
    List totalTaskList = await _webclient.call(
      contract: _deployedContract,
      function: _noteCount,
      params: [],
    );

    int totalTaskLen = totalTaskList[0].toInt();
    notes.clear();
    for (var i = 0; i < totalTaskLen; i++) {
      var temp = await _webclient.call(
          contract: _deployedContract,
          function: _notes,
          params: [BigInt.from(i)]);
      if (temp[1] != "") {
        notes.add(
          Note(
            id: (temp[0] as BigInt).toInt(),
            title: temp[1],
            description: temp[2],
          ),
        );
      }
    }

    notifyListeners();
  }

  Future<void> addNote(String title, String description) async {
    await _webclient.sendTransaction(
      _creds,
      Transaction.callContract(
        contract: _deployedContract,
        function: _createNote,
        parameters: [title, description],
      ),
    );
    isLoading = true;
    fetchNotes();
  }

  Future<void> deleteNote(int id) async {
    await _webclient.sendTransaction(
      _creds,
      Transaction.callContract(
        contract: _deployedContract,
        function: _deleteNote,
        parameters: [BigInt.from(id)],
      ),
    );
    isLoading = true;
    notifyListeners();
    fetchNotes();
  }
}
