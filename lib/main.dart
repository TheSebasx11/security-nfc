import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:security_test/providers/nfc_service.dart';
import 'package:security_test/providers/user_service.dart';
import 'package:security_test/screens/screens.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NFCServices()),
          ChangeNotifierProvider(create: (_) => UserServices()),
        ],
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  void getGanacheData(BuildContext context) async {
    NFCServices nfcServices = Provider.of(context, listen: false);
    UserServices userServices = Provider.of(context, listen: false);

    Map data = await userServices.getMapFromLocalStorage("ganacheData");

    nfcServices.rpcUrl = "http://${data["ip"]}";
    nfcServices.wsUrl = "ws://${data["ip"]}";
    nfcServices.privatekey = data["key"];
    log("charged");
    await nfcServices.init();
  }

  @override
  Widget build(BuildContext context) {
    getGanacheData(context);
    Color primaryColor = const Color(0xFF7cbed2);
    const TextStyle customStyle =
        TextStyle(fontFamily: "EspecialFont"); //Color(0xFF49CC5d);
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: lightTheme(primaryColor),
      darkTheme: darkTheme(primaryColor, customStyle),
      title: 'Security NFC',
      debugShowCheckedModeBanner: false,
      home: const DefaultTextStyle(
        style: TextStyle(fontFamily: "EspecialFont"),
        child: LoginScreen(),
        // child: NFCHomeScreen(),
      ),
    );
  }

  ThemeData darkTheme(Color primaryColor, TextStyle customStyle) {
    return ThemeData.dark(useMaterial3: true).copyWith(
        primaryColor: primaryColor,
        textTheme: TextTheme(bodyLarge: customStyle),
        bottomNavigationBarTheme:
            BottomNavigationBarThemeData(selectedLabelStyle: customStyle),
        appBarTheme:
            AppBarTheme(titleTextStyle: customStyle.copyWith(fontSize: 20)),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(primaryColor))));
  }

  ThemeData lightTheme(Color primaryColor) {
    return ThemeData.light().copyWith(
        primaryColor: primaryColor,
        appBarTheme: AppBarTheme(backgroundColor: primaryColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(primaryColor))));
  }
}
