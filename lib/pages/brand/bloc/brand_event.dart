import 'package:equatable/equatable.dart';

abstract class BrandEvent extends Equatable {
  const BrandEvent();

  @override
  List<Object?> get props => [];
}

class LoadBrands extends BrandEvent {
  final String? search;

  const LoadBrands({this.search});

  @override
  List<Object?> get props => [search];
}

class LoadMoreBrands extends BrandEvent {
  const LoadMoreBrands();
}

class SearchBrand extends BrandEvent {
  final String keyword;

  const SearchBrand(this.keyword);

  @override
  List<Object?> get props => [keyword];
}

class AddBrand extends BrandEvent {
  final String name;

  const AddBrand({required this.name});

  @override
  List<Object?> get props => [name];
}

class UpdateBrand extends BrandEvent {
  final int id;
  final String name;

  const UpdateBrand({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class DeleteBrand extends BrandEvent {
  final int id;

  const DeleteBrand({required this.id});

  @override
  List<Object?> get props => [id];
}
