import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';
import 'package:arena/components/custom_filter_chip.dart';

class HistoryFilter extends StatelessWidget {
  final String text;

  const HistoryFilter({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        final selected =
            state.isReady && state.selectedFilter == text;

        return CustomFilterChip(
          label: text,
          isSelected: selected,
          onTap: () {
            context.read<HistoryBloc>().add(FilterHistory(text));
          },
        );
      },
    );
  }
}
