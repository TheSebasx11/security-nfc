import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:security_test/providers/user_service.dart';
import 'package:security_test/screens/screens.dart';

import 'package:url_launcher/url_launcher.dart';

class MainUserScreen extends StatefulWidget {
  const MainUserScreen({Key? key}) : super(key: key);

  @override
  State<MainUserScreen> createState() => _MainUserScreenState();
}

class _MainUserScreenState extends State<MainUserScreen> {
  final List _bodyWidgets = [
    const NFCHomeScreen(),
    UserDataView(),
  ];

  late UserServices userServices;

  int index = 0, cont = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userServices = Provider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    //log(" Yes daddy ${Theme.of(context).brightness.name}");
    return Scaffold(
      drawer: customDrawer(context),
      appBar: AppBar(
        title: GestureDetector(
          onTap: () async {
            if (cont == 10) {
              var url = "https://www.youtube.com/watch?v=gN5hj3vXMX8";
              await launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              );
              cont = 0;
            }
            cont++;
            //log("a $cont");
          },
          child: Text(index == 0 ? 'Your NFC cards' : "Your personal data"),
        ),
      ),
      body: _bodyWidgets[index],
    );
  }

  Widget customDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(width: 15), //
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).brightness.name == "dark"
                            ? Colors.white
                            : Colors.black),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(Icons.person),
                ),
                //SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        userServices.person!.name,
                        style: const TextStyle(fontSize: 25),
                      ),
                      Text(DateTime.now().hour < 12
                          ? "Buenos dias"
                          : DateTime.now().hour > 19
                              ? "Buenas noches"
                              : "Buenas tardes"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(
                color: Theme.of(context).brightness.name == "dark"
                    ? Colors.white
                    : Colors.black),
            Expanded(
              child: Column(
                children: <Widget>[
                  ListTile(
                    style: ListTileStyle.drawer,
                    title: const Text('Tus NFC\'s'),
                    trailing: const Icon(Icons.crop_landscape_sharp),
                    onTap: () => setState(() {
                      index = 0;
                      Navigator.pop(context);
                    }),
                  ),
                  ListTile(
                    style: ListTileStyle.drawer,
                    title: const Text('Tus datos'),
                    trailing: const Icon(Icons.dashboard_outlined),
                    onTap: () => setState(() {
                      index = 1;
                      Navigator.pop(context);
                    }),
                  ),
                ],
              ),
            ),
            Divider(
                color: Theme.of(context).brightness.name == "dark"
                    ? Colors.white
                    : Colors.black),
            ListTile(
                title: const Text("Cerrrar sesión"),
                style: ListTileStyle.drawer,
                trailing: const Icon(Icons.logout),
                onTap: () {
                  userServices.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                }),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
