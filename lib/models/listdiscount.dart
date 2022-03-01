// To parse this JSON data, do
//
//     final listDiscount = listDiscountFromJson(jsonString);

import 'dart:convert';

ListDiscount listDiscountFromJson(String str) => ListDiscount.fromJson(json.decode(str));

String listDiscountToJson(ListDiscount data) => json.encode(data.toJson());

class ListDiscount {
  ListDiscount({
    required this.statusCode,
    required this.data,
  });

  final int statusCode;
  final List<Discount> data;

  factory ListDiscount.fromJson(Map<String, dynamic> json) => ListDiscount(
    statusCode: json["status_code"],
    data: List<Discount>.from(json["data"].map((x) => Discount.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Discount {
  Discount({
    required this.idDiskon,
    required this.idUser,
    required this.namaUser,
    required this.nama,
    required this.diskon,
  });

  final int idDiskon;
  final int idUser;
  final String namaUser;
  final String nama;
  final int diskon;

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
    idDiskon: json["id_diskon"],
    idUser: json["id_user"],
    namaUser: json["nama_user"],
    nama: json["nama"],
    diskon: json["diskon"],
  );

  Map<String, dynamic> toJson() => {
    "id_diskon": idDiskon,
    "id_user": idUser,
    "nama_user": namaUser,
    "nama": nama,
    "diskon": diskon,
  };
}
