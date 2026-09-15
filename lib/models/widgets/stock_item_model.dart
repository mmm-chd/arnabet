import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/models/dot_model.dart';

class StockItemModel {
  final String id;
  final String productName;
  final String size;
  final String ring;
  final String note;
  final List<DotModel> dots;

  StockItemModel({
    required this.id,
    required this.productName,
    required this.size,
    required this.ring,
    required this.note,
    required this.dots,
  });

  StockItemModel copyWith({
    String? productName,
    String? size,
    String? ring,
    String? note,
    List<DotModel>? dots,
  }) {
    return StockItemModel(
      id: id,
      productName: productName ?? this.productName,
      size: size ?? this.size,
      ring: ring ?? this.ring,
      note: note ?? this.note,
      dots: dots ?? this.dots,
    );
  }

  int get totalPcs => dots.fold(0, (sum, e) => sum + e.jumlah);

  String get displayTotalPcs => totalPcs.toString();

  int get totalHarga =>
      dots.fold(0, (sum, e) => sum + (e.jumlah * (e.hargaBeli ?? 0)));

  String get displayTotalHarga => totalHarga.toLocaleCurrency();

  int get totalBatch => dots.length;

  String get displayTotalBatch => totalBatch.toString();
}
