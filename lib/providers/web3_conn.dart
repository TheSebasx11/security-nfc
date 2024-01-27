import 'dart:io';


class Web3Connexion {
  final String _urlbase = "192.168.1.14";
//
  //late String _rpcUrl;
  //final String _wsUrl;
  /* late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  late EthPrivateKey _creds;

  final String _privatekey =
      //"8a5426c6e4c2182bf7524044dd4644293c90d3db54657d567601d2721e34b563";
      "60690621322e78adb86838a136b9b0dd8d673a016b5ff241ae58945cc26c44e6"; */

  get rpcUrl => Platform.isAndroid
      ? "http://$_urlbase:7545" /* "http://10.0.2.2:7545" */
      : "127.0.0.1:7545";
  get wsUrl => Platform.isAndroid
      ? "ws://$_urlbase:7545" /*  "ws://10.0.2.2:7545" */
      : "ws://127.0.0.1:7545";
}
