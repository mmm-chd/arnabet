import 'package:equatable/equatable.dart';

abstract class JasaEvent extends Equatable {
  const JasaEvent();

  @override
  List<Object?> get props => [];
}

class LoadServices extends JasaEvent {
  final String? search;

  const LoadServices({this.search});

  @override
  List<Object?> get props => [search];
}

class SearchService extends JasaEvent {
  final String keyword;

  const SearchService(this.keyword);

  @override
  List<Object?> get props => [keyword];
}

class AddService extends JasaEvent {
  final String name;
  final int price;

  const AddService({required this.name, required this.price});

  @override
  List<Object?> get props => [name, price];
}

class UpdateService extends JasaEvent {
  final int id;
  final String name;
  final int price;

  const UpdateService({
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, price];
}

class DeleteService extends JasaEvent {
  final int id;

  const DeleteService({required this.id});

  @override
  List<Object?> get props => [id];
}
