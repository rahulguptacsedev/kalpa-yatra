import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/lead.dart';
import '../../domain/repositories/lead_repository.dart';

class FirebaseLeadRepository implements LeadRepository {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference _leadsRef(String tenantId) =>
      _firestore.collection('tenants').doc(tenantId).collection('leads');

  @override
  Future<void> submitLead(Lead lead) async {
    await _leadsRef(lead.tenantId).add(lead.toMap());
  }

  @override
  Future<List<Lead>> getLeads(String tenantId) async {
    final snapshot = await _leadsRef(
      tenantId,
    ).orderBy('timestamp', descending: true).get();
    return snapshot.docs
        .map((doc) => Lead.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> updateLeadStatus(
    String tenantId,
    String leadId,
    LeadStatus status,
  ) async {
    await _leadsRef(tenantId).doc(leadId).update({'status': status.name});
  }
}
