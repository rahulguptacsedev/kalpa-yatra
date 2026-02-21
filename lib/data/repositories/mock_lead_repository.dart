import 'dart:developer' as developer;
import '../../domain/entities/lead.dart';
import '../../domain/repositories/lead_repository.dart';

class MockLeadRepository implements LeadRepository {
  final List<Lead> _leads = [];

  MockLeadRepository() {
    _seedData();
  }

  void _seedData() {
    final now = DateTime.now();
    _leads.addAll([
      Lead(
        id: 'lead_1',
        name: 'Ananya Verma',
        phone: '9198765001',
        serviceInterest: 'Morning Boat Ride on the Ganges',
        timestamp: now.subtract(const Duration(hours: 2)),
        status: LeadStatus.newLead,
        tenantId: 'varanasi_default',
      ),
      Lead(
        id: 'lead_2',
        name: 'Rohan Mehra',
        phone: '9198765002',
        serviceInterest: 'Sacred Temple Darshan Circuit',
        timestamp: now.subtract(const Duration(hours: 5)),
        status: LeadStatus.contacted,
        tenantId: 'varanasi_default',
      ),
      Lead(
        id: 'lead_3',
        name: 'Priya Singh',
        phone: '9198765003',
        serviceInterest: 'Heritage Walk & Food Trail',
        timestamp: now.subtract(const Duration(days: 1)),
        status: LeadStatus.newLead,
        tenantId: 'varanasi_default',
      ),
      Lead(
        id: 'lead_4',
        name: 'Vikram Joshi',
        phone: '9198765004',
        serviceInterest: 'Morning Boat Ride on the Ganges',
        timestamp: now,
        status: LeadStatus.newLead,
        tenantId: 'varanasi_default',
      ),
      Lead(
        id: 'lead_5',
        name: 'Meera Patel',
        phone: '9198765005',
        serviceInterest: 'Sacred Temple Darshan Circuit',
        timestamp: now.subtract(const Duration(days: 2)),
        status: LeadStatus.contacted,
        tenantId: 'varanasi_default',
      ),
    ]);
  }

  List<Lead> get leads => List.unmodifiable(_leads);

  @override
  Future<void> submitLead(Lead lead) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _leads.insert(0, lead);
    developer.log(
      '✅ Lead submitted: ${lead.toMap()}',
      name: 'MockLeadRepository',
    );
  }

  @override
  Future<List<Lead>> getLeads(String tenantId) async {
    return _leads.where((l) => l.tenantId == tenantId).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  Future<void> updateLeadStatus(
    String tenantId,
    String leadId,
    LeadStatus status,
  ) async {
    final index = _leads.indexWhere((l) => l.id == leadId);
    if (index != -1) {
      _leads[index] = _leads[index].copyWith(status: status);
      developer.log(
        '✅ Lead $leadId status → ${status.name}',
        name: 'MockLeadRepository',
      );
    }
  }
}
