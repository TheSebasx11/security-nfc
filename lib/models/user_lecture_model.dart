// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

DoctorUserLecture doctorUserLectureFromJson(String str) =>
    DoctorUserLecture.fromJson(json.decode(str)["user"]);

String userToJson(DoctorUserLecture data) => json.encode(data.toJson());

String formatDateTime(DateTime datetime) {
  return "${datetime.day < 10 ? "0${datetime.day}" : "${datetime.day}"}/${datetime.month < 10 ? "0${datetime.month}" : "${datetime.month}"}/${datetime.year}";
}

class DoctorUserLecture {
  final int id;
  final String email;

  final String role;
  final PersonLecture person;

  DoctorUserLecture({
    required this.id,
    required this.email,
    required this.role,
    required this.person,
  });

  factory DoctorUserLecture.fromJson(Map<String, dynamic> json) {
    return DoctorUserLecture(
      id: json["id"],
      email: json["email"],
      role: json["role"],
      person: PersonLecture.fromJson(json["person"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "role": role,
        "person": person.toJson(),
      };
}

class PersonLecture {
  final int id;
  final String dni;
  final String name;
  final String lastname;
  final String phone;
  final String ocupation;
  final String sex;
  final String maritalStatus;
  final String address;
  final String bloodType;
  final String height;
  final String religion;
  final String education;
  final String sisben;
  final String estrato;
  final DateTime birthday;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Allergy> allergies;
  final List<Contact> contacts;
  final List<Condition> conditions;
  final List<Medication> medications;
  final List<Appointment> appointments;

  PersonLecture({
    required this.id,
    required this.dni,
    required this.name,
    required this.lastname,
    required this.phone,
    required this.ocupation,
    required this.sex,
    required this.maritalStatus,
    required this.address,
    required this.bloodType,
    required this.height,
    required this.religion,
    required this.education,
    required this.sisben,
    required this.estrato,
    required this.birthday,
    required this.createdAt,
    required this.updatedAt,
    required this.allergies,
    required this.contacts,
    required this.conditions,
    required this.medications,
    required this.appointments,
  });

  factory PersonLecture.fromJson(Map<String, dynamic> json) => PersonLecture(
        id: json["id"],
        dni: json["dni"],
        name: json["name"],
        lastname: json["lastname"],
        phone: json["phone"],
        ocupation: json["ocupation"],
        sex: json["sex"],
        maritalStatus: json["marital_status"],
        address: json["address"],
        bloodType: json["blood_type"],
        height: json["height"],
        religion: json["religion"],
        education: json["education"],
        sisben: json["sisben"],
        estrato: json["estrato"],
        birthday: DateTime.parse(json["birthday"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        allergies: List<Allergy>.from(
            json["allergies"].map((x) => Allergy.fromJson(x))),
        contacts: List<Contact>.from(
            json["contacts"].map((x) => Contact.fromJson(x))),
        conditions: List<Condition>.from(
            json["conditions"].map((x) => Condition.fromJson(x))),
        medications: List<Medication>.from(
            json["medications"].map((x) => Medication.fromJson(x))),
        appointments: List<Appointment>.from(
            json["appointments"].map((x) => Appointment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        //"dni": dni,
        "Nombres": name,
        "Apellidos": lastname,
        "Telefono": phone,
        "Cedula": dni,
        "Ocupacion": ocupation,
        "Edad": 20,
        "Sexo": sex,
        "Estado Marital": maritalStatus,
        "Dirección": address,
        "Tipo de Sangre": bloodType,
        "Estatura": height,
        "Religion": religion,
        "Educación": education,
        "Sisben": sisben,
        "Estrato": estrato,
        "Fecha de Nacimiento": formatDateTime(birthday),
        //"user_id": userId,
        "allergies": List<dynamic>.from(allergies.map((x) => x.toJson())),
        "contacts": List<dynamic>.from(contacts.map((x) => x.toJson())),
        "conditions": List<dynamic>.from(conditions.map((x) => x.toJson())),
        "medications": List<dynamic>.from(medications.map((x) => x.toJson())),
        "appointments": List<dynamic>.from(appointments.map((x) => x.toJson())),
      };
}

class Allergy {
  final int id;
  final String name;
  final String description;
  final int severity;

  Allergy({
    required this.id,
    required this.name,
    required this.description,
    required this.severity,
  });

  factory Allergy.fromJson(Map<String, dynamic> json) => Allergy(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        severity: json["severity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "severity": severity,
      };
}

class Appointment {
  final int id;
  final DateTime startDay;
  final String reason;
  final String description;
  final String hospital;
  final String address;
  final String severity;
  final String city;
  final int personId;

  Appointment({
    required this.id,
    required this.startDay,
    required this.reason,
    required this.description,
    required this.hospital,
    required this.address,
    required this.severity,
    required this.city,
    required this.personId,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        id: json["id"],
        startDay: DateTime.parse(json["start_day"]),
        reason: json["reason"],
        description: json["description"],
        hospital: json["hospital"],
        address: json["address"],
        severity: json["severity"],
        city: json["city"],
        personId: json["person_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_day": formatDateTime(startDay),
        "reason": reason,
        "description": description,
        "hospital": hospital,
        "address": address,
        "severity": severity,
        "city": city,
        "person_id": personId,
      };
}

class Contact {
  final int id;
  final int personId;
  final DateTime createdAt;

  Contact({
    required this.id,
    required this.personId,
    required this.createdAt,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json["id"],
        personId: json["person_id"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "person_id": personId,
        "created_at": createdAt.toIso8601String(),
      };
}

class Medication {
  final int id;
  final String name;
  final String description;
  final String reason;
  final String dosage;
  final String frecuency;
  final DateTime startDate;
  final DateTime endDate;

  Medication({
    required this.id,
    required this.name,
    required this.description,
    required this.reason,
    required this.dosage,
    required this.frecuency,
    required this.startDate,
    required this.endDate,
  });

  factory Medication.fromJson(Map<String, dynamic> json) => Medication(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        reason: json["reason"],
        dosage: json["dosage"],
        frecuency: json["frecuency"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "reason": reason,
        "dosage": dosage,
        "frecuency": frecuency,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
      };
}

class Condition {
  final int id;
  final String name;
  final String description;
  final DateTime diagnosisDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Condition({
    required this.id,
    required this.name,
    required this.description,
    required this.diagnosisDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Condition.fromJson(Map<String, dynamic> json) => Condition(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        diagnosisDate: DateTime.parse(json["diagnosis_date"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "diagnosis_date": formatDateTime(diagnosisDate),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
