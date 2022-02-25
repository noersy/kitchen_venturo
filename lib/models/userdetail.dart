// To parse this JSON data, do
//
//     final userDetail = userDetailFromJson(jsonString);

import 'dart:convert';

UserDetail userDetailFromJson(String str) => UserDetail.fromJson(json.decode(str));

String userDetailToJson(UserDetail data) => json.encode(data.toJson());

class UserDetail {
  UserDetail({
    required this.statusCode,
    required this.data,
  });

  final int statusCode;
  final DUser data;

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
    statusCode: json["status_code"],
    data: DUser.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "data": data.toJson(),
  };
}

class DUser {
  DUser({
    required this.idUser,
    required this.nama,
    required this.email,
    this.tglLahir,
    this.alamat,
    this.telepon,
    this.foto,
    this.ktp,
    required this.pin,
    required this.status,
    required this.rolesId,
    required this.roles,
  });

  final int idUser;
  final String nama;
  final String email;
  final String? tglLahir;
  final String? alamat;
  final String? telepon;
  final String? foto;
  final String? ktp;
  final String pin;
  final int status;
  final int rolesId;
  final String roles;

  factory DUser.fromJson(Map<String, dynamic> json) => DUser(
    idUser: json["id_user"],
    nama: json["nama"],
    email: json["email"],
    tglLahir: json["tgl_lahir"],
    alamat: json["alamat"],
    telepon: json["telepon"],
    foto: json["foto"],
    ktp: json["ktp"],
    pin: json["pin"],
    status: json["status"],
    rolesId: json["roles_id"],
    roles: json["roles"],
  );

  Map<String, dynamic> toJson() => {
    "id_user": idUser,
    "nama": nama,
    "email": email,
    "tgl_lahir": tglLahir,
    "alamat": alamat,
    "telepon": telepon,
    "foto": foto,
    "ktp": ktp,
    "pin": pin,
    "status": status,
    "roles_id": rolesId,
    "roles": roles,
  };
}
