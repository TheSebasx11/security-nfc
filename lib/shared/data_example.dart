import 'package:flutter/material.dart';

Map<String, List> generalInfomationData(String dni) => dni == "1005683926"
    ? {
        "Nombre": ["Sebastian", Icons.abc],
        "Nombre 2": ["", Icons.abc],
        "Apellido": ["Ricardo", Icons.abc],
        "Apellido 2": ["Cardenas", Icons.abc],
        "Cedula": ["1003050222", Icons.verified_user],
        "Edad": ["19", Icons.numbers],
        "Fecha de nacimiento": ["12/12/2012", Icons.date_range],
        "Altura": ["1.70m", Icons.height],
        "Peso": ["75kg", Icons.line_weight],
        "Sangre": ["A+", Icons.bloodtype],
        "Sisben": ["B2", Icons.abc],
        "Estrato": ["3", Icons.numbers],
      }
    : {
        "Nombre": ["Fabian", Icons.abc],
        "Nombre 2": ["Alberto", Icons.abc],
        "Apellido": ["Sanchez", Icons.abc],
        "Apellido 2": ["Ruiz", Icons.abc],
        "Cedula": ["1003050299", Icons.verified_user],
        "Edad": ["22", Icons.numbers],
        "Fecha de nacimiento": ["16/04/2001", Icons.date_range],
        "Altura": ["1.73 m", Icons.height],
        "Peso": ["65kg", Icons.line_weight],
        "Sangre": ["O+", Icons.bloodtype],
        "Sisben": ["B3", Icons.abc],
        "Estrato": ["2", Icons.numbers],
      };

final Map<String, List> alergiasInformationData = {
  "Melocoton": ["Hinchazón facial", "Baja"],
  "Diclofenaco": ["Baja presión", "Alta"],
  "Pelaje Animal": ["Estornudos frecuentes", "Media"],
  "Michositrioles": ["Estornudos frecuentes", "Media"],
};

final Map medicamentosData = {
  "data": [
    {
      "name": "Jingo Biloba",
      "desc": "Vitamina",
      "dosis": "Cada 3 horas",
      "lab": "La santé"
    },
    {
      "name": "Amoxicilina",
      "desc": "Antibiótico",
      "dosis": "Cada 5 horas",
      "lab": "MK"
    },
  ]
};

final Map afeccionesData = {
  "data": [
    {
      "name": "Calculos renales",
      "desc": "Concentraciones de calcio en los riñones",
      "diag": "07/12/2021",
    },
    {
      "name": "Anemia",
      "desc": "Lloralo",
      "diag": "07/12/2022",
    }
  ],
};

final Map citasData = {
  "data": [
    {
      "date": "08/05/2023",
      "desc": "Revisión general",
      "reason": "Normal",
      "doctor": "Dr. Ladislao",
    },
    {
      "date": "08/04/2023",
      "desc": "Revisión general",
      "reason": "Normal",
      "doctor": "Dr. Ladislao",
    },
    {
      "date": "08/03/2023",
      "desc": "Revisión general",
      "reason": "Normal",
      "doctor": "Dr. Ladislao",
    },
  ],
};
