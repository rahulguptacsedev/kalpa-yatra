import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  AdminUser? _currentUser;

  @override
  Future<AdminUser> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    // Look up tenant mapping from Firestore
    final uid = credential.user!.uid;
    final doc = await _firestore.collection('user_tenants').doc(uid).get();

    if (!doc.exists) {
      throw Exception(
        'No tenant mapping found for this user. '
        'Please add a document at user_tenants/$uid in Firestore.',
      );
    }

    _currentUser = AdminUser(
      email: email.trim(),
      tenantId: doc['tenantId'],
      displayName: doc['displayName'] ?? email,
    );
    return _currentUser!;
  }

  @override
  void logout() {
    _auth.signOut();
    _currentUser = null;
  }

  @override
  AdminUser? get currentUser => _currentUser;
}
