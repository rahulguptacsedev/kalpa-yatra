import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/itinerary.dart';
import '../../../domain/repositories/travel_repository.dart';

class ItineraryListViewModel extends StateNotifier<List<Itinerary>> {
  final TravelRepository _repo;
  String _tenantId = '';

  ItineraryListViewModel(this._repo) : super([]);

  Future<void> loadItineraries(String tenantId) async {
    _tenantId = tenantId;
    state = await _repo.getItineraries(tenantId);
  }

  Future<void> addItinerary(Itinerary itinerary) async {
    await _repo.addItinerary(_tenantId, itinerary);
    state = await _repo.getItineraries(_tenantId);
  }

  Future<void> deleteItinerary(String id) async {
    await _repo.deleteItinerary(_tenantId, id);
    state = await _repo.getItineraries(_tenantId);
  }

  Future<void> updateItinerary(Itinerary itinerary) async {
    await _repo.updateItinerary(_tenantId, itinerary);
    state = await _repo.getItineraries(_tenantId);
  }
}
