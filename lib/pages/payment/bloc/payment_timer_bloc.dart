import 'dart:async';

import 'package:arena/pages/payment/bloc/payment_timer_event.dart';
import 'package:arena/pages/payment/bloc/payment_timer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentTimerBloc extends Bloc<PaymentTimerEvent, PaymentTimerState> {
  Timer? _timer;
  static const _totalDuration = Duration(minutes: 10);

  PaymentTimerBloc() : super(const PaymentTimerState()) {
    on<StartTimer>(_onStart);
    on<TimerTick>(_onTick);
  }

  void _onStart(StartTimer event, Emitter<PaymentTimerState> emit) {
    _timer?.cancel();
    emit(PaymentTimerState(remaining: event.duration));
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const TimerTick());
    });
  }

  void _onTick(TimerTick event, Emitter<PaymentTimerState> emit) {
    final current = state.remaining;
    if (current.inSeconds <= 0) {
      _timer?.cancel();
      emit(
        const PaymentTimerState(
          isExpired: true,
          remaining: Duration.zero,
          progress: 0.0,
        ),
      );
      return;
    }
    final newRemaining = current - const Duration(seconds: 1);
    final progress = newRemaining.inSeconds / _totalDuration.inSeconds;
    emit(state.copyWith(remaining: newRemaining, progress: progress));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
