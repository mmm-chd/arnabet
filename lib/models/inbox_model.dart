import 'package:arena/helper/safe_helpers.dart';
import 'package:arena/models/enums/enums.dart';

class InboxModel {
  final int id;
  final String title;
  final String subtitle;
  final InboxSubject subject;
  final String date;
  final bool isRead;

  InboxModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.subject,
    required this.date,
    this.isRead = false,
  });

  // Display Getters
  String get displayTitle => safeString(title);
  String get displaySubtitle => safeString(subtitle);
  String get displayDate => safeString(date);

  // UI Logic: Icons

  double get displaySizeIcon {
    return {
          InboxSubject.stok: 8.0,
          InboxSubject.perubahan: 4.0,
          InboxSubject.aging: 10.0,
          InboxSubject.pengguna: 12.0,
          InboxSubject.laporan: 12.0,
        }[subject] ??
        10.0;
  }

  // UI Logic: Colors

  bool get showDownloadButton => subject == InboxSubject.laporan;

  // Static parser for API data
  static InboxSubject parseSubject(String? val) {
    if (val == null) return InboxSubject.unknown;
    return InboxSubject.values.firstWhere(
      (e) => e.name == val.toLowerCase(),
      orElse: () => InboxSubject.unknown,
    );
  }

  InboxModel copyWith({bool? isRead}) {
    return InboxModel(
      id: id,
      title: title,
      subtitle: subtitle,
      subject: subject,
      date: date,
      isRead: isRead ?? this.isRead,
    );
  }
}
