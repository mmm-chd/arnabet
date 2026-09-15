import 'package:arena/models/dot_model.dart';
import 'package:arena/models/tire_model.dart';

sealed class AddStockEvent {}

class InitializeAddStock extends AddStockEvent {
  final TireModel tire;

  InitializeAddStock({required this.tire});
}

class LoadProductNames extends AddStockEvent {}

class LoadMoreProductNames extends AddStockEvent {}

class SearchProductNames extends AddStockEvent {
  final String query;
  SearchProductNames(this.query);
}

class ProductSelected extends AddStockEvent {
  final String productName;
  ProductSelected(this.productName);
}

class SizeSelected extends AddStockEvent {
  final String size;
  SizeSelected(this.size);
}

class RingSelected extends AddStockEvent {
  final String ring;
  RingSelected(this.ring);
}

class NoteChanged extends AddStockEvent {
  final String note;
  NoteChanged(this.note);
}

class DotAdded extends AddStockEvent {
  final DotModel dot;
  DotAdded(this.dot);
}

class DotUpdated extends AddStockEvent {
  final int index;
  final DotModel dot;
  DotUpdated(this.index, this.dot);
}

class DotRemoved extends AddStockEvent {
  final int index;
  DotRemoved(this.index);
}

class SaveStockItem extends AddStockEvent {}

class EditStockItem extends AddStockEvent {
  final String id;
  EditStockItem(this.id);
}

class DiscardCurrentItem extends AddStockEvent {}

class RemoveStockItems extends AddStockEvent {
  final List<String> ids;
  RemoveStockItems(this.ids);
}

class SubmitPressed extends AddStockEvent {}

class ResetAddStock extends AddStockEvent {}

class LoadExistingStock extends AddStockEvent {
  final String productName;
  final String size;
  final String ring;
  final String note;
  final List<DotModel> dots;

  LoadExistingStock({
    required this.productName,
    required this.size,
    required this.ring,
    this.note = '',
    required this.dots,
  });
}