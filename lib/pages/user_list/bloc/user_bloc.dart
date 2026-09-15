import 'package:arena/models/user/user_list_model.dart';
import 'package:arena/repositories/user/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arena/pages/user_list/bloc/user_event.dart';
import 'package:arena/pages/user_list/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _repository;

  String? _currentRoleId;

  UserBloc({required UserRepository repository})
    : _repository = repository,
      super(const UserState()) {
    on<LoadUserList>(_onLoadUserList);
    on<LoadMoreUsers>(_onLoadMoreUsers);
    on<FilterUser>(_onFilterUser);
    on<SearchUser>(_onSearchUser);
  }

  Future<void> _onLoadUserList(
    LoadUserList event,
    Emitter<UserState> emit,
  ) async {
    _currentRoleId = event.roleId;
    emit(state.copyWith(status: UserStatus.loading));
    try {
      final userListModel = await _repository.getUserList(
        roleId: event.roleId ?? '',
        search: '',
        page: 1,
        limit: state.limit,
      );

      if (userListModel.success == true) {
        final users = userListModel.data ?? [];
        final totalPages = userListModel.meta?.pagination?.totalPages ?? 1;
        emit(
          state.copyWith(
            status: UserStatus.ready,
            allUsers: users,
            filteredUsers: users,
            selectedRole: "",
            searchQuery: "",
            page: 1,
            hasReachedMax: 1 >= totalPages,
            errorMessage: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: UserStatus.failure,
            errorMessage:
                userListModel.message ?? "Gagal mengambil data pengguna",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: UserStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onLoadMoreUsers(
    LoadMoreUsers event,
    Emitter<UserState> emit,
  ) async {
    if (!state.isReady || state.hasReachedMax || state.isLoadingMore) return;

    emit(state.copyWith(status: UserStatus.loadingMore));
    try {
      final nextPage = state.page + 1;
      final userListModel = await _repository.getUserList(
        roleId: _currentRoleId ?? '',
        search: '',
        page: nextPage,
        limit: state.limit,
      );

      final newUsers = userListModel.data ?? [];
      final totalPages = userListModel.meta?.pagination?.totalPages ?? nextPage;
      final combined = [...state.allUsers, ...newUsers].cast<UserListDatum>();

      // Re-apply current filter/search to combined list
      final filtered = _applyFilter(
        users: combined,
        role: state.selectedRole,
        query: state.searchQuery,
      );

      emit(
        state.copyWith(
          status: UserStatus.ready,
          allUsers: combined,
          filteredUsers: filtered,
          page: nextPage,
          hasReachedMax: nextPage >= totalPages || newUsers.isEmpty,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: UserStatus.ready));
    }
  }

  void _onFilterUser(FilterUser event, Emitter<UserState> emit) {
    if (!state.isReady) return;

    final newRole = state.selectedRole == event.keyword ? "" : event.keyword;
    final filtered = _applyFilter(
      users: state.allUsers,
      role: newRole,
      query: state.searchQuery,
    );
    emit(
      state.copyWith(
        selectedRole: newRole,
        filteredUsers: filtered,
      ),
    );
  }

  void _onSearchUser(SearchUser event, Emitter<UserState> emit) {
    if (!state.isReady) return;

    final filtered = _applyFilter(
      users: state.allUsers,
      role: state.selectedRole,
      query: event.keyword,
    );
    emit(
      state.copyWith(
        searchQuery: event.keyword,
        filteredUsers: filtered,
      ),
    );
  }

  List<UserListDatum> _applyFilter({
    required List<UserListDatum> users,
    required String role,
    required String query,
  }) {
    List<UserListDatum> filtered = List.from(users);

    if (role.isNotEmpty) {
      filtered = filtered
          .where((u) => u.displayRole.toLowerCase() == role.toLowerCase())
          .toList();
    }

    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      filtered = filtered.where((u) {
        final name = u.displayName.toLowerCase();
        final email = u.displayEmail.toLowerCase();
        return name.contains(lowerQuery) || email.contains(lowerQuery);
      }).toList();
    }

    return filtered;
  }
}
