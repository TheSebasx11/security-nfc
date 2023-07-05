import 'package:flutter/material.dart';
import 'package:security_test/models/models.dart';

Map<String, List> generalInfomationData(Map data) => {
      "Nombres": ["${data["Nombres"]}", Icons.abc],
      //"Nombre 2": ["", Icons.abc],
      "Apellidos": ["${data["Apellidos"]}", Icons.abc],
      //"Apellido 2": ["Cardenas", Icons.abc],
      "Cedula": ["${data["Cedula"]}", Icons.numbers],
      "Ocupación": ["${data["Ocupacion"]}", Icons.work],
      "Sexo": [
        data["Sexo"] == 'M' ? "Masculino" : "Femenino",
        Icons.face_outlined
      ],
      "Edad": ["${data["Edad"]}", Icons.numbers],
      "Fecha de nacimiento": [
        "${data["Fecha de Nacimiento"]}",
        Icons.date_range
      ],
      "Educacion": ["${data["Educación"]}", Icons.school_outlined],
      "Estado marital": [
        data["Estado Marital"] == 'S'
            ? "Soltero"
            : data["Estado Marital"] == 'C'
                ? "Casado"
                : data["Estado Marital"] == 'U'
                    ? "Union Libre"
                    : "",
        Icons.people_outlined
      ],
      "Religion": ["${data["Religion"]}", Icons.church_outlined],
      "Altura": ["${data["Estatura"]}", Icons.height],
      "Sangre": ["${data["Tipo de Sangre"]}", Icons.bloodtype],
      "Sisben": ["${data["Sisben"]}", Icons.abc],
      "Estrato": ["${data["Estrato"]}", Icons.numbers],
    };

Map<String, List> alergiasInformationData(List<Allergy> data) => {
      "allergies": data.map((e) => e.toJson()).toList(),
    };

Map medicamentosData(List<Medication> data) => {
      "medications": data.map((e) => e.toJson()).toList(),
    };

Map afeccionesData(List<Condition> data) => {
      "conditions": data.map((e) => e.toJson()).toList(),
    };

Map citasData(List<Appointment> data) => {
      "appointments": data.map((e) => e.toJson()).toList(),
    };

// final Map afeccionesData = {
//   "data": [
//     {
//       "name": "Calculos renales",
//       "desc": "Concentraciones de calcio en los riñones",
//       "diag": "07/12/2021",
//     },
//     {
//       "name": "Anemia",
//       "desc": "Lloralo",
//       "diag": "07/12/2022",
//     }
//   ],
// };

// final Map citasData = {
//   "data": [
//     {
//       "date": "08/05/2023",
//       "desc": "Revisión general",
//       "reason": "Normal",
//       "doctor": "Dr. Ladislao",
//     },
//     {
//       "date": "08/04/2023",
//       "desc": "Revisión general",
//       "reason": "Normal",
//       "doctor": "Dr. Ladislao",
//     },
//     {
//       "date": "08/03/2023",
//       "desc": "Revisión general",
//       "reason": "Normal",
//       "doctor": "Dr. Ladislao",
//     },
//   ],
// };
