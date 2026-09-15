import 'package:arena/models/user/user_list_model.dart';
import 'package:equatable/equatable.dart';

enum UserStatus { initial, loading, loadingMore, ready, failure }

class UserState extends Equatable {
  final UserStatus status;

  final List<UserListDatum> allUsers;
  final List<UserListDatum> filteredUsers;

  final String selectedRole;
  final String searchQuery;

  final int page;
  final int limit;
  final bool hasReachedMax;

  final String? errorMessage;

  const UserState({
    this.status = UserStatus.initial,
    this.allUsers = const [],
    this.filteredUsers = const [],
    this.selectedRole = "",
    this.searchQuery = "",
    this.page = 1,
    this.limit = 20,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    status,
    allUsers,
    filteredUsers,
    selectedRole,
    searchQuery,
    page,
    limit,
    hasReachedMax,
    errorMessage,
  ];

  UserState copyWith({
    UserStatus? status,
    List<UserListDatum>? allUsers,
    List<UserListDatum>? filteredUsers,
    String? selectedRole,
    String? searchQuery,
    int? page,
    int? limit,
    bool? hasReachedMax,
    Object? errorMessage = _sentinel,
  }) {
    return UserState(
      status: status ?? this.status,
      allUsers: allUsers ?? this.allUsers,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      selectedRole: selectedRole ?? this.selectedRole,
      searchQuery: searchQuery ?? this.searchQuery,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  bool get isLoading => status == UserStatus.loading;
  bool get isLoadingMore => status == UserStatus.loadingMore;
  bool get isReady => status == UserStatus.ready;
  bool get isFailure => status == UserStatus.failure;
  bool get isEmpty => isReady && filteredUsers.isEmpty;
}

const _sentinel = Object();
