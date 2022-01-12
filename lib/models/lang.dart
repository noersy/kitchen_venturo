import 'dart:convert';

Lang lagFromJson(String str) => Lang.fromJson(json.decode(str));

String lagToJson(Lang data) => json.encode(data.toJson());

class Lang {
  final BottomNav bottomNav;
  final LangProfile profile;
  final LangPesanan pesanan;
  Lang({
    required this.bottomNav,
    required this.profile,
    required this.pesanan,
  });

  factory Lang.fromJson(Map<String, dynamic> json) => Lang(
        bottomNav: json["bottomNav"],
        profile: json["profile"],
        pesanan: json["pesanan"],
      );

  Map<String, dynamic> toJson() => {
        "bottomNav": bottomNav.toJson(),
        "profile": profile.toJson(),
        "pesanan": pesanan.toJson(),
      };
}

class BottomNav {
  final String nav1, nav2, nav3;

  BottomNav({
    required this.nav1,
    required this.nav2,
    required this.nav3,
  });

  factory BottomNav.fromJson(Map<String, dynamic> json) => BottomNav(
        nav1: json["bottomNav1"],
        nav2: json["bottomNav2"],
        nav3: json["bottomNav3"],
      );

  Map<String, dynamic> toJson() => {
        "bottomNav1": nav1,
        "bottomNav2": nav2,
        "bottomNav3": nav3,
      };
}

class LangProfile {
  final String nam, tgl, tlp, ub, ro, role, role2, br, lm, bhs;
  final String title, subtitle, subtitle2, caption;

  LangProfile({
    required this.nam,
    required this.tgl,
    required this.tlp,
    required this.ub,
    required this.ro,
    required this.role,
    required this.role2,
    required this.subtitle,
    required this.subtitle2,
    required this.caption,
    required this.title,
    required this.br,
    required this.lm,
    required this.bhs,
  });

  factory LangProfile.fromJson(Map<String, dynamic> json) => LangProfile(
        nam: json["nam"],
        tgl: json["tgl"],
        tlp: json["tlp"],
        ro: json["ro"],
        role: json["role"],
        role2: json["role2"],
        ub: json["ub"],
        title: json["title"],
        subtitle: json["subtitle"],
        subtitle2: json["subtitle2"],
        caption: json["caption"],
        br: json["br"],
        lm: json["lm"],
        bhs: json["bhs"],
      );

  Map<String, dynamic> toJson() => {
        "nam": nam,
        "tgl": tgl,
        "tlp": tlp,
        "ub": ub,
        "ro": ro,
        "role": role,
        "role2": role2,
        "title": title,
        "subtitle": subtitle,
        "subtitle2": subtitle2,
        "caption": caption,
        "br": br,
        "lm": lm,
        "bhs": bhs,
      };
}

class LangPesanan {
  final String tap, tap2;
  final String mini, ongoingCaption;
  final String riwayatCaption, riwayatCaption2;

  LangPesanan({
    required this.tap,
    required this.tap2,
    required this.ongoingCaption,
    required this.mini,
    required this.riwayatCaption,
    required this.riwayatCaption2,
  });

  factory LangPesanan.fromJson(Map<String, dynamic> json) => LangPesanan(
        tap: json["tap"],
        tap2: json["tap2"],
        mini: json["mini"],
        ongoingCaption: json["ongoingTitle"],
        riwayatCaption: json["riwayatCaption"],
        riwayatCaption2: json["riwayatCaption2"],
      );

  Map<String, dynamic> toJson() => {
        "tap": tap,
        "tap2": tap2,
        "mini": mini,
        "ongoingTitle": ongoingCaption,
        "riwayatCaption": riwayatCaption,
        "riwayatCaption2": riwayatCaption2,
      };
}
