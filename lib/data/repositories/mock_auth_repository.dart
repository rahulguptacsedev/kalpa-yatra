import '../../domain/entities/admin_user.dart';
import '../../domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  AdminUser? _currentUser;

  // Demo tenant credentials
  static const _credentials = {
    'admin@kalpayatra.com': {
      'password': 'kashi123',
      'tenantId': 'varanasi_default',
      'displayName': 'Kalpa Yatra Admin',
    },
    'admin@rishikesh.com': {
      'password': 'rishi123',
      'tenantId': 'rishikesh_default',
      'displayName': 'Rishikesh Trails Admin',
    },
  };

  @override
  Future<AdminUser> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final cred = _credentials[email.toLowerCase().trim()];
    if (cred == null || cred['password'] != password) {
      throw Exception('Invalid email or password');
    }

    _currentUser = AdminUser(
      email: email.toLowerCase().trim(),
      tenantId: cred['tenantId']!,
      displayName: cred['displayName']!,
    );
    return _currentUser!;
  }

  @override
  void logout() {
    _currentUser = null;
  }

  @override
  AdminUser? get currentUser => _currentUser;
}
