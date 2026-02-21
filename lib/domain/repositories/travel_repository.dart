import '../entities/travel_service.dart';
import '../entities/itinerary.dart';

abstract class TravelRepository {
  Future<List<TravelService>> getServices(String tenantId);
  Future<List<Itinerary>> getItineraries(String tenantId);

  Future<void> addService(String tenantId, TravelService service);
  Future<void> deleteService(String tenantId, String id);
  Future<void> updateService(String tenantId, TravelService service);

  Future<void> addItinerary(String tenantId, Itinerary itinerary);
  Future<void> deleteItinerary(String tenantId, String id);
  Future<void> updateItinerary(String tenantId, Itinerary itinerary);
}
