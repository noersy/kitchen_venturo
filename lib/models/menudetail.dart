// To parse this JSON data, do
//
//     final menuDetail = menuDetailFromJson(jsonString);

import 'dart:convert';

MenuDetail menuDetailFromJson(String str) => MenuDetail.fromJson(json.decode(str));

String menuDetailToJson(MenuDetail data) => json.encode(data.toJson());

class MenuDetail {
  MenuDetail({
    required this.statusCode,
    required this.data,
  });

  final int statusCode;
  final Data data;

  factory MenuDetail.fromJson(Map<String, dynamic> json) => MenuDetail(
    statusCode: json["status_code"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.menu,
    this.topping,
    this.level,
  });

  final Menu menu;
  final List<Level>? topping;
  final List<Level>? level;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    menu: Menu.fromJson(json["menu"]),
    topping: List<Level>.from(json["topping"].map((x) => Level.fromJson(x))),
    level: List<Level>.from(json["level"].map((x) => Level.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "menu": menu.toJson(),
    "topping": topping != null ? List<Level>.from(topping!.map((x) => x.toJson())) : [],
    "level": level != null ?List<Level>.from(level!.map((x) => x.toJson())) : [],
  };
}

class Level {
  Level({
    required this.idDetail,
    required this.idMenu,
    required this.keterangan,
    required this.type,
    required this.harga,
  });

  final int idDetail;
  final int idMenu;
  final String keterangan;
  final String type;
  final int harga;

  factory Level.fromJson(Map<String, dynamic> json) => Level(
    idDetail: json["id_detail"],
    idMenu: json["id_menu"],
    keterangan: json["keterangan"],
    type: json["type"],
    harga: json["harga"],
  );

  Map<String, dynamic> toJson() => {
    "id_detail": idDetail,
    "id_menu": idMenu,
    "keterangan": keterangan,
    "type": type,
    "harga": harga,
  };
}

class Menu {
  Menu({
    required this.idMenu,
    required this.nama,
    required this.kategori,
    required this.harga,
    this.deskripsi,
    this.foto,
    required this.status,
  });

  final int idMenu;
  final String nama;
  final String kategori;
  final int harga;
  final String? deskripsi;
  final String? foto;
  final int status;

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    idMenu: json["id_menu"],
    nama: json["nama"],
    kategori: json["kategori"],
    harga: json["harga"],
    deskripsi: json["deskripsi"],
    foto: json["foto"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id_menu": idMenu,
    "nama": nama,
    "kategori": kategori,
    "harga": harga,
    "deskripsi": deskripsi,
    "foto": foto,
    "status": status,
  };
}
