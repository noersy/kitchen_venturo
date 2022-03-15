// ignore_for_file: non_constant_identifier_names

class Lang {
  final BottomNav bottomNav;
  final LangProfile profile;
  final LangPesanan pesanan;

  Lang({
    required this.bottomNav,
    required this.profile,
    required this.pesanan,
  });
}

class BottomNav {
  final String nav1, nav2, nav3;

  BottomNav({
    required this.nav1,
    required this.nav2,
    required this.nav3,
  });
}

class LangProfile {
  final String nam,
      tgl,
      tlp,
      ub,
      ro,
      role,
      role2,
      br,
      lm,
      bhs,
      penilaian,
      nilai_sekarang,
      versiAplikasi,
      namaPerangkat;
  final String title, subtitle, subtitle2;

  final ProfileCation caption;

  LangProfile(
      {required this.nam,
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
      required this.penilaian,
      required this.nilai_sekarang,
      required this.versiAplikasi,
      required this.namaPerangkat});
}

class ProfileCation {
  final String status1, status2, status3;

  ProfileCation({
    required this.status1,
    required this.status2,
    required this.status3,
  });
}

class LangPesanan {
  final String tap, tap2;
  final String mini, ongoingCaption;
  final String riwayatCaption, riwayatCaption2;
  final String allStatus, status, status2, statusB, status3, status4;
  final String buttonPe, buttonLa;
  final String totalOr;

  LangPesanan({
    required this.tap,
    required this.tap2,
    required this.ongoingCaption,
    required this.mini,
    required this.riwayatCaption,
    required this.riwayatCaption2,
    required this.allStatus,
    required this.status,
    required this.status2,
    required this.statusB,
    required this.status3,
    required this.status4,
    required this.buttonLa,
    required this.buttonPe,
    required this.totalOr,
  });
}
