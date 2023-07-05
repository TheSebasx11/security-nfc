import 'dart:convert';
import 'dart:developer';

Person personFromJson(String str) => Person.fromJson(json.decode(str));

String personToJson(Person data) => json.encode(data.toJson());

class Person {
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
  final String birthday;
  final int userId;

  Person({
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
    required this.userId,
  });

  String getFullName() => "$name $lastname";

  factory Person.fromJson(Map<String, dynamic> json) {
    log("$json");
    return Person(
      dni: json["dni"],
      name: json["name"],
      lastname: "${json["lastname"]}",
      phone: "${json["phone"]}",
      ocupation: "${json["ocupation"]}",
      sex: "${json["sex"]}",
      maritalStatus: "${json["marital_status"]}",
      address: "${json["address"]}",
      bloodType: "${json["blood_type"]}",
      height: "${json["height"]}",
      religion: "${json["religion"]}",
      education: "${json["education"]}",
      sisben: "${json["sisben"]}",
      estrato: "${json["estrato"]}",
      birthday: "${json["birthday"]}",
      userId: json["user_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        //"dni": dni,
        "Nombres": name,
        "Apellidos": lastname,
        "Telefono": phone,
        "Ocupación": ocupation,
        "Sexo": sex,
        "Estado Marital": maritalStatus,
        "Dirección": address,
        "Tipo de Sangre": bloodType,
        "Estatura": height,
        "Religion": religion,
        "Educación": education,
        "Sisben": sisben,
        "Estrato": estrato,
        "Fecha de Nacimiento": birthday,
        //"user_id": userId,
      };
}
