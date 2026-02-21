class TenantResolver {
  static const String defaultTenantId = 'varanasi_default';

  /// Resolves the tenant ID from the current URL.
  /// Supports:
  /// 1. Path segments: /p/{tenantId}
  /// 2. Subdomains: {tenantId}.kalpa-yatra.com (Future proofing)
  static String resolve() {
    final uri = Uri.base;

    // 1. Check path segments first (Easy way)
    // Example: /p/client_a/dashboard -> segments are ['p', 'client_a', 'dashboard']
    final pathSegments = uri.pathSegments;
    if (pathSegments.length >= 2 && pathSegments[0] == 'p') {
      return pathSegments[1];
    }

    // 2. Check subdomains (For professional SaaS scaling)
    final hostParts = uri.host.split('.');
    if (hostParts.length >= 3 &&
        hostParts[0] != 'www' &&
        hostParts[0] != 'kalpa-yatra') {
      return hostParts[0];
    }

    // Default fallback
    return defaultTenantId;
  }
}
