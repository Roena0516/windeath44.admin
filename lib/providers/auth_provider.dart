import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/dio_client.dart';
import '../data/repositories/auth_repository.dart';
import '../data/models/auth_response.dart';

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(DioClient());
});

// Auth state
class AuthState {
  final ProfileData? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    ProfileData? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final token = await _authRepository.getToken();
    if (token != null && token.isNotEmpty) {
      try {
        final profileResponse = await _authRepository.verifyProfile(token);
        state = state.copyWith(
          user: profileResponse.data,
          isAuthenticated: true,
        );
      } catch (e) {
        // Token is invalid, clear it
        await _authRepository.clearToken();
        state = state.copyWith(
          isAuthenticated: false,
          user: null,
        );
      }
    } else {
      state = state.copyWith(isAuthenticated: false);
    }
  }

  Future<bool> login(String userId, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Step 1: Login and get token
      final token = await _authRepository.login(userId, password);

      // Step 2: Verify profile and check ADMIN role
      final profileResponse = await _authRepository.verifyProfile(token);

      // Step 3: Save token
      await _authRepository.saveToken(token);

      // Step 4: Update state
      state = state.copyWith(
        user: profileResponse.data,
        isAuthenticated: true,
        isLoading: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
        isAuthenticated: false,
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _authRepository.clearToken();
    state = AuthState();
  }

  Future<bool> sendEmailVerification(String email) async {
    try {
      await _authRepository.sendEmailVerification(email);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> validateEmailCode(String email, String code) async {
    try {
      await _authRepository.validateEmailCode(email, code);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Auth state provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});
