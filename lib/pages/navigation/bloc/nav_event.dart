import 'package:equatable/equatable.dart';

abstract class NavEvent extends Equatable {
  const NavEvent();
  @override
  List<Object> get props => [];
}

class NavPageChanged extends NavEvent {
  final int index;
  const NavPageChanged(this.index);
}

class ToggleRiwayatEvent extends NavEvent {}

class ToggleBanEvent extends NavEvent {}
