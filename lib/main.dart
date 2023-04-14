import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:security_test/providers/nfc_service.dart';
import 'package:security_test/screens/screens.dart';

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
    const primaryColor = Color(0xFF49CC5d);
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: ThemeData.light().copyWith(
          primaryColor: primaryColor,
          appBarTheme: const AppBarTheme(backgroundColor: primaryColor),
          elevatedButtonTheme: const ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(primaryColor)))),
      darkTheme: ThemeData.dark().copyWith(
          primaryColor: primaryColor,
          elevatedButtonTheme: const ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(primaryColor)))),
      title: 'Security NFC',
      debugShowCheckedModeBanner: false,
      //home: const LoginScreen(),
      home: const DoctorReadScreen(),
    );
  }
}
