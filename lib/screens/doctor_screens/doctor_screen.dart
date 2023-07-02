import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:security_test/components/index.dart';
import 'package:security_test/providers/nfc_service.dart';
import 'package:security_test/providers/user_service.dart';
import 'package:security_test/shared/data_example.dart';

import '../screens.dart';

class DoctorReadScreen extends StatefulWidget {
  const DoctorReadScreen({Key? key}) : super(key: key);

  @override
  State<DoctorReadScreen> createState() => _DoctorReadScreenState();
}

class _DoctorReadScreenState extends State<DoctorReadScreen> {
  int _tabIndex = 0;
  String title = "";

  List<BottomNavigationBarItem> barItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Hogar"),
    BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Alergias"),
    BottomNavigationBarItem(
        icon: Icon(Icons.medication_outlined), label: "Medicamentos"),
    BottomNavigationBarItem(
        icon: Icon(Icons.medical_information_outlined), label: "Afecciones"),
    BottomNavigationBarItem(
        icon: Icon(Icons.accessibility_new_sharp), label: "Citas"),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    NFCServices nfcService = Provider.of(context);
    UserServices userServices = Provider.of(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabIndex == 0
            ? "Pacient Information Reader"
            : barItems[_tabIndex].label!),
        actions: [
          IconButton(
              onPressed: () {
                userServices.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: widgetsList(_tabIndex, dataSet: [
        generalInfomationData(nfcService.dniTest),
        alergiasInformationData,
        medicamentosData,
        afeccionesData,
        citasData
      ]),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: theme.primaryColor,
        unselectedItemColor: theme.primaryColor
            .withAlpha(theme.brightness == Brightness.light ? 180 : 70),
        items: barItems,
        currentIndex: _tabIndex,
        onTap: (value) {
          setState(() {
            _tabIndex = value;
          });
        },
      ),
    );
  }

  // ignore: non_constant_identifier_names
}
