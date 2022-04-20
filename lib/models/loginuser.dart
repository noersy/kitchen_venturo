// To parse this JSON data, do
//
//     final loginUser = loginUserFromJson(jsonString);

import 'dart:convert';

LoginUser loginUserFromJson(String str) => LoginUser.fromJson(json.decode(str));

String loginUserToJson(LoginUser data) => json.encode(data.toJson());

class LoginUser {
  LoginUser({
    required this.statusCode,
    required this.data,
  });

  final int statusCode;
  final Data data;

  factory LoginUser.fromJson(Map<String, dynamic> json) => LoginUser(
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
    required this.user,
    required this.token,
  });

  final User user;
  final String token;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: User.fromJson(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "token": token,
      };
}

class User {
  User({
    required this.idUser,
    required this.email,
    required this.nama,
    required this.pin,
    required this.foto,
    required this.mRolesId,
    required this.isGoogle,
    required this.isCustomer,
    required this.roles,
    required this.akses,
  });

  final int idUser;
  final String email;
  final String nama;
  final String pin;
  final String foto;
  final int mRolesId;
  final int isGoogle;
  final int isCustomer;
  final String roles;
  final Akses akses;

  factory User.fromJson(Map<String, dynamic> json) => User(
        idUser: json["id_user"],
        email: json["email"],
        nama: json["nama"],
        pin: json["pin"],
        foto: json["foto"] ?? '',
        mRolesId: json["m_roles_id"],
        isGoogle: json["is_google"] ?? false,
        isCustomer: json["is_customer"],
        roles: json["roles"],
        akses: Akses.fromJson(json["akses"]),
      );

  Map<String, dynamic> toJson() => {
        "id_user": idUser,
        "email": email,
        "nama": nama,
        "pin": pin,
        "foto": foto,
        "m_roles_id": mRolesId,
        "is_google": isGoogle,
        "is_customer": isCustomer,
        "roles": roles,
        "akses": akses.toJson(),
      };
}

class Akses {
  Akses({
    required this.authUser,
    required this.authAkses,
    required this.settingMenu,
    required this.settingCustomer,
    required this.settingPromo,
    required this.settingDiskon,
    required this.settingVoucher,
    required this.laporanMenu,
    required this.laporanCustomer,
  });

  final bool authUser;
  final bool authAkses;
  final bool settingMenu;
  final bool settingCustomer;
  final bool settingPromo;
  final bool settingDiskon;
  final bool settingVoucher;
  final bool laporanMenu;
  final bool laporanCustomer;

  factory Akses.fromJson(Map<String, dynamic> json) => Akses(
        authUser: json["auth_user"],
        authAkses: json["auth_akses"],
        settingMenu: json["setting_menu"],
        settingCustomer: json["setting_customer"],
        settingPromo: json["setting_promo"],
        settingDiskon: json["setting_diskon"],
        settingVoucher: json["setting_voucher"],
        laporanMenu: json["laporan_menu"],
        laporanCustomer: json["laporan_customer"],
      );

  Map<String, dynamic> toJson() => {
        "auth_user": authUser,
        "auth_akses": authAkses,
        "setting_menu": settingMenu,
        "setting_customer": settingCustomer,
        "setting_promo": settingPromo,
        "setting_diskon": settingDiskon,
        "setting_voucher": settingVoucher,
        "laporan_menu": laporanMenu,
        "laporan_customer": laporanCustomer,
      };
}
