// To parse this JSON data, do
//
//     final listVoucher = listVoucherFromJson(jsonString);

import 'dart:convert';

ListVoucher listVoucherFromJson(String str) => ListVoucher.fromJson(json.decode(str));

String listVoucherToJson(ListVoucher data) => json.encode(data.toJson());

class ListVoucher {
  ListVoucher({
    required this.statusCode,
    required this.data,
  });

  final int statusCode;
  final List<LVoucher> data;

  factory ListVoucher.fromJson(Map<String, dynamic> json) => ListVoucher(
    statusCode: json["status_code"],
    data: List<LVoucher>.from(json["data"].map((x) => LVoucher.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class LVoucher {
  LVoucher({
    required this.idVoucher,
    required this.nama,
    required this.idUser,
    required this.nominal,
    required this.infoVoucher,
    required this.periodeMulai,
    required this.periodeSelesai,
    required this.type,
    required this.status,
    this.catatan,
  });

  final int idVoucher;
  final String nama;
  final int idUser;
  final int nominal;
  final String infoVoucher;
  final int periodeMulai;
  final int periodeSelesai;
  final int type;
  final int status;
  final String? catatan;

  factory LVoucher.fromJson(Map<String, dynamic> json) => LVoucher(
    idVoucher: json["id_voucher"],
    nama: json["nama"],
    idUser: json["id_user"],
    nominal: json["nominal"],
    infoVoucher: json["info_voucher"],
    periodeMulai: json["periode_mulai"],
    periodeSelesai: json["periode_selesai"],
    type: json["type"],
    status: json["status"],
    catatan: json["catatan"],
  );

  Map<String, dynamic> toJson() => {
    "id_voucher": idVoucher,
    "nama": nama,
    "id_user": idUser,
    "nominal": nominal,
    "info_voucher": infoVoucher,
    "periode_mulai": periodeMulai,
    "periode_selesai": periodeSelesai,
    "type": type,
    "status": status,
    "catatan": catatan,
  };
}
