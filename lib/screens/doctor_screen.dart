import 'package:flutter/material.dart';
import 'package:security_test/components/index.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class DoctorReadScreen extends StatefulWidget {
  const DoctorReadScreen({Key? key}) : super(key: key);

  @override
  State<DoctorReadScreen> createState() => _DoctorReadScreenState();
}

class _DoctorReadScreenState extends State<DoctorReadScreen> {
  int _tabIndex = 0;

  final Map<String, List> data = {
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
    "Si": ["A+", Icons.bloodtype],
    "No": ["A+", Icons.bloodtype],
  };

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacient Information Reader'),
      ),
      body: widgetsList(_tabIndex),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: theme.primaryColor,
        unselectedItemColor: theme.primaryColor.withAlpha(70),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Hogar"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: "Alergias"),
          BottomNavigationBarItem(
              icon: Icon(Icons.medication_outlined), label: "Medicamentos"),
          BottomNavigationBarItem(
              icon: Icon(Icons.medical_information_outlined),
              label: "Afecciones"),
        ],
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
  Widget HomeWidget() => SafeArea(
        child: ResponsiveGridList(
          minItemWidth: 300,

          minItemsPerRow: 2,
          maxItemsPerRow: 3,
          listViewBuilderOptions: ListViewBuilderOptions(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
          ),
          children: data
              .map((key, value) => MapEntry(
                  key,
                  InformationCardWidget(
                      title: key, subtitle: value[0], icon: value[1])))
              .values
              .toList(),
        ),
      );

  // ignore: non_constant_identifier_names
  Widget AlergiasWidget() => const SafeArea(child: Text('Alergias'));

  Widget MedicamentosWidget() => const SafeArea(child: Text('Medicamentos'));

  Widget AfeccionesWidget() => const SafeArea(child: Text('Afecciones'));

  Widget widgetsList(int index) => [
        HomeWidget(),
        AlergiasWidget(),
        MedicamentosWidget(),
        AfeccionesWidget()
      ][index];
}
