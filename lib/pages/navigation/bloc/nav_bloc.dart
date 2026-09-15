import 'package:flutter_bloc/flutter_bloc.dart';
import 'nav_event.dart';
import 'nav_state.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(const NavState()) {
    on<NavPageChanged>((event, emit) {
      emit(state.copyWith(selectedIndex: event.index));
    });

    on<ToggleRiwayatEvent>((event, emit) {
      emit(state.copyWith(isRiwayatOpen: !state.isRiwayatOpen));
    });

    on<ToggleBanEvent>((event, emit) {
      emit(state.copyWith(isBanOpen: !state.isBanOpen));
    });
  }
}
