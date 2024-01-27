import 'dart:math';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  final String studentName;
  const CalendarView({Key? key, required this.studentName}) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  int _tabIndex = 0;

  List<BottomNavigationBarItem> barItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Assists"),
    BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Grades"),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("${barItems[_tabIndex].label}: ${widget.studentName}"),
      ),
      body: contentWidgetSelection(_tabIndex),
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

  Widget contentWidgetSelection(int index) {
    return [
      SizedBox(
        child: TableCalendar(
          firstDay: DateTime(2023, 9, 29),
          focusedDay: DateTime.now(),
          lastDay: DateTime.now(),
          availableCalendarFormats: const {
            CalendarFormat.month: 'Month',
          },
          holidayPredicate: (day) {
            return day.weekday == DateTime.sunday ||
                day.weekday == DateTime.saturday;
          },
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: day.day ==
                          Random().nextInt(
                              31) /* day.day % 13 == 0 || day.day % 11 == 0 */
                      ? Colors.red
                      : day.day % 1 == 0
                          ? Colors.green
                          : null,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  '${day.day}',
                ),
              );
            },
          ),
        ),
      ),
      SafeArea(
        child: SizedBox(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('Materia')),
                DataColumn(label: Text('Nota')),
                DataColumn(label: Text('Razón')),
                DataColumn(label: Text('Fecha')),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: rowDataWidget(
                      name: 'Matemáticas',
                      grade: 9.0 / 2,
                      anot: 'Buen desempeño',
                      fecha: "10/10/2023"),
                ),
                DataRow(
                  cells: rowDataWidget(
                      name: 'Ciencias',
                      grade: 8.5 / 2,
                      anot: 'Esforzado',
                      fecha: "10/10/2023"),
                ),
                DataRow(
                  cells: rowDataWidget(
                      name: 'Historia',
                      grade: 7.8 / 2,
                      anot: 'Necesita mejorar',
                      fecha: "10/10/2023"),
                ),
                DataRow(
                  cells: rowDataWidget(
                      name: 'Inglés',
                      grade: 9.5 / 2,
                      anot: 'Excelente',
                      fecha: "10/10/2023"),
                ),
                // Agrega más filas según las calificaciones de tu estudiante
              ],
            ),
          ),
        ),
      ),
    ][index];
  }

  List<DataCell> rowDataWidget(
      {required String name,
      required double grade,
      String anot = "--",
      required String fecha}) {
    return [
      DataCell(Text(name)),
      DataCell(Text('$grade')),
      DataCell(Text(anot)),
      DataCell(Text(fecha)),
    ];
  }
}
