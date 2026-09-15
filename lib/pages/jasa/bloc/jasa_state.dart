import 'package:arena/models/jasa/jasa_list_model.dart';
import 'package:equatable/equatable.dart';

enum JasaStatus { initial, loading, ready, failure, submitting, success }

class JasaState extends Equatable {
  final JasaStatus status;
  final List<Datum> services;
  final String? errorMessage;
  final String searchQuery;

  const JasaState({
    this.status = JasaStatus.initial,
    this.services = const [],
    this.errorMessage,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [status, services, errorMessage, searchQuery];

  JasaState copyWith({
    JasaStatus? status,
    List<Datum>? services,
    Object? errorMessage = _sentinel,
    String? searchQuery,
  }) {
    return JasaState(
      status: status ?? this.status,
      services: services ?? this.services,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get isInitial => status == JasaStatus.initial;
  bool get isLoading => status == JasaStatus.loading;
  bool get isReady => status == JasaStatus.ready;
  bool get isFailure => status == JasaStatus.failure;
  bool get isSubmitting => status == JasaStatus.submitting;
  bool get isSuccess => status == JasaStatus.success;
  bool get isEmpty => services.isEmpty;
}

const _sentinel = Object();
