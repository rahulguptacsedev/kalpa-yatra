import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/travel_service.dart';
import '../../domain/entities/itinerary.dart';
import '../../domain/repositories/travel_repository.dart';
import '../../data/repositories/firebase_travel_repository.dart';
import 'tenant_provider.dart';

final travelRepositoryProvider = Provider<TravelRepository>((ref) {
  return FirebaseTravelRepository();
});

final servicesProvider = FutureProvider<List<TravelService>>((ref) async {
  final tenantId = ref.watch(tenantIdProvider);
  return ref.watch(travelRepositoryProvider).getServices(tenantId);
});

final itinerariesProvider = FutureProvider<List<Itinerary>>((ref) async {
  final tenantId = ref.watch(tenantIdProvider);
  return ref.watch(travelRepositoryProvider).getItineraries(tenantId);
});
