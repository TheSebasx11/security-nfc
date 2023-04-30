import 'package:flutter/material.dart';
import 'package:security_test/components/index.dart';
//import 'package:responsive_grid_list/responsive_grid_list.dart';
import "package:security_test/components/index.dart";

class DoctorReadScreen extends StatefulWidget {
  const DoctorReadScreen({Key? key}) : super(key: key);

  @override
  State<DoctorReadScreen> createState() => _DoctorReadScreenState();
}

class _DoctorReadScreenState extends State<DoctorReadScreen> {
  int _tabIndex = 0;
  String title = "";
  final Map<String, List> generalInfomationData = {
    "Nombre": ["Sebastian", Icons.abc],
    "Nombre 2": ["Alfonsino", Icons.abc],
    "Apellido": ["Ricardo", Icons.abc],
    "Apellido 2": ["Cardenas", Icons.abc],
    "Cedula": ["1003050222", Icons.verified_user],
    "Edad": ["19", Icons.numbers],
    "Fecha de nacimiento": ["12/12/2012", Icons.date_range],
    "Altura": ["1.70m", Icons.height],
    "Peso": ["75kg", Icons.line_weight],
    "Sangre": ["A+", Icons.bloodtype],
    "Si": ["Si", Icons.bloodtype],
    "No": ["No", Icons.bloodtype],
  };

  final Map<String, List> alergiasInformationData = {
    "Melocoton": ["Hinchazón facial", "Baja"],
    "Diclofenaco": ["Baja presión", "Alta"],
    "Pelaje Animal": ["Estornudos frecuentes", "Media"],
    "Peyo": ["Estornudos frecuentes", "Media"],
    "Michositrioles": ["Estornudos frecuentes", "Media"],
    "Pere": ["Estornudos frecuentes", "Media"],
    "Karli": ["Estornudos frecuentes", "Media"],
  };

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
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabIndex == 0
            ? "Pacient Information Reader"
            : barItems[_tabIndex].label!),
      ),
      body: widgetsList(_tabIndex, dataSet: [
        generalInfomationData,
        alergiasInformationData,
        generalInfomationData,
        generalInfomationData,
        generalInfomationData
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
