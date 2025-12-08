import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/dio_client.dart';
import '../models/auth_response.dart';

class AuthRepository {
  final DioClient _dioClient;

  AuthRepository(this._dioClient);

  /// Login with userId and password
  Future<String> login(String userId, String password) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.login,
        data: {
          'userId': userId,
          'password': password,
        },
      );

      // Try to extract token from various locations
      String? token;

      // 1. Try headers
      token = response.headers.value('Authorization') ??
          response.headers.value('authorization') ??
          response.headers.value('x-auth-token') ??
          response.headers.value('access-token');

      // 2. Try response body
      if (token == null && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        token = data['token'] ?? data['accessToken'] ?? data['access_token'] ?? data['authToken'];
      }

      // Remove 'Bearer ' prefix if present
      if (token != null && token.startsWith('Bearer ')) {
        token = token.substring(7);
      }

      if (token == null || token.isEmpty) {
        throw Exception('No token received from server');
      }

      return token;
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Login failed');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Verify user profile and check if user is ADMIN
  Future<ProfileResponse> verifyProfile(String token) async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.userProfile,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final profileResponse = ProfileResponse.fromJson(response.data);

      if (profileResponse.data.role != 'ADMIN') {
        throw Exception('Access denied: Admins only');
      }

      return profileResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid or expired token');
      }
      throw Exception('Failed to verify profile: ${e.message}');
    }
  }

  /// Send email verification code
  Future<void> sendEmailVerification(String email) async {
    try {
      await _dioClient.dio.post(
        ApiConstants.emailVerify,
        data: {'email': email},
      );
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Failed to send verification email');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Validate email verification code
  Future<void> validateEmailCode(String email, String code) async {
    try {
      await _dioClient.dio.patch(
        ApiConstants.emailValid,
        data: {
          'email': email,
          'code': code,
        },
      );
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Invalid verification code');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Save auth token locally
  Future<void> saveToken(String token) async {
    await _dioClient.setAuthToken(token);
  }

  /// Get stored auth token
  Future<String?> getToken() async {
    return await _dioClient.getAuthToken();
  }

  /// Clear auth token (logout)
  Future<void> clearToken() async {
    await _dioClient.clearAuthToken();
  }
}
