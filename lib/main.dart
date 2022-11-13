import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:security_test/providers/nfc_service.dart';
import 'package:security_test/providers/user_service.dart';
import 'package:security_test/screens/home_screen.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NFCServices()),
          ChangeNotifierProvider(create: (context) => UserService()),
        ],
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Security NFC',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
