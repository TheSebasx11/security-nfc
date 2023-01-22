import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:security_test/providers/nfc_service.dart';
import 'package:security_test/providers/user_service.dart';
import 'package:security_test/screens/home_screen.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NFCServices()),
          //ChangeNotifierProvider(create: (_) => UserService()),
        ],
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF49894d),
      ),
      title: 'Security NFC',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
