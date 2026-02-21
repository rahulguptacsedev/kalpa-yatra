import '../entities/lead.dart';

abstract class LeadRepository {
  Future<void> submitLead(Lead lead);
  Future<List<Lead>> getLeads(String tenantId);
  Future<void> updateLeadStatus(
    String tenantId,
    String leadId,
    LeadStatus status,
  );
}
