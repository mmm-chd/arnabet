import 'package:equatable/equatable.dart';

class NavState extends Equatable {
  final int selectedIndex;
  final bool isRiwayatOpen;
  final bool isBanOpen;

  const NavState({
    this.selectedIndex = 1,
    this.isRiwayatOpen = false,
    this.isBanOpen = false,
  });

  NavState copyWith({
    int? selectedIndex,
    bool? isRiwayatOpen,
    bool? isBanOpen,
  }) {
    return NavState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isRiwayatOpen: isRiwayatOpen ?? this.isRiwayatOpen,
      isBanOpen: isBanOpen ?? this.isBanOpen,
    );
  }  

  @override
  List<Object> get props => [selectedIndex, isRiwayatOpen, isBanOpen];
}
