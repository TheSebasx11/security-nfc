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
    const Color primaryColor = Colors.blueAccent;
    const TextStyle customStyle =
        TextStyle(fontFamily: "EspecialFont"); //Color(0xFF49CC5d);
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: lightTheme(primaryColor),
      darkTheme: darkTheme(primaryColor, customStyle),
      title: 'Security NFC',
      debugShowCheckedModeBanner: false,
      //home: const LoginScreen(),
      home: const DefaultTextStyle(
          style: TextStyle(fontFamily: "EspecialFont"),
          child: DoctorReadScreen()),
    );
  }

  ThemeData darkTheme(Color primaryColor, TextStyle customStyle) {
    return ThemeData.dark().copyWith(
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
