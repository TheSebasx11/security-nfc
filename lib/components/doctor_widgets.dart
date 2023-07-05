import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'index.dart';

// ignore: non_constant_identifier_names
Widget HomeWidget({required Map data}) => SafeArea(
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
Widget AlergiasWidget({required List data}) => SafeArea(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) => AlergiaWidget(
          title: data[index]["name"],
          description: data[index]["description"],
          gravedad: data[index]["severity"],
        ),
      ),
    );

// ignore: non_constant_identifier_names
Widget MedicamentosWidget({required Map data}) => SafeArea(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: (data["medications"] as List).length,
        itemBuilder: (context, index) => MedicamentoWidget(
          desc: data["medications"][index]["description"],
          dosis: data["medications"][index]["frecuency"],
          reason: data["medications"][index]["reason"],
          nombre: data["medications"][index]["name"],
        ),
      ),
    );

// ignore: non_constant_identifier_names
Widget AfeccionesWidget({required Map data}) => SafeArea(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: (data["conditions"] as List).length,
        itemBuilder: (context, index) => AfeccionWidget(
          desc: data["conditions"][index]["description"],
          diagnosis: data["conditions"][index]["diagnosis_date"],
          name: data["conditions"][index]["name"],
        ),
      ),
    );

// ignore: non_constant_identifier_names
Widget CitasWidget({required Map data}) => SafeArea(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: (data["appointments"] as List).length,
        itemBuilder: (context, index) => CitaWidget(
          desc: data["appointments"][index]["description"],
          doctor: data["appointments"][index]["hospital"],
          reason: data["appointments"][index]["reason"],
          date: data["appointments"][index]["start_day"],
        ),
      ),
    );

Widget widgetsList(int index, {required List dataSet}) => [
      HomeWidget(data: dataSet[0]),
      AlergiasWidget(data: dataSet[1]),
      MedicamentosWidget(data: dataSet[2]),
      AfeccionesWidget(data: dataSet[3]),
      CitasWidget(data: dataSet[4]),
    ][index];
