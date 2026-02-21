import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/admin_user.dart';
import '../../../domain/repositories/auth_repository.dart';

// Auth state sealed class hierarchy
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final AdminUser user;
  const AuthAuthenticated(this.user);
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _authRepo;

  AuthViewModel(this._authRepo) : super(const AuthInitial());

  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    try {
      final user = await _authRepo.login(email, password);
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void logout() {
    _authRepo.logout();
    state = const AuthInitial();
  }

  AdminUser? get currentUser {
    final s = state;
    if (s is AuthAuthenticated) {
      return s.user;
    }
    return null;
  }
}
