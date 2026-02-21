import '../entities/admin_user.dart';

abstract class AuthRepository {
  Future<AdminUser> login(String email, String password);
  void logout();
  AdminUser? get currentUser;
}
