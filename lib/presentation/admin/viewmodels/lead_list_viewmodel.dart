import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/lead.dart';
import '../../../domain/repositories/lead_repository.dart';

class LeadListViewModel extends StateNotifier<List<Lead>> {
  final LeadRepository _repo;
  String _tenantId = '';

  LeadListViewModel(this._repo) : super([]);

  Future<void> loadLeads(String tenantId) async {
    _tenantId = tenantId;
    state = await _repo.getLeads(tenantId);
  }

  Future<void> updateStatus(String leadId, LeadStatus newStatus) async {
    await _repo.updateLeadStatus(_tenantId, leadId, newStatus);
    // Reload from repo to stay in sync
    state = await _repo.getLeads(_tenantId);
  }

  int get leadsToday {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    return state.where((l) => l.timestamp.isAfter(todayStart)).length;
  }

  Future<void> refresh() async {
    if (_tenantId.isNotEmpty) {
      state = await _repo.getLeads(_tenantId);
    }
  }
}
