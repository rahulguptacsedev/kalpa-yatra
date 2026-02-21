import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/client_config.dart';
import 'tenant_provider.dart';

class ClientConfigNotifier extends StateNotifier<ClientConfig> {
  ClientConfigNotifier(String tenantId) : super(ClientConfig.defaultConfig) {
    // Auto-load the tenant config resolved from the URL
    loadFromFirestore(tenantId);
  }

  Future<void> loadFromFirestore(String tenantId) async {
    final doc = await FirebaseFirestore.instance
        .collection('tenants')
        .doc(tenantId)
        .get();
    if (doc.exists) {
      state = ClientConfig.fromMap(tenantId, doc.data()!);
    }
  }

  Future<void> saveToFirestore() async {
    await FirebaseFirestore.instance
        .collection('tenants')
        .doc(state.tenantId)
        .set(state.toMap());
  }

  void updateConfig(ClientConfig newConfig) {
    state = newConfig;
  }

  void updateField({
    String? clientName,
    String? primaryColorHex,
    String? logoUrl,
    String? whatsappNumber,
    String? supportEmail,
    String? contactPersonName,
  }) {
    state = state.copyWith(
      clientName: clientName,
      primaryColorHex: primaryColorHex,
      logoUrl: logoUrl,
      whatsappNumber: whatsappNumber,
      supportEmail: supportEmail,
      contactPersonName: contactPersonName,
    );
    // Auto-persist to Firestore
    saveToFirestore();
  }
}

final clientConfigProvider =
    StateNotifierProvider<ClientConfigNotifier, ClientConfig>((ref) {
      final tenantId = ref.watch(tenantIdProvider);
      return ClientConfigNotifier(tenantId);
    });
