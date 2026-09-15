import 'package:arena/models/inbox_model.dart';
import 'package:equatable/equatable.dart';

abstract class InboxState extends Equatable{
  const InboxState();

  @override
  List<Object> get props => [];
}

class InboxInitial extends InboxState {}

class InboxLoading extends InboxState {}

class InboxLoaded extends InboxState {
  final List<InboxModel> inbox;

  const InboxLoaded(this.inbox);

  @override
  List<Object> get props => [inbox];
}
