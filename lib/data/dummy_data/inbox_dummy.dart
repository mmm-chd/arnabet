import 'package:arena/models/enums/enums.dart';
import 'package:arena/models/inbox_model.dart';

class InboxDummy {
  static final inboxData = [
    InboxModel(
      id: 0,
      title: "Stok Menipis!",
      subtitle: "Ban Turanza T005A tersisa 10 pcs",
      subject: InboxSubject.stok,
      date: "12 Feb",
      isRead: false,
    ),
    InboxModel(
      id: 1,
      title: "Stok Terlalu Lama!",
      subtitle: "Batch DOT 2022 tidak bergerak 90 hari",
      subject: InboxSubject.aging,
      date: "11 Feb",
      isRead: false,
    ),
    InboxModel(
      id: 2,
      title: "Ada perubahan pada gudang",
      subtitle: "Terdapat adjustment pada gudang utama",
      subject: InboxSubject.perubahan,
      date: "10 Feb",
      isRead: false,
    ),
    InboxModel(
      id: 3,
      title: "User Baru Diaktifkan",
      subtitle: "Rina Staff sekarang memiliki akses kasir",
      subject: InboxSubject.pengguna,
      date: "9 Feb",
      isRead: false,
    ),
    InboxModel(
      id: 4,
      title: "User Baru Diaktifkan",
      subtitle: "Rina Staff sekarang memiliki akses kasir",
      subject: InboxSubject.pengguna,
      date: "9 Feb",
      isRead: false,
    ),
    InboxModel(
      id: 5,
      title: "User Baru Diaktifkan",
      subtitle: "Rina Staff sekarang memiliki akses kasir",
      subject: InboxSubject.pengguna,
      date: "9 Feb",
      isRead: false,
    ),
    InboxModel(
      id: 6,
      title: "Laporan Siap Diunduh",
      subtitle: "Stock Report Januari 2026",
      subject: InboxSubject.laporan,
      date: "8 Feb",
      isRead: false,
    ),
  ];
}
