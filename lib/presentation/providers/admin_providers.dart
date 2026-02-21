import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/lead_repository.dart';
import '../../domain/repositories/travel_repository.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../../data/repositories/firebase_lead_repository.dart';
import '../../data/repositories/firebase_travel_repository.dart';
import '../admin/viewmodels/auth_viewmodel.dart';
import '../admin/viewmodels/lead_list_viewmodel.dart';
import '../admin/viewmodels/service_list_viewmodel.dart';
import '../admin/viewmodels/itinerary_list_viewmodel.dart';

// ── Repository Providers ────────────────────────────
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

final adminLeadRepositoryProvider = Provider<LeadRepository>((ref) {
  return FirebaseLeadRepository();
});

final adminTravelRepositoryProvider = Provider<TravelRepository>((ref) {
  return FirebaseTravelRepository();
});

// ── ViewModel Providers ─────────────────────────────
final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((
  ref,
) {
  return AuthViewModel(ref.read(authRepositoryProvider));
});

final leadListViewModelProvider =
    StateNotifierProvider<LeadListViewModel, List>((ref) {
      return LeadListViewModel(ref.read(adminLeadRepositoryProvider));
    });

final serviceListViewModelProvider =
    StateNotifierProvider<ServiceListViewModel, List>((ref) {
      return ServiceListViewModel(ref.read(adminTravelRepositoryProvider));
    });

final itineraryListViewModelProvider =
    StateNotifierProvider<ItineraryListViewModel, List>((ref) {
      return ItineraryListViewModel(ref.read(adminTravelRepositoryProvider));
    });

// ── Computed Providers ──────────────────────────────
final leadsTodayProvider = Provider<int>((ref) {
  return ref.read(leadListViewModelProvider.notifier).leadsToday;
});

final activeServicesCountProvider = Provider<int>((ref) {
  final services = ref.watch(serviceListViewModelProvider);
  return services.length;
});

final popularItineraryProvider = Provider<String>((ref) {
  return '2-Day Kashi Spiritual Journey';
});
