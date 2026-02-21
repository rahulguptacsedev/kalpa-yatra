import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/travel_service.dart';
import '../../domain/entities/itinerary.dart';
import '../../domain/repositories/travel_repository.dart';
import '../../data/repositories/firebase_travel_repository.dart';

final travelRepositoryProvider = Provider<TravelRepository>((ref) {
  return FirebaseTravelRepository();
});

final servicesProvider = FutureProvider<List<TravelService>>((ref) async {
  // Public portal uses default tenant
  return ref.watch(travelRepositoryProvider).getServices('varanasi_default');
});

final itinerariesProvider = FutureProvider<List<Itinerary>>((ref) async {
  return ref.watch(travelRepositoryProvider).getItineraries('varanasi_default');
});
