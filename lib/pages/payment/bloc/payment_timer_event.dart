import 'package:equatable/equatable.dart';

abstract class PaymentTimerEvent extends Equatable {
  const PaymentTimerEvent();

  @override
  List<Object?> get props => [];
}

class StartTimer extends PaymentTimerEvent {
  final Duration duration;

  const StartTimer({this.duration = const Duration(minutes: 10)});

  @override
  List<Object?> get props => [duration];
}

class TimerTick extends PaymentTimerEvent {
  const TimerTick();
}
