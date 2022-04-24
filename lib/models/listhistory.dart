// To parse this JSON data, do
//
//     final listHistory = listHistoryFromJson(jsonString);

import 'dart:convert';

import 'listorder.dart';

ListHistory listHistoryFromJson(String str) =>
    ListHistory.fromJson(json.decode(str));

String listHistoryToJson(ListHistory data) => json.encode(data.toJson());

class ListHistory {
  ListHistory({
    required this.statusCode,
    required this.data,
    required this.totalPrice,
    required this.totalOrder,
  });

  final int statusCode;
  final List<Order> data;
  final int totalPrice;
  final int totalOrder;

  factory ListHistory.fromJson(Map<String, dynamic> json) => ListHistory(
        statusCode: json["status_code"],
        data: List<Order>.from(
            json["data"]['listData'].map((x) => History.fromJson(x))),
        totalPrice: json["data"]['totalPrice'] ?? 0,
        totalOrder: json["data"]['totalOrder'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class History {
  History({
    required this.idOrder,
    required this.noStruk,
    required this.nama,
    required this.totalBayar,
    required this.tanggal,
    required this.status,
    required this.menu,
  });

  final int idOrder;
  final String noStruk;
  final String nama;
  final int totalBayar;
  final DateTime tanggal;
  final int status;
  final List<Menu> menu;

  factory History.fromJson(Map<String, dynamic> json) => History(
        idOrder: json["id_order"],
        noStruk: json["no_struk"],
        nama: json["nama"],
        totalBayar: json["total_bayar"],
        tanggal: DateTime.parse(json["tanggal"]),
        status: json["status"],
        menu: List<Menu>.from(json["menu"].map((x) => Menu.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id_order": idOrder,
        "no_struk": noStruk,
        "nama": nama,
        "total_bayar": totalBayar,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "status": status,
        "menu": List<dynamic>.from(menu.map((x) => x.toJson())),
      };
}

// class Menu {
//   Menu({
//     required this.idMenu,
//     required this.kategori,
//     required this.nama,
//     this.foto,
//     required this.jumlah,
//     required this.harga,
//     required this.total,
//     this.catatan,
//   });

//   final int idMenu;
//   final String kategori;
//   final String nama;
//   final String? foto;
//   final int jumlah;
//   final String harga;
//   final int total;
//   final String? catatan;

//   factory Menu.fromJson(Map<String, dynamic> json) => Menu(
//     idMenu: json["id_menu"],
//     kategori: json["kategori"],
//     nama: json["nama"],
//     foto: json["foto"],
//     jumlah: json["jumlah"],
//     harga: json["harga"],
//     total: json["total"],
//     catatan: json["catatan"],
//   );

//   Map<String, dynamic> toJson() => {
//     "id_menu": idMenu,
//     "kategori": kategori,
//     "nama": nama,
//     "foto": foto,
//     "jumlah": jumlah,
//     "harga": harga,
//     "total": total,
//     "catatan": catatan,
//   };
// }
