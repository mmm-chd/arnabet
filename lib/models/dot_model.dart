import 'package:arena/helper/safe_helpers.dart';

class DotModel {
  final String kode;
  final int jumlah;
  final int? hargaBeli, hargaJual;

  DotModel({
    required this.kode,
    required this.jumlah,
    this.hargaBeli,
    this.hargaJual,
  });

  DotModel copyWith({
    String? kode,
    int? jumlah,
    int? hargaBeli,
    int? hargaJual,
  }) {
    return DotModel(
      kode: kode ?? this.kode,
      jumlah: jumlah ?? this.jumlah,
      hargaBeli: hargaBeli ?? this.hargaBeli,
      hargaJual: hargaJual ?? this.hargaJual,
    );
  }

  String get displayKode => safeString(kode);
}
