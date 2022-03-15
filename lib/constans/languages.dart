import 'package:kitchen/models/lang.dart';

class ConstLang {
  static Lang eng = Lang(
    bottomNav: BottomNav(
      nav1: "Home",
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
        caption: ProfileCation(
          status1: 'You haven\'t verified your ID card',
          status2: 'On proses verification ID Card',
          status3: 'You have verified your ID card',
        ),
        br: "New Pin",
        lm: "Old Pin",
        bhs: "Change Language",
        penilaian: "Rating",
        nilai_sekarang: "Rate Now",
        namaPerangkat: 'Device Info'),
    pesanan: LangPesanan(
      tap: "Ongoing",
      tap2: "History",
      mini: "Being Prepared",
      allStatus: "All Status",
      status: "In queue",
      status2: "On cooking",
      statusB: "Can take",
      status3: "Complete",
      status4: "Canceled",
      buttonPe: "Give Rating",
      buttonLa: "Order Again",
      ongoingCaption: "Already Ordered?\nTrack your order here.",
      riwayatCaption: 'Start ordering.',
      riwayatCaption2:
          'The food you ordered\n appears here so\nyou can find\nyour favorite menu again!',
      totalOr: 'Total Orders',
    ),
  );

  static Lang ind = Lang(
    bottomNav: BottomNav(
      nav1: "Beranda",
      nav2: "Pesanan",
      nav3: "Profil",
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
        caption: ProfileCation(
          status1: 'Kamu sudah verifikasi KTP',
          status2: 'Dalam proses verifikasi KTP',
          status3: 'Kamu sudah verifikasi KTP',
        ),
        br: "Pin Baru",
        lm: "Pin Lama",
        bhs: "Ganti Bahasa",
        penilaian: "Penilaian",
        nilai_sekarang: "Nilai Sekarang",
        namaPerangkat: 'Info Perangkat'),
    pesanan: LangPesanan(
      tap: "Sedang Berjalan",
      tap2: "Riwayat",
      mini: "Sedang Dipersiapkan",
      allStatus: "Semua Status",
      status: "Dalam antrian",
      status2: "Sedang dipersiapkan",
      statusB: "Bisa diambil",
      status3: "Selesai",
      status4: "Dibatalkan",
      buttonPe: "Beri Penilaian",
      buttonLa: "Pesan Lagi",
      ongoingCaption: "Sudah Pesan?\nLacak pesananmu di sini.",
      riwayatCaption: 'Mulai buat pesanan.',
      riwayatCaption2:
          'Makanan yang kamu pesan\nakan muncul di sini agar\nkamu bisa menemukan\nmenu favoritmu lagi!.',
      totalOr: 'Total Pesanan',
    ),
  );
}
