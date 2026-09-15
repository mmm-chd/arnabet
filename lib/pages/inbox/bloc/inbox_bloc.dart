import 'package:arena/data/dummy_data/inbox_dummy.dart';
import 'package:arena/models/inbox_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'inbox_event.dart';
import 'inbox_state.dart';

class InboxBloc extends Bloc<InboxEvent, InboxState> {
  List<InboxModel> allInbox = [];

  InboxBloc() : super(InboxInitial()) {
    on<LoadInbox>((event, emit) {
      allInbox = List<InboxModel>.from(InboxDummy.inboxData);
      emit(InboxLoaded(List.from(allInbox)));
    });

    on<SearchInbox>((event, emit) {
      final q = event.query.toLowerCase();
      final filtered = allInbox
          .where(
            (item) =>
                item.title.toLowerCase().contains(q) ||
                item.subtitle.toLowerCase().contains(q),
          )
          .toList();

      emit(InboxLoaded(filtered));
    });

    on<MarkAsRead>((event, emit) {
      allInbox = allInbox.map((item) {
        if (item.id == event.id) {
          return item.copyWith(isRead: true);
        }
        return item;
      }).toList();
      emit(InboxLoaded(List.from(allInbox)));
    });

    on<DeleteInbox>((event, emit) {
      allInbox = allInbox.where((item) => item.id != event.id).toList();
      emit(InboxLoaded(List.from(allInbox)));
    });

    on<FilterInbox>((event, emit) {
      if (event.type == "all") {
        emit(InboxLoaded(List.from(allInbox)));
        return;
      }

      if (event.type == "unread") {
        final filtered = allInbox.where((e) => !e.isRead).toList();
        emit(InboxLoaded(filtered));
        return;
      }

      if (event.type == "stock") {
        final filtered = allInbox
            .where((e) => e.title.contains("Stok"))
            .toList();
        emit(InboxLoaded(filtered));
        return;
      }

      if (event.type == "user") {
        final filtered = allInbox
            .where((e) => e.title.contains("User"))
            .toList();
        emit(InboxLoaded(filtered));
        return;
      }

      if (event.type == "report") {
        final filtered = allInbox
            .where((e) => e.title.contains("Laporan"))
            .toList();
        emit(InboxLoaded(filtered));
        return;
      }
    });
  }
}
