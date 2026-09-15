import 'package:arena/pages/jasa/bloc/jasa_event.dart';
import 'package:arena/pages/jasa/bloc/jasa_state.dart';
import 'package:arena/repositories/jasa/jasa_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JasaBloc extends Bloc<JasaEvent, JasaState> {
  final JasaRepository _repository;

  JasaBloc({required JasaRepository repository})
    : _repository = repository,
      super(const JasaState()) {
    on<LoadServices>(_onLoadServices);
    on<SearchService>(_onSearchService);
    on<AddService>(_onAddService);
    on<UpdateService>(_onUpdateService);
    on<DeleteService>(_onDeleteService);
  }

  Future<void> _onLoadServices(
    LoadServices event,
    Emitter<JasaState> emit,
  ) async {
    emit(
      state.copyWith(
        status: JasaStatus.loading,
        searchQuery: event.search ?? '',
      ),
    );
    try {
      final model = await _repository.getServices(search: event.search);
      emit(
        state.copyWith(status: JasaStatus.ready, services: model.data ?? []),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: JasaStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onSearchService(
    SearchService event,
    Emitter<JasaState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.keyword));
    add(LoadServices(search: event.keyword));
  }

  Future<void> _onAddService(AddService event, Emitter<JasaState> emit) async {
    emit(state.copyWith(status: JasaStatus.submitting));
    try {
      await _repository.addService(name: event.name, price: event.price);
      emit(state.copyWith(status: JasaStatus.success));
      add(const LoadServices());
    } catch (e) {
      emit(
        state.copyWith(
          status: JasaStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onUpdateService(
    UpdateService event,
    Emitter<JasaState> emit,
  ) async {
    emit(state.copyWith(status: JasaStatus.submitting));
    try {
      await _repository.updateService(
        id: event.id,
        name: event.name,
        price: event.price,
      );
      emit(state.copyWith(status: JasaStatus.success));
      add(const LoadServices());
    } catch (e) {
      emit(
        state.copyWith(
          status: JasaStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onDeleteService(
    DeleteService event,
    Emitter<JasaState> emit,
  ) async {
    emit(state.copyWith(status: JasaStatus.submitting));
    try {
      await _repository.deleteService(id: event.id);
      emit(state.copyWith(status: JasaStatus.success));
      add(const LoadServices());
    } catch (e) {
      emit(
        state.copyWith(
          status: JasaStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }
}
