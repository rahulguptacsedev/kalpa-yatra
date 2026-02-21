class TenantResolver {
  static const String defaultTenantId = 'varanasi_default';

  /// Resolves the tenant ID from the current URL.
  /// Supports:
  /// 1. Path segments: /p/{tenantId}
  /// 2. Subdomains: {tenantId}.kalpa-yatra.com (Future proofing)
  static String resolve() {
    final uri = Uri.base;
    final host = uri.host;

    // 1. Check for professional Subdomains/Custom Domains first
    // Example: rishikesh.kalpa-yatra.com or www.kashiexperience.com
    final hostParts = host.split('.');

    // Ignore common technical subdomains
    if (hostParts.length >= 2) {
      final firstPart = hostParts[0].toLowerCase();
      if (firstPart != 'www' &&
          firstPart != 'localhost' &&
          firstPart != 'kalpa-yatra' &&
          firstPart != 'kalpa-yatra-web-app') {
        // Firebase default domain base
        return firstPart;
      }
    }

    // 2. Check path segments (Legacy/Testing fallback)
    // Example: /p/client_a
    final pathSegments = uri.pathSegments;
    if (pathSegments.length >= 2 && pathSegments[0] == 'p') {
      return pathSegments[1];
    }

    // Default fallback
    return defaultTenantId;
  }
}
