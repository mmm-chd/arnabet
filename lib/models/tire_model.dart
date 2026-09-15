import 'package:arena/helper/safe_helpers.dart';

class TireModel {
  final String? id;
  final String nama;
  final String ukuran;
  final String ring;
  final String catatan;

  // Display Getters
  String get displayNama => safeString(nama);
  String get displayUkuran => safeString(ukuran);
  String get displayRing => safeString(ring);
  String get displayCatatan => safeString(catatan);

  TireModel({
    required this.id,
    required this.nama,
    required this.ukuran,
    required this.ring,
    required this.catatan,
  });
}
