import 'package:arena/models/user/add_user_model.dart';
import 'package:arena/models/user/user_list_model.dart';
import 'package:arena/services/users/invite_user_service.dart';
import 'package:arena/services/users/user_list_service.dart';

class UserRepository {
  final UserListService _userListService;
  final InviteUserService _addUserService;

  UserRepository({
    UserListService? userListService,
    InviteUserService? addUserService,
  }) : _userListService = userListService ?? UserListService(),
       _addUserService = addUserService ?? InviteUserService();

  Future<UserListModel> getUserList({
    required String roleId,
    required String search,
    required int page,
    required int limit,
  }) {
    return _userListService.getUserList(
      roleId: roleId,
      search: search,
      page: page,
      limit: limit,
    );
  }

  Future<AddUserModel> invite(String email, String role) {
    return _addUserService.invite(email, role);
  }
}
