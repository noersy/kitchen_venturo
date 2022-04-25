// To parse this JSON data, do
//
//     final listOrder = listOrderFromJson(jsonString);

import 'dart:convert';

ListOrder listOrderFromJson(String str) => ListOrder.fromJson(json.decode(str));

String listOrderToJson(ListOrder data) => json.encode(data.toJson());

class ListOrder {
  ListOrder({
    required this.statusCode,
    required this.data,
    required this.totalPrice,
    required this.totalOrder,
  });

  final int statusCode;
  final List<Order> data;
  final int totalPrice;
  final int totalOrder;

  factory ListOrder.fromJson(Map<String, dynamic> json) => ListOrder(
        statusCode: json["status_code"],
        data: List<Order>.from(
            json["data"]['listData'].map((x) => Order.fromJson(x))),
        totalPrice: json["data"]['totalPrice'] == null
            ? 0
            : int.parse(json["data"]['totalPrice'].toString()),
        totalOrder: json["data"]['totalOrder'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Order {
  Order({
    required this.idOrder,
    required this.noStruk,
    required this.nama,
    required this.totalBayar,
    required this.tglDatetime,
    required this.tgl,
    required this.status,
    required this.menu,
  });

  final int idOrder;
  final String noStruk;
  final String nama;
  final int totalBayar;
  final DateTime tglDatetime;
  final String tgl;
  final int status;
  final List<Menu> menu;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        idOrder: json["id_order"],
        noStruk: json["no_struk"] ?? '',
        nama: json["nama"] ?? '',
        totalBayar: json["total_bayar"],
        tglDatetime: DateTime.parse(json["created_at"].toString()),
        tgl: json['tanggal'],
        status: json["status"],
        menu: List<Menu>.from(json["menu"].map((x) => Menu.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id_order": idOrder,
        "no_struk": noStruk,
        "nama": nama,
        "total_bayar": totalBayar,
        "tanggal": tgl,
        "status": status,
        "menu": List<dynamic>.from(menu.map((x) => x.toJson())),
      };
}

class Menu {
  Menu({
    required this.idMenu,
    required this.kategori,
    required this.nama,
    this.foto,
    required this.jumlah,
    required this.harga,
    required this.total,
    this.catatan,
  });

  final int idMenu;
  final String kategori;
  final String nama;
  final String? foto;
  final int jumlah;
  final String harga;
  final int total;
  final String? catatan;

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        idMenu: json["id_menu"],
        kategori: json["kategori"] ?? '',
        nama: json["nama"] ?? '',
        foto: json["foto"] ?? '',
        jumlah: json["jumlah"] ?? 0,
        harga: json["harga"] == null ? '' : json["harga"].toString(),
        total: json["total"] ?? 0,
        catatan: json["catatan"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id_menu": idMenu,
        "kategori": kategori,
        "nama": nama,
        "foto": foto,
        "jumlah": jumlah,
        "harga": harga,
        "total": total,
        "catatan": catatan,
      };
}
