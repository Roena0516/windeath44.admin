import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/dio_client.dart';
import '../models/user.dart';

class UserRepository {
  final DioClient _dioClient;

  UserRepository(this._dioClient);

  /// Get user list with pagination and filters
  Future<UserListResponse> getUserList({
    int page = 0,
    int size = 20,
    String? keyword,
    String? roleFilter,
    String sortBy = 'createdAt,desc',
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'size': size.toString(),
        'sort': sortBy,
      };

      if (keyword != null && keyword.isNotEmpty) {
        queryParams['keyword'] = keyword;
      }

      if (roleFilter != null && roleFilter.isNotEmpty) {
        queryParams['roleFilter'] = roleFilter;
      }

      final response = await _dioClient.dio.get(
        ApiConstants.usersAdmin,
        queryParameters: queryParams,
        options: Options(
          headers: {
            'role': 'ADMIN',
          },
        ),
      );

      final apiResponse = response.data as Map<String, dynamic>;
      final data = apiResponse['data'] as Map<String, dynamic>;

      return UserListResponse.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Failed to fetch users');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Get user profile
  Future<User> getUserProfile() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.userProfile);

      final apiResponse = response.data as Map<String, dynamic>;
      final data = apiResponse['data'] as Map<String, dynamic>;

      return User.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Failed to fetch profile');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Create admin account
  Future<void> createAdminAccount({
    required String userId,
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      await _dioClient.dio.post(
        ApiConstants.registerAdmin,
        data: {
          'userId': userId,
          'email': email,
          'name': name,
          'password': password,
        },
      );
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Failed to create admin account');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await _dioClient.dio.delete(
        ApiConstants.users,
        data: {'userId': userId},
      );
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Failed to delete user');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Change user profile picture
  Future<void> changeProfile(String profileUrl) async {
    try {
      await _dioClient.dio.put(
        ApiConstants.changeProfile,
        data: {'profile': profileUrl},
      );
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Failed to change profile');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Change user name
  Future<void> changeName(String name) async {
    try {
      await _dioClient.dio.put(
        ApiConstants.changeName,
        data: {'name': name},
      );
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Failed to change name');
      }
      throw Exception('Network error: ${e.message}');
    }
  }
}
