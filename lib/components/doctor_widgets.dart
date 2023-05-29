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
Widget AlergiasWidget({required Map<String, List> data}) => SafeArea(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) => AlergiaWidget(
          title: data.keys.toList()[index],
          description: data.values.toList()[index][0],
          gravedad: data.values.toList()[index][1],
        ),
      ),
    );

// ignore: non_constant_identifier_names
Widget MedicamentosWidget({required Map data}) => SafeArea(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: (data["data"] as List).length,
        itemBuilder: (context, index) => MedicamentoWidget(
          desc: data["data"][index]["desc"],
          dosis: data["data"][index]["dosis"],
          lab: data["data"][index]["lab"],
          nombre: data["data"][index]["name"],
        ),
      ),
    );

// ignore: non_constant_identifier_names
Widget AfeccionesWidget({required Map data}) => SafeArea(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) => const AfeccionWidget(),
      ),
    );

// ignore: non_constant_identifier_names
Widget CitasWidget({required Map data}) => SafeArea(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: 7,
        itemBuilder: (context, index) => const CitaWidget(),
      ),
    );

Widget widgetsList(int index, {required List dataSet}) => [
      HomeWidget(data: dataSet[0]),
      AlergiasWidget(data: dataSet[1]),
      MedicamentosWidget(data: dataSet[2]),
      AfeccionesWidget(data: dataSet[3]),
      CitasWidget(data: dataSet[4]),
    ][index];
