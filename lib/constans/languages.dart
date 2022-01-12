
import 'package:kitchen/models/lang.dart';

class ConstLang {
  static Lang eng = Lang(
    bottomNav: BottomNav(
      nav1: "History",
      nav2: "Orders",
      nav3: "Profile",
    ),
    profile: LangProfile(
      nam: "Name",
      tgl: "Date",
      tlp: "No.Telephone",
      ub: "Change",
      ro: "Role",
      role: "Teller",
      role2: "Customer",
      title: "Profile",
      subtitle: "Info Account",
      subtitle2: "Info Other",
      caption: "You have verified ID card",
      br: "New Pin",
      lm: "Old Pin",
      bhs: "Change Language"
    ),
    pesanan: LangPesanan(
      tap: "Ongoing",
      tap2: "History",
      mini: "Being Prepared",
      ongoingCaption: "Already Ordered?\nTrack your order here.",
      riwayatCaption: 'Start ordering.',
      riwayatCaption2:
          'The food you ordered\n appears here so\nyou can find\nyour favorite menu again!.',
    ),
  );

  static Lang ind = Lang(
    bottomNav: BottomNav(
      nav1: "Riwayat",
      nav2: "Pesanan",
      nav3: "Profile",
    ),
    profile: LangProfile(
      nam: "Nama",
      tgl: "Tanggal",
      tlp: "No.Telepon",
      ub: "Ubah",
      ro: "Peran",
      role: "Kasir",
      role2: "Palangan",
      title: "Profil",
      subtitle: "Info Akun",
      subtitle2: "Info lainya",
      caption: "Kamu sudah verifikasi KTP",
      br: "Pin Baru",
      lm: "Pin Lama",
      bhs: "Ganti Bahasa",
    ),
    pesanan: LangPesanan(
      tap: "Sedang Berjalan",
      tap2: "Riwayat",
      mini: "Sedang Dipersiapkan",
      ongoingCaption: "Sudah Pesan?\nLacak pesananmu di sini.",
      riwayatCaption: 'Mulai buat pesanan.',
      riwayatCaption2:
          'Makanan yang kamu pesan\nakan muncul di sini agar\nkamu bisa menemukan\nmenu favoritmu lagi!.',
    ),
  );
}
