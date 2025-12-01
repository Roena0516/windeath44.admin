import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/dio_client.dart';
import '../data/repositories/user_repository.dart';
import '../data/models/user.dart';

// Repository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(DioClient());
});

// User list state
class UserListState {
  final UserListResponse? userList;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int pageSize;
  final String? keyword;
  final String? roleFilter;
  final String sortBy;

  UserListState({
    this.userList,
    this.isLoading = false,
    this.error,
    this.currentPage = 0,
    this.pageSize = 20,
    this.keyword,
    this.roleFilter,
    this.sortBy = 'createdAt,desc',
  });

  UserListState copyWith({
    UserListResponse? userList,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? pageSize,
    String? keyword,
    String? roleFilter,
    String? sortBy,
  }) {
    return UserListState(
      userList: userList ?? this.userList,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      keyword: keyword ?? this.keyword,
      roleFilter: roleFilter ?? this.roleFilter,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

// User list notifier
class UserListNotifier extends StateNotifier<UserListState> {
  final UserRepository _userRepository;

  UserListNotifier(this._userRepository) : super(UserListState());

  Future<void> fetchUsers({
    int? page,
    int? size,
    String? keyword,
    String? roleFilter,
    String? sortBy,
  }) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      currentPage: page ?? state.currentPage,
      pageSize: size ?? state.pageSize,
      keyword: keyword ?? state.keyword,
      roleFilter: roleFilter ?? state.roleFilter,
      sortBy: sortBy ?? state.sortBy,
    );

    try {
      final userList = await _userRepository.getUserList(
        page: state.currentPage,
        size: state.pageSize,
        keyword: state.keyword,
        roleFilter: state.roleFilter,
        sortBy: state.sortBy,
      );

      state = state.copyWith(
        userList: userList,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      await _userRepository.deleteUser(userId);
      // Refresh the user list
      await fetchUsers();
      return true;
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  void setPage(int page) {
    fetchUsers(page: page);
  }

  void setPageSize(int size) {
    fetchUsers(size: size, page: 0);
  }

  void setKeyword(String? keyword) {
    fetchUsers(keyword: keyword, page: 0);
  }

  void setRoleFilter(String? roleFilter) {
    fetchUsers(roleFilter: roleFilter, page: 0);
  }

  void setSortBy(String sortBy) {
    fetchUsers(sortBy: sortBy);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// User list state provider
final userListProvider = StateNotifierProvider<UserListNotifier, UserListState>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return UserListNotifier(userRepository);
});

// Create admin state
class CreateAdminState {
  final bool isLoading;
  final String? error;
  final bool success;

  CreateAdminState({
    this.isLoading = false,
    this.error,
    this.success = false,
  });

  CreateAdminState copyWith({
    bool? isLoading,
    String? error,
    bool? success,
  }) {
    return CreateAdminState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success ?? this.success,
    );
  }
}

// Create admin notifier
class CreateAdminNotifier extends StateNotifier<CreateAdminState> {
  final UserRepository _userRepository;

  CreateAdminNotifier(this._userRepository) : super(CreateAdminState());

  Future<bool> createAdmin({
    required String userId,
    required String email,
    required String name,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null, success: false);

    try {
      await _userRepository.createAdminAccount(
        userId: userId,
        email: email,
        name: name,
        password: password,
      );

      state = state.copyWith(
        isLoading: false,
        success: true,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  void reset() {
    state = CreateAdminState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Create admin state provider
final createAdminProvider = StateNotifierProvider<CreateAdminNotifier, CreateAdminState>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return CreateAdminNotifier(userRepository);
});
