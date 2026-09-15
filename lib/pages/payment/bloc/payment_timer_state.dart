import 'package:equatable/equatable.dart';

class PaymentTimerState extends Equatable {
  final Duration remaining;
  final double progress;
  final bool isExpired;

  const PaymentTimerState({
    this.remaining = const Duration(minutes: 10),
    this.progress = 1.0,
    this.isExpired = false,
  });

  @override
  List<Object?> get props => [remaining, progress, isExpired];

  PaymentTimerState copyWith({
    Duration? remaining,
    double? progress,
    bool? isExpired,
  }) {
    return PaymentTimerState(
      remaining: remaining ?? this.remaining,
      progress: progress ?? this.progress,
      isExpired: isExpired ?? this.isExpired,
    );
  }
}
