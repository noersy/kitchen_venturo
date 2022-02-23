// To parse this JSON data, do
//
//     final orderDetail = orderDetailFromJson(jsonString);

import 'dart:convert';

OrderDetail orderDetailFromJson(String str) => OrderDetail.fromJson(json.decode(str));

String orderDetailToJson(OrderDetail data) => json.encode(data.toJson());

class OrderDetail {
  OrderDetail({
    required this.statusCode,
    required this.data,
  });

  final int statusCode;
  final Data data;

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
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
    required this.order,
    required this.detail,
  });

  final Order order;
  final List<Detail> detail;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    order: Order.fromJson(json["order"]),
    detail: List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "order": order.toJson(),
    "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
  };
}

class Detail {
  Detail({
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

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    idMenu: json["id_menu"],
    kategori: json["kategori"],
    nama: json["nama"],
    foto: json["foto"],
    jumlah: json["jumlah"],
    harga: json["harga"],
    total: json["total"],
    catatan: json["catatan"],
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

class Order {
  Order({
    required this.idOrder,
    required this.noStruk,
    required this.nama,
    this.idVoucher,
    this.namaVoucher,
    this.diskon,
    this.potongan,
    required this.totalBayar,
    required this.tanggal,
    required this.status,
  });

  final int idOrder;
  final String noStruk;
  final String nama;
  final int? idVoucher;
  final String? namaVoucher;
  final int? diskon;
  final int? potongan;
  final int totalBayar;
  final DateTime tanggal;
  final int status;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    idOrder: json["id_order"],
    noStruk: json["no_struk"],
    nama: json["nama"],
    idVoucher: json["id_voucher"],
    namaVoucher: json["nama_voucher"],
    diskon: json["diskon"],
    potongan: json["potongan"],
    totalBayar: json["total_bayar"],
    tanggal: DateTime.parse(json["tanggal"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id_order": idOrder,
    "no_struk": noStruk,
    "nama": nama,
    "id_voucher": idVoucher,
    "nama_voucher": namaVoucher,
    "diskon": diskon,
    "potongan": potongan,
    "total_bayar": totalBayar,
    "tanggal": "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
    "status": status,
  };
}
