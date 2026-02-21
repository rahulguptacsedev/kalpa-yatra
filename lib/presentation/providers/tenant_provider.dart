import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/tenant_resolver.dart';

/// Provides the currently active tenant ID based on URL.
final tenantIdProvider = Provider<String>((ref) {
  return TenantResolver.resolve();
});
