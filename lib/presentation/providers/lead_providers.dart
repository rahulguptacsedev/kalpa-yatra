import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/lead.dart';
import '../../domain/repositories/lead_repository.dart';
import '../../data/repositories/firebase_lead_repository.dart';

final leadRepositoryProvider = Provider<LeadRepository>((ref) {
  return FirebaseLeadRepository();
});

final leadSubmissionProvider = FutureProvider.family<void, Lead>((
  ref,
  lead,
) async {
  final repo = ref.read(leadRepositoryProvider);
  await repo.submitLead(lead);
});
